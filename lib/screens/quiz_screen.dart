import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/answer_evaluation.dart';
import '../models/nlp_question.dart';
import '../services/nlp_quiz_service.dart';
import '../templates/levels_scenario_template.dart';
import 'language_service.dart';
import 'level_screen.dart';

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
  bool _hasError = false;

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
    final languageCode = Provider.of<LanguageService>(context, listen: false).currentLang;
    try {
      final loaded = await _quizService.fetchQuestions(
        level: widget.level,
        scenario: widget.scenario,
        languageCode: languageCode,
      );

      if (!mounted) return;
      setState(() {
        questions = loaded;
        isLoading = false;
        _hasError = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        _hasError = true;
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
    final lang = Provider.of<LanguageService>(context, listen: false);

    if (userAnswer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.t('quiz_fill_first'))),
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
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(lang.t('quiz_analyzing'), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );

    try {
      final result = await _quizService.evaluateAnswer(
        soal: current.soal,
        jawabanUser: userAnswer,
        jawabanBenar: current.jawabanBenar,
        languageCode: lang.currentLang,
      );

      if (!mounted) return;
      Navigator.pop(context);

      setState(() {
        evaluation = result;
        isSubmitted = true;
        if (result.status == 'benar' || result.status == 'hampir benar') {
          correctAnswersCount++;
        }
      });

      if (currentIndex == questions.length - 1) {
        await _updateUserProgress();
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
    final lang = Provider.of<LanguageService>(context, listen: false);

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        isSubmitted = false;
        evaluation = null;
        _answerController.clear();
      });
      return;
    }

    final total = questions.length;
    final percent = ((correctAnswersCount / total) * 100).toInt();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('🎉 ${lang.t("quiz_finished")}', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(lang.t('quiz_final_score'), style: const TextStyle(color: Colors.grey)),
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
              Text(
                lang.t('quiz_correct_count', params: {
                  'correct': '$correctAnswersCount',
                  'total': '$total',
                }),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Text(
                lang.t('quiz_score_saved'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.blue),
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
                  // Reconstruct the stack: Home -> Level -> Scenarios
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LevelScreen()),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelScenarioTemplate(
                        levelTitle: lang.t(widget.level),
                        levelKey: widget.level,
                      ),
                    ),
                  );
                },
                child: Text(lang.t('quiz_back_menu'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageService>(context);

    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (_hasError || questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(lang.t('quiz_title'))),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_hasError ? lang.t('quiz_load_fail') : lang.t('quiz_no_questions')),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _loadQuestions, child: Text(lang.t('quiz_retry'))),
            ],
          ),
        ),
      );
    }

    final currentQuestion = questions[currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${lang.t(widget.scenario.split('_').last).toUpperCase()} ${lang.t('quiz_title')}"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeader(lang),
            const SizedBox(height: 24),
            _buildQuestionCard(currentQuestion, lang),
            const SizedBox(height: 16),
            if (!isSubmitted) _buildSubmitButton(lang),
            if (isSubmitted) _buildResultCard(lang),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(LanguageService lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.quiz_rounded, color: Colors.blue),
          const SizedBox(width: 12),
          Text(
            lang.t('quiz_soal_progress', params: {
              'current': '${currentIndex + 1}',
              'total': '${questions.length}',
            }),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(NlpQuestion q, LanguageService lang) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSubmitted ? Border.all(color: _statusColor().withOpacity(0.5)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(q.soal, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          TextField(
            controller: _answerController,
            enabled: !isSubmitted,
            decoration: InputDecoration(
              hintText: lang.t('quiz_hint'),
              suffixIcon: IconButton(
                icon: Icon(_isListening ? Icons.mic_off : Icons.mic, color: _isListening ? Colors.red : Colors.blue),
                onPressed: _toggleSpeech,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          if (isSubmitted) ...[
            const SizedBox(height: 16),
            Text("${lang.t('quiz_ref_answer')} ${q.jawabanBenar}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
            Text("${lang.t('quiz_similarity')} ${(evaluation!.similarity * 100).round()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
          ]
        ],
      ),
    );
  }

  Widget _buildSubmitButton(LanguageService lang) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: isSubmitting ? null : submitQuiz,
        child: Text(lang.t('quiz_submit'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildResultCard(LanguageService lang) {
    final color = _statusColor();
    final reason = evaluation?.reason ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Icon(_statusIcon(), color: color, size: 40),
          const SizedBox(height: 8),
          Text(
            "${lang.t('quiz_status')} ${lang.t(
              evaluation!.status == 'benar'
                  ? 'status_correct'
                  : evaluation!.status == 'hampir benar'
                      ? 'status_partial'
                      : 'status_incorrect'
            ).toUpperCase()}",
            style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "${lang.t('quiz_similarity')} ${(evaluation!.similarity * 100).round()}%",
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w600),
          ),

          // Tampilkan alasan dari API
          if (reason.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 14, color: color),
                      const SizedBox(width: 6),
                      Text(
                        lang.t('quiz_reason_label'),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(reason, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4)),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: color),
              onPressed: _nextQuestion,
              child: Text(
                lang.t(currentIndex < questions.length - 1 ? 'quiz_next' : 'quiz_done'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
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