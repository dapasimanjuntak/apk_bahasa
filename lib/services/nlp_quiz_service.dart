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
    required String languageCode,
  }) async {
    final snapshot = await _firestore
        .collection('topics') // Mengambil dari koleksi utama 'topics'
        .doc(scenario.toLowerCase()) // Langsung membaca nama tema (misal: 'airport')
        .collection('items') // Di dalam tema, akan ada sub-koleksi 'items' tempat soal berada
        .get();

    final questions = snapshot.docs
        .map((doc) => NlpQuestion.fromMap(doc.id, doc.data(), languageCode))
        .where((q) => q.soal.trim().isNotEmpty && q.jawabanBenar.trim().isNotEmpty)
        .toList();

    return questions;
  }

  Future<AnswerEvaluation> evaluateAnswer({
    required String soal,
    required String jawabanUser,
    required String jawabanBenar,
    required String languageCode,
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
          'target_language': languageCode, // Memberitahu AI untuk merespon dalam bahasa ini
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final payload = jsonDecode(response.body) as Map<String, dynamic>;
        
        final similarityRaw = payload['similarity'];
        final similarity = similarityRaw is num
            ? (similarityRaw > 1 ? similarityRaw / 100 : similarityRaw).toDouble()
            : 0.0;

        final defaultReasons = {
          'en': 'Evaluated by Gemini AI',
          'id': 'Dievaluasi oleh Gemini AI',
          'ru': 'Оценено Gemini AI',
          'es': 'Evaluado por Gemini AI',
          'zh': '由 Gemini AI 评估',
        };
        final defaultReason = defaultReasons[languageCode] ?? defaultReasons['en']!;

        return AnswerEvaluation(
          similarity: similarity,
          status: payload['status']?.toString() ?? _resolveStatus(similarity, null),
          cleanedUserAnswer: payload['cleaned_user']?.toString() ?? _cleanText(jawabanUser),
          cleanedCorrectAnswer: payload['cleaned_reference']?.toString() ?? _cleanText(jawabanBenar),
          reason: payload['alasan']?.toString() ?? payload['reason']?.toString() ?? defaultReason,
        );
      } else {
        throw Exception("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      // Fallback lokal jika API Error / RTO
      return evaluateLocally(
        jawabanUser: jawabanUser,
        jawabanBenar: jawabanBenar,
        languageCode: languageCode,
      );
    }
  }

  AnswerEvaluation evaluateLocally({
    required String jawabanUser,
    required String jawabanBenar,
    required String languageCode,
  }) {
    final cleanedUser = _cleanText(jawabanUser);
    
    // Support multiple correct answers separated by '|'
    final correctOptions = jawabanBenar.split('|').map((e) => _cleanText(e)).toList();
    
    double maxSimilarity = 0.0;
    String bestMatch = correctOptions.first;

    for (var option in correctOptions) {
      final similarity = _calculateSmartSimilarity(cleanedUser, option);
      if (similarity > maxSimilarity) {
        maxSimilarity = similarity;
        bestMatch = option;
      }
    }

    final reasons = {
      'en': 'Evaluated using an offline evaluation system (API not responding).',
      'id': 'Dinilai menggunakan sistem evaluasi offline (API sedang tidak merespon).',
      'ru': 'Оценивается с использованием системы офлайн-оценки (API не отвечает).',
      'es': 'Evaluado mediante un sistema de evaluación fuera de línea (la API no responde).',
      'zh': '使用离线评估系统进行评估（API 未响应）。',
    };
    final reason = reasons[languageCode] ?? reasons['en']!;

    return AnswerEvaluation(
      similarity: maxSimilarity,
      status: _resolveStatus(maxSimilarity, null),
      cleanedUserAnswer: cleanedUser,
      cleanedCorrectAnswer: bestMatch,
      reason: reason,
    );
  }

  double _calculateSmartSimilarity(String user, String target) {
    if (user.isEmpty || target.isEmpty) return 0.0;
    if (user == target) return 1.0;

    // 1. Jaccard Similarity (Token based)
    final jaccard = _jaccardSimilarity(user, target);

    // 2. Simple Fuzzy Word Match (Check if words in user exist in target or vice versa)
    final userTokens = user.split(' ').where((e) => e.isNotEmpty).toList();
    final targetTokens = target.split(' ').where((e) => e.isNotEmpty).toList();
    
    int matches = 0;
    for (var uToken in userTokens) {
      if (targetTokens.any((tToken) => _isFuzzyMatch(uToken, tToken))) {
        matches++;
      }
    }
    
    final fuzzyFactor = matches / (userTokens.length > targetTokens.length ? userTokens.length : targetTokens.length);

    // Combine both (weighted)
    return (jaccard * 0.4) + (fuzzyFactor * 0.6);
  }

  bool _isFuzzyMatch(String a, String b) {
    if (a == b) return true;
    if (a.length < 3 || b.length < 3) return false;
    
    // Common mappings (Polisi -> Petugas, etc) for Indonesian context
    final commonSynonyms = {
      'polisi': 'petugas',
      'officer': 'petugas',
      'halo': 'selamat',
      'hi': 'halo',
    };
    
    if (commonSynonyms[a] == b || commonSynonyms[b] == a) return true;

    // Basic substring check
    if (a.contains(b) || b.contains(a)) return true;
    
    return false;
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

    // Lower threshold for a more encouraging experience
    if (similarity >= 0.70) return 'benar';
    if (similarity >= 0.40) return 'hampir benar';
    return 'kurang tepat';
  }
}
