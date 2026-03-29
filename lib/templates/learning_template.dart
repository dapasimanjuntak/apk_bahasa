import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/quiz_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../services/nlp_quiz_service.dart';
class LearningTemplate extends StatefulWidget {
  final String level;
  final String scenario;
  final String type;

  const LearningTemplate({
    super.key,
    required this.level,
    required this.scenario,
    required this.type,
  });

  @override
  State<LearningTemplate> createState() => _LearningTemplateState();
}

class _LearningTemplateState extends State<LearningTemplate> {
  final NlpQuizService _quizService = NlpQuizService();
  double progress = 0.0;
  double scenarioProgress = 0.0;
  int selectedSegment = 0;
  int questionIndex = 0;
  bool isLoading = false;
  bool isScenarioCompleted = false;
  final List<int> segmentQuestionIndex = [0, 0, 0];
  final List<String> segments = ["Listening", "Writing", "Speaking"];
  final AudioPlayer player = AudioPlayer();
  final FlutterTts flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _wordsSpoken = "";

  // ─── DATA SOAL (SAMA UNTUK SEMUA SEGMEN) ─────────────────────────────────
  List<Map<String, dynamic>> questions = [];
  bool isLoadingQuestions = true;

  // ─── WRITING INPUT ────────────────────────────────────────────────────────
  final TextEditingController writingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProgress();
    loadQuestions();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _wordsSpoken = result.recognizedWords;
        });
      },
      localeId: "id_ID", // Fokus mendengarkan Bahasa Indonesia
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  @override
  void dispose() {
    player.dispose();
    flutterTts.stop();
    writingController.dispose();
    super.dispose();
  }

  // ─── LOAD SOAL DARI FIRESTORE ─────────────────────────────────────────────
  // Struktur: lessons/{level}/{scenario}/question/items/{0_0 ~ 0_4}
  // Fields  : question, audioUrl, pronuncituation

  Future<void> loadQuestions() async {
    try {
      final List<Map<String, dynamic>> loaded = [];

      final querySnapshot = await FirebaseFirestore.instance
          .collection('topics')
          .doc(widget.scenario) // widget.scenario diisi dengan docId, misalnya "beginner_airport"
          .collection('items')
          .get();

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        loaded.add({
          'question': data['question'] ?? data['soal'] ?? '',
          'audioUrl': data['audioUrl'] ?? '',
          'pronunciation': data['Pronunciation'] ?? data['pronunciation'] ?? data['jawaban_benar'] ?? '',
        });
      }

      setState(() {
        questions = loaded;
        isLoadingQuestions = false;
      });
    } catch (e) {
      debugPrint("Error loadQuestions: $e");
      setState(() => isLoadingQuestions = false);
    }
  }

  // ─── SIMPAN JAWABAN USER KE FIRESTORE ────────────────────────────────────
  // Struktur: users/{uid}/answers/{level}_{scenario}_{segmen}_{index}
  // Field score dikosongkan dulu, diisi setelah NLP TF-IDF dijalankan nanti

  Future<void> saveUserAnswer({
    required int segmen,
    required int index,
    required String userAnswer,
  }) async {
    if (userAnswer.trim().isEmpty) return;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final answerKey =
          "${widget.level}_${widget.scenario}_${segmen}_$index";

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('answers')
          .doc(answerKey)
          .set({
        'userAnswer': userAnswer.trim(),
        'level': widget.level,
        'scenario': widget.scenario,
        'segmen': segmen,
        'questionIndex': index,
        'timestamp': FieldValue.serverTimestamp(),
        // 'score' diisi nanti setelah NLP dijalankan
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error saveUserAnswer: $e");
    }
  }

  // ─── LOGIC PROGRESS (TIDAK DIUBAH) ───────────────────────────────────────

  Future<void> loadProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) return;

    final data = doc.data() as Map<String, dynamic>;
    List completedLessons = List.from(data['completedLessons'] ?? []);
    List completedScenarios = List.from(data['completedScenarios'] ?? []);

    int totalThisScenario = completedLessons.where((item) {
      return item.startsWith("${widget.level}-${widget.scenario}");
    }).length;

    String scenarioKey = "${widget.level}-${widget.scenario}";

    setState(() {
      progress = (data['progress'] ?? 0).toDouble();
      scenarioProgress = (totalThisScenario / 15).clamp(0.0, 1.0);
      isScenarioCompleted = completedScenarios.contains(scenarioKey);
    });
  }

  Future<void> completeLesson() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    final docRef =
    FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docRef.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    List completedLessons = List.from(data['completedLessons'] ?? []);
    List completedScenarios = List.from(data['completedScenarios'] ?? []);

    String lessonKey =
        "${widget.level}-${widget.scenario}-${selectedSegment}-${questionIndex}";

    if (!completedLessons.contains(lessonKey)) {
      completedLessons.add(lessonKey);
    }

    int totalThisScenario = completedLessons.where((item) {
      return item.startsWith("${widget.level}-${widget.scenario}");
    }).length;

    String scenarioKey = "${widget.level}-${widget.scenario}";

    if (totalThisScenario == 15 &&
        !completedScenarios.contains(scenarioKey)) {
      completedScenarios.add(scenarioKey);
    }

    double newProgress =
    (completedScenarios.length / 18).clamp(0.0, 1.0);

    await docRef.set({
      "completedLessons": completedLessons,
      "completedScenarios": completedScenarios,
      "progress": newProgress,
    }, SetOptions(merge: true));

    setState(() {
      progress = newProgress;
      scenarioProgress = totalThisScenario / 15;
      isScenarioCompleted = completedScenarios.contains(scenarioKey);
      isLoading = false;
    });
  }

  // ─── UI ───────────────────────────────────────────────────────────────────

  Widget buildSegmentContent() {
    switch (selectedSegment) {
      case 0:
        return _buildListeningSegment();
      case 1:
        return _buildWritingSegment();
      case 2:
        return _buildSpeakingSegment();
      default:
        return const SizedBox();
    }
  }

  // ─── SHARED: LOADING / KOSONG ─────────────────────────────────────────────

  Widget _buildLoadingOrEmpty() {
    if (isLoadingQuestions) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          "Soal belum tersedia",
          style: TextStyle(color: Color(0xFF888888)),
        ),
      ),
    );
  }

  // ─── SHARED CARD SOAL ────────────────────────────────────────────────────

  Widget _buildQuestionCard({
    required String topLabel,
    required String subLabel,
    required String questionTitle,
    required String questionContent,
    required String pronunciation,
    required String audioUrl,
    required Widget actionButton,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          topLabel,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subLabel,
          style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
        ),
        const SizedBox(height: 16),

        // ── Card soal ────────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3).withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF2196F3).withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                questionTitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1565C0),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                questionContent,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF222222),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ── Card pronunciation + audio ────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.volume_up, size: 16, color: Color(0xFF888888)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  pronunciation,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF888888),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              // Tombol play audio bahasa indonesia
              GestureDetector(
                onTap: () async {
                  if (audioUrl.isNotEmpty) {
                    try {
                      await player.stop();
                      await player.play(UrlSource(audioUrl));
                    } catch (e) {
                      debugPrint("Error play audio: $e");
                    }
                  } else if (pronunciation.isNotEmpty) { // Jika audioUrl kosong, baca teks pakai TTS!
                    try {
                      await player.stop();
                      await flutterTts.setLanguage("id-ID");
                      await flutterTts.setSpeechRate(0.4); // diperlambat agar lebih jelas
                      await flutterTts.speak(pronunciation);
                    } catch (e) {
                      debugPrint("Error play TTS: $e");
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.play_circle_fill_rounded,
                    size: 22,
                    color: Color(0xFF2196F3),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        actionButton,
        const SizedBox(height: 24),

        // ── Tombol Quiz setelah scenario selesai ─────────────────────
        if (isScenarioCompleted) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: Colors.green, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Scenario Completed!",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "You've finished all lessons. Ready for the quiz?",
                  style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(
                            level: widget.level,
                            scenario: widget.scenario,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.quiz_rounded, size: 18),
                    label: const Text(
                      "Start Quiz",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  // ─── TOMBOL AKSI ─────────────────────────────────────────────────────────

  Widget _actionButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  // ─── SEGMEN LISTENING ─────────────────────────────────────────────────────

  Widget _buildListeningSegment() {
    if (isLoadingQuestions || questions.isEmpty) return _buildLoadingOrEmpty();
    final q = questions[questionIndex];

    return _buildQuestionCard(
      topLabel: "Dengarkan audio berikut",
      subLabel: "Simak baik-baik lalu lanjut ke soal berikutnya",
      questionTitle: "Soal ${questionIndex + 1} dari 5",
      questionContent: q['question'] ?? '',
      audioUrl: q['audioUrl'] ?? '',
      pronunciation: q['pronunciation'] ?? '',
      actionButton: _actionButton(
        label: "Lanjut",
        icon: Icons.arrow_forward_rounded,
        onPressed: isLoading
            ? null
            : () async {
          await completeLesson();
          setState(() {
            if (questionIndex < 4) {
              questionIndex++;
              segmentQuestionIndex[selectedSegment] = questionIndex;
            } else {
              segmentQuestionIndex[0] = 0;
              questionIndex = 0;
              selectedSegment = 1;
            }
          });
        },
      ),
    );
  }

  // ─── SEGMEN WRITING ───────────────────────────────────────────────────────

  Widget _buildWritingSegment() {
    if (isLoadingQuestions || questions.isEmpty) return _buildLoadingOrEmpty();
    final q = questions[questionIndex];

    return _buildQuestionCard(
      topLabel: "Tulis jawabanmu",
      subLabel: "Terjemahkan kalimat berikut ke Bahasa Indonesia",
      questionTitle: "Soal ${questionIndex + 1} dari 5",
      questionContent: q['question'] ?? '',
      audioUrl: q['audioUrl'] ?? '',
      pronunciation: q['pronunciation'] ?? '',
      actionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: writingController,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Ketik jawabanmu dalam Bahasa Indonesia...",
              hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
              filled: true,
              fillColor: const Color(0xFFF8F8F8),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
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
                borderSide:
                const BorderSide(color: Color(0xFF2196F3), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _actionButton(
            label: "Kirim",
            icon: Icons.check_rounded,
            onPressed: isLoading
                ? null
                : () async {
              final answer = writingController.text;
              if (answer.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Silakan isi jawaban dulu.")),
                );
                return;
              }

              setState(() => isLoading = true);
              try {
                final result = _quizService.evaluateLocally(
                  jawabanUser: answer,
                  jawabanBenar: q['pronunciation'] ?? '',
                );

                if (result.status == 'kurang tepat') {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("❌ Jawaban kurang tepat.\n\nTips: Coba tulis '${q['pronunciation']}'", style: const TextStyle(height: 1.4)),
                        backgroundColor: Colors.red[700],
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  }
                  setState(() => isLoading = false);
                  return;
                }

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("✅ Tepat sekali! Similarity: ${(result.similarity * 100).round()}%", style: const TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Terjadi kesalahan sistem, silakan coba lagi.")),
                  );
                }
                setState(() => isLoading = false);
                return;
              }

              setState(() => isLoading = false);

              // Simpan jawaban user ke Firestore (untuk NLP nanti)
              await saveUserAnswer(
                segmen: 1,
                index: questionIndex,
                userAnswer: answer,
              );
              await completeLesson();
              writingController.clear();
              setState(() {
                if (questionIndex < 4) {
                  questionIndex++;
                  segmentQuestionIndex[selectedSegment] = questionIndex;
                } else {
                  segmentQuestionIndex[1] = 0;
                  questionIndex = 0;
                  selectedSegment = 2;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // ─── SEGMEN SPEAKING ──────────────────────────────────────────────────────

  Widget _buildSpeakingSegment() {
    if (isLoadingQuestions || questions.isEmpty) return _buildLoadingOrEmpty();
    final q = questions[questionIndex];

    return _buildQuestionCard(
      topLabel: "Ucapkan dengan lantang",
      subLabel: "Baca kalimat berikut dengan jelas",
      questionTitle: "Soal ${questionIndex + 1} dari 5",
      questionContent: q['question'] ?? '',
      audioUrl: q['audioUrl'] ?? '',
      pronunciation: q['pronunciation'] ?? '',
      actionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Rekam Suara (Speech To Text) ─────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _speechToText.isListening ? Colors.red.withOpacity(0.08) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _speechToText.isListening ? Colors.red.withOpacity(0.5) : const Color(0xFFE0E0E0), width: 1),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _speechToText.isNotListening ? _startListening : _stopListening,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _speechToText.isListening ? Colors.red : const Color(0xFFE0E0E0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _speechToText.isListening ? Icons.mic : Icons.mic_none,
                      color: _speechToText.isListening ? Colors.white : const Color(0xFF666666),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _wordsSpoken.isNotEmpty
                        ? _wordsSpoken
                        : _speechToText.isListening
                            ? "Mendengarkan..."
                            : "Tekan mikrofon & bicara...",
                    style: TextStyle(
                      fontSize: 14,
                      color: _wordsSpoken.isNotEmpty || _speechToText.isListening ? const Color(0xFF222222) : const Color(0xFF888888),
                      fontStyle: _wordsSpoken.isEmpty ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          _actionButton(
            label: "Kirim Suara",
            icon: Icons.send_rounded,
            onPressed: (isLoading || _wordsSpoken.isEmpty)
                ? null
                : () async {
              // ── 1. HENTIKAN PENDENGARAN JIKA MASIH AKTIF
              if (_speechToText.isListening) {
                await _speechToText.stop();
              }

              // ── 2. CEK KEBENARAN MENGGUNAKAN JACCARD SIMILARITY (LOKAL)
              final result = _quizService.evaluateLocally(
                jawabanUser: _wordsSpoken,
                jawabanBenar: q['pronunciation']?.toString() ?? '',
              );

              if (result.status == 'kurang tepat') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("❌ Kurang tepat. Anda bilang: '$_wordsSpoken'.\n\nTips: Coba ucapkan '${q['pronunciation']}'", style: const TextStyle(height: 1.4)),
                    backgroundColor: Colors.red[700],
                    duration: const Duration(seconds: 4),
                  ),
                );
                // Biarkan mereka mencoba lagi (jangan pindah soal otomatis)
                setState(() { _wordsSpoken = ""; });
                return;
              }

              // ── 3. JIKA BENAR, LANJUTKAN KE SOAL BERIKUTNYA
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("✅ Tepat sekali! Similarity: ${(result.similarity * 100).round()}%", style: const TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green),
              );

              await saveUserAnswer(
                segmen: 2, // 2 = Speaking
                index: questionIndex,
                userAnswer: _wordsSpoken,
              );
              _wordsSpoken = ""; // Reset setelah dikirim
              await completeLesson();
              setState(() {
                if (questionIndex < 4) {
                  questionIndex++;
                  segmentQuestionIndex[selectedSegment] = questionIndex;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Semua soal selesai!")),
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          "Learning",
          style: TextStyle(
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // ── CARD 1: Info scenario + progress + segmen nav ──────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                  Text(
                    widget.scenario,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${widget.level}  •  ${widget.type}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: scenarioProgress,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFE8E8E8),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF2196F3)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${(scenarioProgress * 100).toInt()}% selesai",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Segment navigator
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: List.generate(segments.length, (index) {
                        final isActive = selectedSegment == index;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() {
                              segmentQuestionIndex[selectedSegment] =
                                  questionIndex;
                              selectedSegment = index;
                              questionIndex = segmentQuestionIndex[index];
                            }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding:
                              const EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: isActive
                                    ? [
                                  BoxShadow(
                                    color:
                                    Colors.black.withOpacity(0.08),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                                    : [],
                              ),
                              child: Text(
                                segments[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isActive
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isActive
                                      ? const Color(0xFF222222)
                                      : const Color(0xFF888888),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── CARD 2: Konten soal ────────────────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: buildSegmentContent(),
                ),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}