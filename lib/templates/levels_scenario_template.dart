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

  // ─── URL GAMBAR SESUAI NAMA SKENARIO ──────────────────────────────────────
  String _getImageUrl(String title) {
    switch (title.toLowerCase()) {
      case 'airport':
        return 'https://cdn-icons-png.flaticon.com/512/4336/4336554.png';
      case 'hotel':
        return 'https://cdn-icons-png.flaticon.com/512/9660/9660434.png';
      case 'restaurant':
        return 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png';
      case 'shopping':
        return 'https://cdn-icons-png.flaticon.com/512/1077/1077035.png';
      case 'transportation':
        return 'https://cdn-icons-png.flaticon.com/512/2933/2933184.png';
      case 'hospital':
        return 'https://cdn-icons-png.flaticon.com/512/2965/2965567.png';
      default:
        return 'https://cdn-icons-png.flaticon.com/512/4336/4336554.png';
    }
  }

  // ─── WARNA AKSEN TIAP SKENARIO ────────────────────────────────────────────
  Color _getAccentColor(String title) {
    switch (title.toLowerCase()) {
      case 'airport':
        return const Color(0xFF42A5F5); // biru langit
      case 'hotel':
        return const Color(0xFFAB8B6A); // coklat hangat
      case 'restaurant':
        return const Color(0xFFEF6C00); // oranye
      case 'shopping':
        return const Color(0xFFE91E8C); // pink
      case 'transportation':
        return const Color(0xFF43A047); // hijau
      case 'hospital':
        return const Color(0xFFE53935); // merah
      default:
        return const Color(0xFF2196F3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scenarios = [
      {"title": "Airport", "description": "Learn airport phrases and tips."},
      {"title": "Hotel", "description": "Useful sentences for hotel stays."},
      {"title": "Restaurant", "description": "Dining phrases and vocabulary."},
      {"title": "Shopping", "description": "Words and tips for shopping."},
      {
        "title": "Transportation",
        "description": "Get around using transport phrases."
      },
      {
        "title": "Hospital",
        "description": "Healthcare and emergency phrases."
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          levelTitle,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ...scenarios.map((s) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildScenarioCard(
                    context,
                    s['title']!,
                    s['description']!,
                  ),
                );
              }).toList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScenarioCard(
      BuildContext context, String title, String description) {
    final accent = _getAccentColor(title);
    final imageUrl = _getImageUrl(title);

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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Background warna di belakang gambar ────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.image_not_supported_outlined,
                size: 60,
                color: accent.withOpacity(0.4),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Judul ──────────────────────────────────────────────────
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 6),

          // ── Deskripsi ──────────────────────────────────────────────
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF888888),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // ── Tombol Start Learning ──────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                // ─── LOGIC TIDAK DIUBAH ─────────────────────────
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .set({
                  "currentLevel": levelKey,
                  "currentScenario": title.toLowerCase(),
                  "currentType": "listening",
                }, SetOptions(merge: true));

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
                // ────────────────────────────────────────────────
              },
              child: const Text(
                "Start Learning",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}