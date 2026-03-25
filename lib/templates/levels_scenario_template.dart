// File: lib/templates/levels_scenario_template.dart
import 'package:flutter/material.dart';
import 'learning_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../screens/language_service.dart';

class LevelScenarioTemplate extends StatelessWidget {
  final String levelTitle;
  final String levelKey;

  const LevelScenarioTemplate({
    super.key,
    required this.levelTitle,
    required this.levelKey,
  });

  // ─── URL GAMBAR SESUAI NAMA SKENARIO ──────────────────────────────────────
  String _getImageUrl(String key) {
    switch (key.toLowerCase()) {
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
  Color _getAccentColor(String key) {
    switch (key.toLowerCase()) {
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
    final lang = Provider.of<LanguageService>(context);
    final scenarios = [
      {"key": "airport"},
      {"key": "hotel"},
      {"key": "restaurant"},
      {"key": "shopping"},
      {"key": "transportation"},
      {"key": "hospital"},
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
                final key = s['key']!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildScenarioCard(
                    context,
                    lang,
                    lang.t(key),                 // title (translated)
                    lang.t('${key}_desc'),       // description (translated)
                    key,                         // logic tetap pakai key
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
      BuildContext context,
      LanguageService lang,
      String title,
      String description,
      String key,
      ) {
    final accent = _getAccentColor(key);
    final imageUrl = _getImageUrl(key);

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
                  "currentScenario": key,
                  "currentType": "listening",
                }, SetOptions(merge: true));

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LearningTemplate(
                      level: levelKey,
                      scenario: key,
                      type: "listening",
                    ),
                  ),
                );
                // ────────────────────────────────────────────────
              },
              child: Text(
                lang.t('start_learning'),
                style: const TextStyle(
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