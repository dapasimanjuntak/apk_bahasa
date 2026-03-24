import 'package:flutter/material.dart';

class SoalTemplate extends StatefulWidget {
  final String level;
  final String scenario;
  final int questionNumber;
  final int totalQuestion;
  final String questionText;

  const SoalTemplate({
    super.key,
    required this.level,
    required this.scenario,
    required this.questionNumber,
    required this.totalQuestion,
    required this.questionText,
  });

  @override
  State<SoalTemplate> createState() => _SoalTemplateState();
}

class _SoalTemplateState extends State<SoalTemplate> {

  final TextEditingController answerController = TextEditingController();

  String feedbackText = "";
  bool showFeedback = false;

  void submitAnswer() {

    String answer = answerController.text;

    // TEMPORARY DUMMY NLP
    setState(() {
      showFeedback = true;
      feedbackText = "Answer received: $answer";
    });

    // nanti di sini:
    // kirim ke backend / NLP (spaCy)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.level} - ${widget.scenario}"),
        backgroundColor: Colors.black,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Progress
              Text(
                "Question ${widget.questionNumber} of ${widget.totalQuestion}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              LinearProgressIndicator(
                value: widget.questionNumber / widget.totalQuestion,
                minHeight: 8,
              ),

              const SizedBox(height: 24),

              // Question box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.questionText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Answer input
              TextField(
                controller: answerController,
                decoration: InputDecoration(
                  hintText: "Type your answer...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: submitAnswer,
                  child: const Text(
                    "Submit Answer",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Feedback area
              if (showFeedback)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    feedbackText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}