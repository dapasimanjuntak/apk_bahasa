import 'package:flutter/material.dart';
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
  // ─── DUMMY DATA ───────────────────────────────────────────────────────────
  // Nanti ganti dengan query Firestore
  // Struktur tiap soal:
  //   type        : "listening" | "multiple_choice"
  //   question    : teks soal
  //   audioUrl    : URL audio (khusus listening) — nanti dari Firebase
  //   options     : List<String> pilihan (khusus multiple_choice)
  //   correctAnswer: jawaban benar
  //   hint        : teks hint

  late final List<Map<String, dynamic>> questions = [
    // ── 2 soal listening ──────────────────────────────────────────
    {
      "type": "listening",
      "question": "Listen and type what you hear",
      "audioUrl": "", // TODO: isi dari Firebase
      "correctAnswer": "room for one night",
      "hint": "Seseorang memesan kamar hotel",
    },
    {
      "type": "listening",
      "question": "Listen and type what you hear",
      "audioUrl": "", // TODO: isi dari Firebase
      "correctAnswer": "how much is the room",
      "hint": "Menanyakan harga kamar",
    },
    // ── 3 soal pilihan ganda ──────────────────────────────────────
    {
      "type": "multiple_choice",
      "question": "What do you say when you want to check in?",
      "options": [
        "I'd like to check in please",
        "Can I have the bill?",
        "Where is the exit?",
        "I want to order food",
      ],
      "correctAnswer": "I'd like to check in please",
      "hint": "Ungkapan saat tiba di hotel",
    },
    {
      "type": "multiple_choice",
      "question": "How do you ask for a single room?",
      "options": [
        "Give me two rooms",
        "I need a single room please",
        "Is there a restaurant here?",
        "Can I see the menu?",
      ],
      "correctAnswer": "I need a single room please",
      "hint": "Single = satu orang",
    },
    {
      "type": "multiple_choice",
      "question": "What does 'check-out time' mean?",
      "options": [
        "Waktu sarapan",
        "Waktu harus meninggalkan kamar",
        "Waktu membersihkan kamar",
        "Waktu check-in",
      ],
      "correctAnswer": "Waktu harus meninggalkan kamar",
      "hint": "Check-out = selesai menginap",
    },
  ];

  // ─── STATE ────────────────────────────────────────────────────────────────
  final Map<int, String> userAnswers = {};
  final Map<int, TextEditingController> textControllers = {};
  bool isSubmitted = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller untuk soal listening
    for (int i = 0; i < questions.length; i++) {
      if (questions[i]['type'] == 'listening') {
        textControllers[i] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final c in textControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ─── LOGIC ────────────────────────────────────────────────────────────────

  void submitQuiz() {
    // Kumpulkan jawaban listening dari controller
    for (int i = 0; i < questions.length; i++) {
      if (questions[i]['type'] == 'listening') {
        userAnswers[i] = textControllers[i]?.text.trim().toLowerCase() ?? '';
      }
    }

    // Hitung score
    int s = 0;
    for (int i = 0; i < questions.length; i++) {
      final correct =
      (questions[i]['correctAnswer'] as String).toLowerCase().trim();
      final answer = (userAnswers[i] ?? '').toLowerCase().trim();
      if (answer == correct) s++;
    }

    setState(() {
      score = s;
      isSubmitted = true;
    });
  }

  bool _isCorrect(int index) {
    final correct =
    (questions[index]['correctAnswer'] as String).toLowerCase().trim();
    final answer = (userAnswers[index] ?? '').toLowerCase().trim();
    return answer == correct;
  }

  // ─── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.black.withOpacity(0.05),
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
                      color: const Color(0xFF2196F3).withOpacity(0.1),
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
                        "${questions.length} questions  •  2 Listening  •  3 Multiple Choice",
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

            // ── Daftar soal ────────────────────────────────────────────
            ...List.generate(questions.length, (i) {
              final q = questions[i];
              if (q['type'] == 'listening') {
                return _buildListeningCard(i, q);
              } else {
                return _buildMultipleChoiceCard(i, q);
              }
            }),

            const SizedBox(height: 8),

            // ── Tombol Submit / Hasil ──────────────────────────────────
            if (!isSubmitted) _buildSubmitButton(),
            if (isSubmitted) _buildResultCard(context),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ─── CARD LISTENING ───────────────────────────────────────────────────────

  Widget _buildListeningCard(int index, Map<String, dynamic> q) {
    final showResult = isSubmitted;
    final correct = showResult && _isCorrect(index);
    final wrong = showResult && !_isCorrect(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: showResult
              ? (correct ? Colors.green : Colors.red).withOpacity(0.4)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              _questionBadge(index + 1),
              const SizedBox(width: 8),
              _typeBadge("Listening", const Color(0xFF2196F3)),
              if (showResult) ...[
                const Spacer(),
                Icon(
                  correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: correct ? Colors.green : Colors.red,
                  size: 20,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Teks soal
          Text(
            q['question'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),

          // Tombol play audio
          GestureDetector(
            onTap: () {
              // TODO: play audio dari q['audioUrl']
            },
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF2196F3).withOpacity(0.25),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_circle_fill_rounded,
                      color: Color(0xFF2196F3), size: 22),
                  SizedBox(width: 8),
                  Text(
                    "Play Audio",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Text input jawaban
          TextField(
            controller: textControllers[index],
            enabled: !isSubmitted,
            decoration: InputDecoration(
              hintText: "Type what you hear...",
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
            _buildHintRow(q['hint']),
            if (wrong) ...[
              const SizedBox(height: 6),
              _buildCorrectAnswerRow(q['correctAnswer']),
            ],
          ],
        ],
      ),
    );
  }

  // ─── CARD MULTIPLE CHOICE ─────────────────────────────────────────────────

  Widget _buildMultipleChoiceCard(int index, Map<String, dynamic> q) {
    final showResult = isSubmitted;
    final correct = showResult && _isCorrect(index);
    final wrong = showResult && !_isCorrect(index);
    final List<String> options = List<String>.from(q['options']);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: showResult
              ? (correct ? Colors.green : Colors.red).withOpacity(0.4)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              _questionBadge(index + 1),
              const SizedBox(width: 8),
              _typeBadge("Multiple Choice", const Color(0xFF9C27B0)),
              if (showResult) ...[
                const Spacer(),
                Icon(
                  correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: correct ? Colors.green : Colors.red,
                  size: 20,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Teks soal
          Text(
            q['question'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),

          // Pilihan jawaban
          ...options.map((option) {
            final isSelected = userAnswers[index] == option;
            final isCorrectOption = option == q['correctAnswer'];

            Color borderColor = const Color(0xFFE0E0E0);
            Color bgColor = Colors.white;
            Color textColor = const Color(0xFF333333);

            if (showResult) {
              if (isCorrectOption) {
                borderColor = Colors.green;
                bgColor = Colors.green.withOpacity(0.08);
                textColor = Colors.green.shade700;
              } else if (isSelected && !isCorrectOption) {
                borderColor = Colors.red;
                bgColor = Colors.red.withOpacity(0.08);
                textColor = Colors.red.shade700;
              }
            } else if (isSelected) {
              borderColor = const Color(0xFF2196F3);
              bgColor = const Color(0xFF2196F3).withOpacity(0.08);
              textColor = const Color(0xFF1565C0);
            }

            return GestureDetector(
              onTap: isSubmitted
                  ? null
                  : () => setState(() => userAnswers[index] = option),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: textColor,
                  ),
                ),
              ),
            );
          }),

          // Hint setelah submit
          if (showResult) ...[
            const SizedBox(height: 4),
            _buildHintRow(q['hint']),
          ],
        ],
      ),
    );
  }

  // ─── TOMBOL SUBMIT ────────────────────────────────────────────────────────

  Widget _buildSubmitButton() {
    final allAnswered = () {
      for (int i = 0; i < questions.length; i++) {
        if (questions[i]['type'] == 'multiple_choice') {
          if (!userAnswers.containsKey(i)) return false;
        }
      }
      return true;
    }();

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: allAnswered ? submitQuiz : null,
        icon: const Icon(Icons.check_rounded, size: 18),
        label: const Text(
          "Submit Quiz",
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
    final total = questions.length;
    final percent = (score / total * 100).toInt();
    final passed = percent >= 60;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: passed
            ? Colors.green.withOpacity(0.08)
            : Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: passed
              ? Colors.green.withOpacity(0.3)
              : Colors.orange.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            passed ? Icons.emoji_events_rounded : Icons.refresh_rounded,
            size: 40,
            color: passed ? Colors.green : Colors.orange,
          ),
          const SizedBox(height: 10),
          Text(
            passed ? "Quiz Completed!" : "Keep Practicing!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: passed ? Colors.green.shade700 : Colors.orange.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Score: $score / $total  ($percent%)",
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
                // Kembali ke halaman daftar scenario
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
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text(
                "Next Scenario",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                passed ? Colors.green : const Color(0xFF2196F3),
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
        color: color.withOpacity(0.10),
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