// File: lib/templates/levels_scenario_template.dart
import 'package:flutter/material.dart';
import 'learning_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LevelScenarioTemplate extends StatelessWidget {
  final String levelTitle;
  final String levelKey;

  const LevelScenarioTemplate({
    super.key,
    required this.levelTitle,
    required this.levelKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(levelTitle),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 40, left: 16, right: 16), // bottom padding lebih lega
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24), // top padding supaya tidak nempel status bar

              _buildScenarioCard(
                context,
                "Airport",
                "Learn airport phrases and tips.",
                "https://cdn-icons-png.flaticon.com/512/4336/4336554.png",
              ),
              const SizedBox(height: 24),

              _buildScenarioCard(
                context,
                "Hotel",
                "Useful sentences for hotel stays.",
                "https://cdn-icons-png.flaticon.com/512/9660/9660434.png",
              ),
              const SizedBox(height: 24),

              _buildScenarioCard(
                context,
                "Restaurant",
                "Dining phrases and vocabulary.",
                "https://cdn-icons-png.flaticon.com/512/3075/3075977.png",
              ),
              const SizedBox(height: 24),

              _buildScenarioCard(
                context,
                "Shopping",
                "Words and tips for shopping.",
                "https://cdn-icons-png.flaticon.com/512/1077/1077035.png",
              ),
              const SizedBox(height: 24),

              _buildScenarioCard(
                context,
                "Transportation",
                "Get around using transport phrases.",
                "https://cdn-icons-png.flaticon.com/512/2933/2933184.png",
              ),
              const SizedBox(height: 24),

              _buildScenarioCard(
                context,
                "Hospital",
                "Healthcare and emergency phrases.",
                "https://cdn-icons-png.flaticon.com/512/2965/2965567.png",
              ),

              const SizedBox(height: 40), // jarak bawah lega sebelum navbar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScenarioCard(
      BuildContext context, String title, String description, String imageUrl) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // Gambar dari internet
          Image.network(
            imageUrl,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(description,
              textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;

                if (user == null) return;

                // 🔥 SIMPAN KE FIRESTORE
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .set({
                  "currentLevel": levelKey,
                  "currentScenario": title.toLowerCase(),
                  "currentType": "listening",
                }, SetOptions(merge: true));

                // 🔥 PINDAH KE LEARNING
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LearningTemplate(
                      level: levelKey,
                      scenario: title.toLowerCase(),
                      type: "listening",
                    ),
                  ),
                );
              },
              child: const Text("Start Learning"),
            ),
          ),
        ],
      ),
    );
  }
}