import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

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

    final started = await _speech.listen(
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
    setState(() => _isListening = started);
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

    try {
      final result = await _quizService.evaluateAnswer(
        soalId: current.id,
        jawabanUser: userAnswer,
        jawabanBenar: current.jawabanBenar,
      );

      if (!mounted) return;
      setState(() {
        evaluation = result;
        isSubmitted = true;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memproses jawaban. Coba lagi.')),
      );
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
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
  }

  // ─── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz NLP'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz NLP'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.quiz_outlined, size: 40, color: Colors.grey),
                const SizedBox(height: 12),
                const Text(
                  'Soal belum tersedia untuk level/scenario ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Color(0xFF555555)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadQuestions,
                  child: const Text('Coba Muat Ulang'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final totalQuestions = questions.length;
    final currentQuestion = questions[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          "${widget.scenario.toUpperCase()} Quiz",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF222222),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF222222)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header info ────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.quiz_rounded,
                        color: Color(0xFF2196F3), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.scenario} — ${widget.level}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF222222),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Soal ${currentIndex + 1} dari $totalQuestions",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildQuestionCard(currentQuestion),

            const SizedBox(height: 8),

            if (!isSubmitted) _buildSubmitButton(),
            if (isSubmitted) _buildResultCard(context),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(NlpQuestion q) {
    final showResult = isSubmitted;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: showResult
              ? _statusColor().withValues(alpha: 0.4)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nomor + badge tipe
          Row(
            children: [
              _questionBadge(currentIndex + 1),
              const SizedBox(width: 8),
              _typeBadge("NLP Evaluation", const Color(0xFF2196F3)),
              if (showResult) ...[
                const Spacer(),
                Icon(
                  _statusIcon(),
                  color: _statusColor(),
                  size: 20,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Teks soal
          Text(
            q.soal,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Jawab dengan ketik atau suara',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              IconButton(
                onPressed: _isSpeechReady ? _toggleSpeech : null,
                icon: Icon(
                  _isListening ? Icons.mic_off_rounded : Icons.mic_rounded,
                  color: _isListening ? Colors.red : const Color(0xFF2196F3),
                ),
                tooltip: _isListening ? 'Stop rekam suara' : 'Input suara',
              ),
            ],
          ),

          TextField(
            controller: _answerController,
            enabled: !isSubmitted,
            decoration: InputDecoration(
              hintText: "Tulis jawaban Anda...",
              hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
              filled: true,
              fillColor: const Color(0xFFF8F8F8),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: Color(0xFFE0E0E0), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFF2196F3), width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: Color(0xFFE0E0E0), width: 1),
              ),
            ),
          ),

          // Hint & jawaban benar setelah submit
          if (showResult) ...[
            const SizedBox(height: 10),
            _buildResultDetails(q),
          ],
        ],
      ),
    );
  }

  // ─── TOMBOL SUBMIT ────────────────────────────────────────────────────────

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: isSubmitting ? null : submitQuiz,
        icon: const Icon(Icons.check_rounded, size: 18),
        label: Text(
          isSubmitting ? 'Memproses...' : 'Kirim Jawaban',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFBDBDBD),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ─── CARD HASIL ───────────────────────────────────────────────────────────

  Widget _buildResultCard(BuildContext context) {
    final similarity = evaluation?.similarity ?? 0;
    final percent = (similarity * 100).round();
    final status = evaluation?.status ?? 'kurang tepat';
    final color = _statusColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            _statusIcon(),
            size: 40,
            color: color,
          ),
          const SizedBox(height: 10),
          Text(
            "Status: ${status.toUpperCase()}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Similarity: $percent%",
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 16),

          // Tombol Next Scenario
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () {
                _nextQuestion();
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(
                currentIndex < questions.length - 1
                    ? 'Soal Selanjutnya'
                    : 'Selesai Quiz',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultDetails(NlpQuestion q) {
    final similarity = evaluation?.similarity ?? 0;
    final percent = (similarity * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHintRow('Similarity: $percent% | Status: ${evaluation?.status ?? '-'}'),
        const SizedBox(height: 6),
        _buildHintRow('Jawaban Anda (cleaned): ${evaluation?.cleanedUserAnswer ?? '-'}'),
        const SizedBox(height: 6),
        _buildCorrectAnswerRow('Jawaban referensi: ${q.jawabanBenar}'),
      ],
    );
  }

  Color _statusColor() {
    final status = evaluation?.status ?? '';
    if (status == 'benar') return Colors.green;
    if (status == 'hampir benar') return Colors.orange;
    return Colors.red;
  }

  IconData _statusIcon() {
    final status = evaluation?.status ?? '';
    if (status == 'benar') return Icons.check_circle_rounded;
    if (status == 'hampir benar') return Icons.info_rounded;
    return Icons.cancel_rounded;
  }

  // ─── HELPER WIDGETS ───────────────────────────────────────────────────────

  Widget _questionBadge(int number) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "Q$number",
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF555555),
        ),
      ),
    );
  }

  Widget _typeBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildHintRow(String hint) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.lightbulb_outline_rounded,
            size: 14, color: Color(0xFFFFB300)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            "Hint: $hint",
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF888888),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCorrectAnswerRow(String answer) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_rounded, size: 14, color: Colors.green),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            "Correct answer: $answer",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}