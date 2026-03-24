import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  double progress = 0.0;
  double scenarioProgress = 0.0;
  int selectedSegment = 0;
  int questionIndex = 0;
  bool isLoading = false;

  final List<String> segments = ["Listening", "Writing", "Speaking"];

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  // ─── LOGIC TIDAK DIUBAH ───────────────────────────────────────────────────

  Future<void> loadProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      List completedLessons = List.from(data['completedLessons'] ?? []);
      int totalThisScenario = completedLessons.where((item) {
        return item.startsWith("${widget.level}-${widget.scenario}");
      }).length;

      setState(() {
        progress = (data['progress'] ?? 0).toDouble();
        scenarioProgress = totalThisScenario / 15;
      });
    }
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
      isLoading = false;
    });
  }

  // ─── UI HELPERS ───────────────────────────────────────────────────────────

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

  // ─── SHARED CARD SOAL ─────────────────────────────────────────────────────
  //
  // Struktur isi card:
  //   Label atas      → mis. "Listen to the audio"
  //   Sub-label       → mis. "Choose the correct answer"
  //   Card biru transparan (soal)
  //     • Judul soal  → mis. "Question"
  //     • Isi soal    → (dari Firebase, placeholder teks)
  //   Card abu hint
  //     • Label hint
  //     • Isi hint    → (dari Firebase, placeholder teks)
  //     • Pronunciation → (dari Firebase, placeholder teks)
  //   Tombol aksi (berbeda tiap segmen)

  Widget _buildQuestionCard({
    required String topLabel,
    required String subLabel,
    required String questionTitle,
    required String questionContent, // nanti dari Firebase
    required String hintContent,     // nanti dari Firebase
    required String pronunciation,   // nanti dari Firebase
    required Widget actionButton,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label atas ──────────────────────────────────────────────
        Text(
          topLabel,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 4),

        // ── Sub-label ───────────────────────────────────────────────
        Text(
          subLabel,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF888888),
          ),
        ),
        const SizedBox(height: 16),

        // ── Card soal (biru transparan) ──────────────────────────────
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
              // Konten soal dari Firebase
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

        // ── Card hint (abu) ─────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hint",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 6),
              // Isi hint dari Firebase
              Text(
                hintContent,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF444444),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              // Pronunciation dari Firebase
              Row(
                children: [
                  const Icon(Icons.volume_up,
                      size: 16, color: Color(0xFF888888)),
                  const SizedBox(width: 6),
                  Text(
                    pronunciation,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF888888),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── Tombol aksi ──────────────────────────────────────────────
        actionButton,
        const SizedBox(height: 24),
      ],
    );
  }

  // ─── TOMBOL AKSI (shared style) ────────────────────────────────────────────

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
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
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

  // ─── SEGMEN LISTENING ──────────────────────────────────────────────────────

  Widget _buildListeningSegment() {
    return _buildQuestionCard(
      topLabel: "Listen to the audio",
      subLabel: "Choose or answer based on what you hear",
      questionTitle: "Question ${questionIndex + 1} of 5",
      questionContent: "Room for one night", // nanti dari Firebase
      hintContent: "Hint akan muncul di sini",       // nanti dari Firebase
      pronunciation: "/ruːm fər wʌn naɪt/",           // nanti dari Firebase
      actionButton: _actionButton(
        label: "Next",
        icon: Icons.arrow_forward_rounded,
        onPressed: isLoading
            ? null
            : () async {
          await completeLesson();
          setState(() {
            if (questionIndex < 4) {
              questionIndex++;
            } else {
              questionIndex = 0;
              selectedSegment = 1;
            }
          });
        },
      ),
    );
  }

  // ─── SEGMEN WRITING ────────────────────────────────────────────────────────

  Widget _buildWritingSegment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionCard(
          topLabel: "Write your answer",
          subLabel: "Translate the sentence below",
          questionTitle: "Question ${questionIndex + 1} of 5",
          questionContent: "Translate: Room for one night", // nanti dari Firebase
          hintContent: "Hint akan muncul di sini",           // nanti dari Firebase
          pronunciation: "/ruːm fər wʌn naɪt/",               // nanti dari Firebase
          actionButton: Column(
            children: [
              // TextField tetap di dalam Writing
              TextField(
                decoration: InputDecoration(
                  hintText: "Type your answer here...",
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
                    borderSide: const BorderSide(
                        color: Color(0xFFE0E0E0), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF2196F3), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _actionButton(
                label: "Submit",
                icon: Icons.check_rounded,
                onPressed: isLoading
                    ? null
                    : () async {
                  await completeLesson();
                  setState(() {
                    if (questionIndex < 4) {
                      questionIndex++;
                    } else {
                      questionIndex = 0;
                      selectedSegment = 2;
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Answer Submitted!")),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── SEGMEN SPEAKING ───────────────────────────────────────────────────────

  Widget _buildSpeakingSegment() {
    return _buildQuestionCard(
      topLabel: "Speak out loud",
      subLabel: "Read the sentence clearly",
      questionTitle: "Question ${questionIndex + 1} of 5",
      questionContent: "Room for one night", // nanti dari Firebase
      hintContent: "Hint akan muncul di sini",   // nanti dari Firebase
      pronunciation: "/ruːm fər wʌn naɪt/",       // nanti dari Firebase
      actionButton: _actionButton(
        label: "Start Speaking",
        icon: Icons.mic_rounded,
        onPressed: isLoading
            ? null
            : () async {
          await completeLesson();
          setState(() {
            if (questionIndex < 4) {
              questionIndex++;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Semua soal selesai!")),
              );
            }
          });
        },
      ),
    );
  }

  // ─── BUILD ─────────────────────────────────────────────────────────────────

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
            // ── CARD 1: Scenario info + progress bar + segmen nav ──────
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
                  // Nama scenario
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

                  // Progress bar
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
                    "${(scenarioProgress * 100).toInt()}% completed",
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
                              selectedSegment = index;
                              questionIndex = 0;
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