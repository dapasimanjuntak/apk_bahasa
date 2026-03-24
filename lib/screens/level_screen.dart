// File: lib/screens/level_screen.dart
import 'package:flutter/material.dart';
import '../templates/levels_scenario_template.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            children: [
              // BACK BUTTON
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Choose Your Level",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Select a difficulty level to begin your journey",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 24),

              // Beginner Card
              _buildLevelCard(
                context: context,
                icon: Icons.star,
                title: "Beginner",
                subtitle: "Basic daily conversation",
              ),

              const SizedBox(height: 16),

              // Intermediate Card
              _buildLevelCard(
                context: context,
                icon: Icons.star_half,
                title: "Intermediate",
                subtitle: "Situational dialogues",
              ),

              const SizedBox(height: 16),

              // Advanced Card
              _buildLevelCard(
                context: context,
                icon: Icons.workspace_premium,
                title: "Advanced",
                subtitle: "Complex communication",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.blue),

          const SizedBox(height: 12),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Klik langsung ke template
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LevelScenarioTemplate(
                      levelTitle: title,
                      levelKey: title.toLowerCase(),
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