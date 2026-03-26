import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../models/answer_evaluation.dart';
import '../models/nlp_question.dart';

class NlpQuizService {
  NlpQuizService({FirebaseFirestore? firestore, http.Client? client})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _client = client ?? http.Client();

  final FirebaseFirestore _firestore;
  final http.Client _client;


  Future<List<NlpQuestion>> fetchQuestions({
    required String level,
    required String scenario,
  }) async {
    final snapshot = await _firestore
        .collection('topics') // Mengambil dari koleksi utama 'topics'
        .doc(scenario.toLowerCase()) // Langsung membaca nama tema (misal: 'airport')
        .collection('items') // Di dalam tema, akan ada sub-koleksi 'items' tempat soal berada
        .get();

    final questions = snapshot.docs
        .map((doc) => NlpQuestion.fromMap(doc.id, doc.data()))
        .where((q) => q.soal.trim().isNotEmpty && q.jawabanBenar.trim().isNotEmpty)
        .toList();

    return questions;
  }

  Future<AnswerEvaluation> evaluateAnswer({
    required String soal,
    required String jawabanUser,
    required String jawabanBenar,
  }) async {
    const String apiUrl = "http://206.189.46.79:8080/evaluate";

    try {
      final response = await _client.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'soal': soal,
          'jawaban_benar': jawabanBenar,
          'jawaban_user': jawabanUser,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final payload = jsonDecode(response.body) as Map<String, dynamic>;
        
        final similarityRaw = payload['similarity'];
        final similarity = similarityRaw is num
            ? (similarityRaw > 1 ? similarityRaw / 100 : similarityRaw).toDouble()
            : 0.0;

        return AnswerEvaluation(
          similarity: similarity,
          status: payload['status']?.toString() ?? _resolveStatus(similarity, null),
          cleanedUserAnswer: payload['cleaned_user']?.toString() ?? _cleanText(jawabanUser),
          cleanedCorrectAnswer: payload['cleaned_reference']?.toString() ?? _cleanText(jawabanBenar),
          reason: payload['reason']?.toString() ?? "Dievaluasi oleh Gemini",
        );
      } else {
        throw Exception("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      if (e is FormatException) {
         // silent error for debugging non json response
      }
      
      // Fallback lokal jika API Error / RTO
      return _evaluateLocally(
        jawabanUser: jawabanUser,
        jawabanBenar: jawabanBenar,
      );
    }
  }

  AnswerEvaluation _evaluateLocally({
    required String jawabanUser,
    required String jawabanBenar,
  }) {
    final cleanedUser = _cleanText(jawabanUser);
    final cleanedCorrect = _cleanText(jawabanBenar);
    final similarity = _jaccardSimilarity(cleanedUser, cleanedCorrect);

    return AnswerEvaluation(
      similarity: similarity,
      status: _resolveStatus(similarity, null),
      cleanedUserAnswer: cleanedUser,
      cleanedCorrectAnswer: cleanedCorrect,
      reason: 'Dinilai menggunakan sistem evaluasi offline (API sedang tidak merespon).',
    );
  }

  String _cleanText(String text) {
    final lower = text.toLowerCase();
    final noPunctuation = lower.replaceAll(RegExp(r'[^a-z0-9\s]'), ' ');
    return noPunctuation.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  double _jaccardSimilarity(String a, String b) {
    if (a.isEmpty || b.isEmpty) return 0.0;

    final aTokens = a.split(' ').where((e) => e.isNotEmpty).toSet();
    final bTokens = b.split(' ').where((e) => e.isNotEmpty).toSet();

    final intersection = aTokens.intersection(bTokens).length;
    final union = aTokens.union(bTokens).length;

    if (union == 0) return 0.0;
    return intersection / union;
  }

  String _resolveStatus(double similarity, String? backendStatus) {
    if (backendStatus != null && backendStatus.trim().isNotEmpty) {
      return backendStatus.trim().toLowerCase();
    }

    if (similarity >= 0.80) return 'benar';
    if (similarity >= 0.65) return 'hampir benar';
    return 'kurang tepat';
  }
}
