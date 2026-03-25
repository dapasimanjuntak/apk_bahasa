// File: lib/screens/level_screen.dart
import 'package:flutter/material.dart';
import '../templates/levels_scenario_template.dart';
import 'package:provider/provider.dart';
import 'language_service.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageService>(context);
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

              Text(
                lang.t('level_info'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                lang.t('level_info_2'),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 24),

              // Beginner Card
              _buildLevelCard(
                context: context,
                icon: Icons.star,
                title: lang.t('lvl1'),
                subtitle: lang.t('lvl1_sub'),
              ),

              const SizedBox(height: 16),

              // Intermediate Card
              _buildLevelCard(
                context: context,
                icon: Icons.star_half,
                title: lang.t('lvl2'),
                subtitle: lang.t('lvl2_sub'),
              ),

              const SizedBox(height: 16),

              // Advanced Card
              _buildLevelCard(
                context: context,
                icon: Icons.workspace_premium,
                title: lang.t('lvl3'),
                subtitle: lang.t('lvl3_sub'),
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
    final lang = Provider.of<LanguageService>(context); // ✅ TAMBAHKAN INI
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
              child: Text(lang.t('lvl_button')),
            ),
          ),
        ],
      ),
    );
  }
}