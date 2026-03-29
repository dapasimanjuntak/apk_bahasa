import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/answer_evaluation.dart';
import '../models/nlp_question.dart';
import '../services/nlp_quiz_service.dart';
import '../templates/levels_scenario_template.dart';

class QuizScreen extends StatefulWidget {
  final String level;
  final String scenario;

  const QuizScreen({
    super.key,
    required this.level,
    required this.scenario,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final NlpQuizService _quizService = NlpQuizService();
  final SpeechToText _speech = SpeechToText();
  final TextEditingController _answerController = TextEditingController();

  List<NlpQuestion> questions = [];
  int currentIndex = 0;
  bool isSubmitted = false;
  bool isLoading = true;
  bool isSubmitting = false;
  bool _isSpeechReady = false;
  bool _isListening = false;
  String? _error;

  AnswerEvaluation? evaluation;
  int correctAnswersCount = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _initialize() async {
    await Future.wait([
      _loadQuestions(),
      _initSpeech(),
    ]);
  }

  Future<void> _loadQuestions() async {
    try {
      final loaded = await _quizService.fetchQuestions(
        level: widget.level,
        scenario: widget.scenario,
      );

      if (!mounted) return;
      setState(() {
        questions = loaded;
        isLoading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        _error = 'Gagal memuat soal. Coba lagi.';
      });
    }
  }

  Future<void> _initSpeech() async {
    final available = await _speech.initialize();
    if (!mounted) return;
    setState(() => _isSpeechReady = available);
  }

  Future<void> _toggleSpeech() async {
    if (!_isSpeechReady || isSubmitted) return;

    if (_isListening) {
      await _speech.stop();
      if (!mounted) return;
      setState(() => _isListening = false);
      return;
    }

    await _speech.listen(
      localeId: 'id_ID',
      onResult: (result) {
        _answerController.text = result.recognizedWords;
        _answerController.selection = TextSelection.fromPosition(
          TextPosition(offset: _answerController.text.length),
        );

        if (result.finalResult && mounted) {
          setState(() => _isListening = false);
        }
      },
    );

    if (!mounted) return;
    setState(() => _isListening = true);
  }

  Future<void> submitQuiz() async {
    if (questions.isEmpty) return;
    final userAnswer = _answerController.text.trim();

    if (userAnswer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan isi jawaban dulu.')),
      );
      return;
    }

    final current = questions[currentIndex];
    setState(() => isSubmitting = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Jawabanmu sedang dianalisis...", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );

    try {
      final result = await _quizService.evaluateAnswer(
        soal: current.soal,
        jawabanUser: userAnswer,
        jawabanBenar: current.jawabanBenar,
      );

      if (!mounted) return;
      Navigator.pop(context); // Tutup popup loading

      setState(() {
        evaluation = result;
        isSubmitted = true;
        if (result.status == 'benar' || result.status == 'hampir benar') {
          correctAnswersCount++;
        }
      });

      // Update Firestore progress jika soal terakhir
      if (currentIndex == questions.length - 1) {
        await _updateUserProgress();
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Tutup popup loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memproses jawaban: $e')),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Future<void> _updateUserProgress() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final total = questions.length;
    final percent = ((correctAnswersCount / total) * 100).toInt();

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'quiz_percent': percent,
        'last_quiz_scenario': widget.scenario,
        'last_quiz_level': widget.level,
        'last_quiz_at': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  void _nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        isSubmitted = false;
        evaluation = null;
        _answerController.clear();
      });
      return;
    }

    // Hitung total nilai untuk ditampilkan
    final total = questions.length;
    final percent = ((correctAnswersCount / total) * 100).toInt();

    showDialog(
      context: context,
      barrierDismissible: false, // Wajib tekan tombol OK
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('🎉 Quiz Selesai!', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Nilai Akhir Anda:', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Text(
                '$percent',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: percent >= 80 ? Colors.green : (percent >= 60 ? Colors.orange : Colors.red),
                ),
              ),
              const SizedBox(height: 10),
              Text('Benar $correctAnswersCount dari $total soal', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              const Text(
                'Nilai Anda telah otomatis disimpan di sistem kami secara real-time.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelScenarioTemplate(
                        levelTitle: widget.level,
                        levelKey: widget.level,
                      ),
                    ),
                    (route) => false,
                  );
                },
                child: const Text('Kembali ke Menu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (_error != null || questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz NFL')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error ?? 'Soal belum tersedia.'),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _loadQuestions, child: const Text('Coba Lagi')),
            ],
          ),
        ),
      );
    }

    final currentQuestion = questions[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text("${widget.scenario.toUpperCase()} Quiz"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Progress Header
            _buildHeader(),
            const SizedBox(height: 24),
            // Question Card
            _buildQuestionCard(currentQuestion),
            const SizedBox(height: 16),
            if (!isSubmitted) _buildSubmitButton(),
            if (isSubmitted) _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.quiz_rounded, color: Colors.blue),
          const SizedBox(width: 12),
          Text("Soal ${currentIndex + 1} / ${questions.length}", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(NlpQuestion q) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: isSubmitted ? Border.all(color: _statusColor().withOpacity(0.5)) : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(q.soal, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          TextField(
            controller: _answerController,
            enabled: !isSubmitted,
            decoration: InputDecoration(
              hintText: "Tulis atau rekam jawaban...",
              suffixIcon: IconButton(
                icon: Icon(_isListening ? Icons.mic_off : Icons.mic, color: _isListening ? Colors.red : Colors.blue),
                onPressed: _toggleSpeech,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          if (isSubmitted) ...[
            const SizedBox(height: 16),
            Text("Jawaban referensi: ${q.jawabanBenar}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
            Text("Similarity: ${(evaluation!.similarity * 100).round()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
          ]
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        onPressed: isSubmitting ? null : submitQuiz,
        child: const Text("Kirim Jawaban", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildResultCard() {
    final color = _statusColor();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: color)),
      child: Column(
        children: [
          Icon(_statusIcon(), color: color, size: 40),
          const SizedBox(height: 8),
          Text("Status: ${evaluation!.status.toUpperCase()}", style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Similarity: ${(evaluation!.similarity * 100).round()}%", style: TextStyle(color: color.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: color),
              onPressed: _nextQuestion,
              child: Text(currentIndex < questions.length - 1 ? "Soal Berikutnya" : "Selesai", style: const TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Color _statusColor() {
    if (evaluation == null) return Colors.grey;
    if (evaluation!.status == 'benar') return Colors.green;
    if (evaluation!.status == 'hampir benar') return Colors.orange;
    return Colors.red;
  }

  IconData _statusIcon() {
    if (evaluation == null) return Icons.help;
    if (evaluation!.status == 'benar') return Icons.check_circle;
    if (evaluation!.status == 'hampir benar') return Icons.info;
    return Icons.cancel;
  }
}