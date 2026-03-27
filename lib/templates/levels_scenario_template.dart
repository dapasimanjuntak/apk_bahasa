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

  String _getImageUrl(String key) {
    switch (key.toLowerCase()) {
      case 'airport': return 'https://cdn-icons-png.flaticon.com/512/4336/4336554.png';
      case 'plants': return 'https://cdn-icons-png.flaticon.com/512/628/628283.png';
      case 'hotel': return 'https://cdn-icons-png.flaticon.com/512/9660/9660434.png';
      case 'restaurant': return 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png';
      default: return 'https://cdn-icons-png.flaticon.com/512/4114/4114972.png';
    }
  }

  Color _getAccentColor(String key) {
    switch (key.toLowerCase()) {
      case 'airport': return const Color(0xFF42A5F5);
      case 'plants': return Colors.green;
      case 'hotel': return const Color(0xFFAB8B6A);
      case 'restaurant': return const Color(0xFFEF6C00);
      default: return const Color(0xFF8B5CF6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(levelTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Color(0xFF222222))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF222222)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // 🔥 QUERY MAGIC: Cari semua topik yang berlabel level ini (misal: "beginner") di koleksi utama 'topics'
        stream: FirebaseFirestore.instance
            .collection('topics')
            .where('level', isEqualTo: levelKey.toLowerCase())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome_mosaic_rounded, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text("Belum ada skenario untuk level $levelTitle.", style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Firestore: Buat dokumen di koleksi utama 'topics', dan pastikan punya field 'level' = '$levelKey'", 
                      textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.blue)
                    ),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final String docId = docs[index].id;
              final data = docs[index].data() as Map<String, dynamic>;
              
              // Key untuk warna & gambar
              final String scenarioImageKey = data['scenario'] ?? docId;

              final String title = data['title'] ?? lang.t(scenarioImageKey);
              final String desc = data['description'] ?? lang.t('${scenarioImageKey}_desc');

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildScenarioCard(context, lang, title, desc, docId, scenarioImageKey),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildScenarioCard(BuildContext context, LanguageService lang, String title, String description, String key, String imageKey) {
    final accent = _getAccentColor(imageKey);
    final imageUrl = _getImageUrl(imageKey);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(color: accent.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
            child: Image.network(imageUrl, height: 120, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported_outlined, size: 60, color: accent.withOpacity(0.4))),
          ),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF222222))),
          const SizedBox(height: 6),
          Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Color(0xFF888888), height: 1.4)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;
                await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                  "currentLevel": levelKey,
                  "currentScenario": key,
                }, SetOptions(merge: true));
                
                Navigator.push(context, MaterialPageRoute(builder: (context) => LearningTemplate(level: levelKey, scenario: key, type: "listening")));
              },
              child: Text(lang.t('start_learning'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}