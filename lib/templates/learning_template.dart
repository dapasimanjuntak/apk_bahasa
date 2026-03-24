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
  int questionIndex = 0; // 0 - 4 per segment
  bool isLoading = false;

  final List<String> segments = ["Listening", "Writing", "Speaking"];

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

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

    setState(() {
      isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final docRef =
    FirebaseFirestore.instance.collection('users').doc(user.uid);

    final snapshot = await docRef.get();

    Map<String, dynamic> data =
    snapshot.data() as Map<String, dynamic>;

    // 🔥 Ambil data lama
    List completedLessons = List.from(data['completedLessons'] ?? []);
    List completedScenarios = List.from(data['completedScenarios'] ?? []);

    // 🔥 Key soal
    String lessonKey =
        "${widget.level}-${widget.scenario}-${selectedSegment}-${questionIndex}";

    // 🔥 Simpan soal
    if (!completedLessons.contains(lessonKey)) {
      completedLessons.add(lessonKey);
    }

    // 🔥 Hitung jumlah soal dalam 1 scenario
    int totalThisScenario = completedLessons.where((item) {
      return item.startsWith("${widget.level}-${widget.scenario}");
    }).length;

    String scenarioKey = "${widget.level}-${widget.scenario}";

    // 🔥 Jika 15 soal selesai → tandai scenario selesai
    if (totalThisScenario == 15 &&
        !completedScenarios.contains(scenarioKey)) {
      completedScenarios.add(scenarioKey);
    }

    // 🔥 Progress berdasarkan 18 scenario
    double newProgress = (completedScenarios.length / 18).clamp(0.0, 1.0);

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

  Widget _buildListeningSegment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Listening (Q ${questionIndex + 1}/5)",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

        const SizedBox(height: 20),

        const Text("Room for one night"),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
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
            child: const Text("Next"),
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildWritingSegment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Writing (Q ${questionIndex + 1}/5)",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

        const SizedBox(height: 20),

        const Text("Translate: Room for one night"),

        const SizedBox(height: 16),

        TextField(
          decoration: InputDecoration(
            hintText: "Type your answer...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
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
                const SnackBar(content: Text("Answer Submitted!")),
              );
            },
            child: const Text("Submit"),
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSpeakingSegment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Speaking (Q ${questionIndex + 1}/5)",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

        const SizedBox(height: 20),

        Center(
          child: IconButton(
            iconSize: 60,
            icon: const Icon(Icons.mic, color: Colors.blue),
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
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Learning")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(value: scenarioProgress),

            const SizedBox(height: 10),

            Text("${(scenarioProgress * 100).toInt()}% completed"),

            const SizedBox(height: 20),

            Row(
              children: List.generate(segments.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSegment = index;
                        questionIndex = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      child: Text(segments[index]),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: buildSegmentContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
