import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'level_screen.dart';
import 'settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/wiki_screen.dart';
import 'package:provider/provider.dart';
import 'language_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final lang = Provider.of<LanguageService>(context);

    // ⬇️ CEK USER LOGIN
    if (uid == null) {
      return const Scaffold(
        body: Center(
          child: Text("Something went wrong"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        title: Row(
          children: const [
            SizedBox(width: 16),
            Icon(Icons.school, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'ID Learning',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          ),
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            icon: const Icon(Icons.location_on, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WikiScreen(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      // ⬇️ AMBIL DATA FIRESTORE
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          // ⬇️ LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ⬇️ CEK DOKUMEN ADA ATAU TIDAK
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User data not found"));
          }

          // ⬇️ AMBIL DATA FIRESTORE
          final data = snapshot.data!.data() as Map<String, dynamic>;

          final username = data['username'] ?? 'User';

          // ⬇️ PERBAIKAN: AMAN UNTUK DOUBLE
          final progress = (data['progress'] ?? 0);
          final progressValue = (progress is int)
              ? progress.toDouble()
              : progress.toDouble();

          final firstLetter =
          username.isNotEmpty ? username[0].toUpperCase() : 'U';

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                children: [
                  // Box 1
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row User + Welcome
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white,
                              child: Text(
                                firstLetter,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Welcome + Username
                            Text(
                              lang.t('welcome_user', params: {'name': username}),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Garis putih tipis
                        Container(
                          height: 1,
                          color: Colors.white.withOpacity(0.6),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          lang.t('info_home_1'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Progress Bar + Persen
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 10,
                                  backgroundColor: Colors.white24,
                                  valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // ⬇️ persen
                            Text(
                              "${(progress * 100).toInt()}%",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "${(progress * 18).toInt()} of 18 lesson",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          lang.t('quiz_info_1'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: const [
                            Icon(Icons.emoji_events, color: Colors.amber),
                            SizedBox(width: 8),
                            Text(
                              "60%",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Box 2
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon + Judul
                        Row(
                          children:[
                            const Icon(Icons.school, color: Colors.white, size: 28),
                           const SizedBox(width: 10),
                            Text(
                              lang.t('info_home_2'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          lang.t('info_home_3'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          '${lang.t('info_home_4')}\n'
                              '${lang.t('info_home_5')}\n'
                              '${lang.t('info_home_6')}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Button Start Learning
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LevelScreen(),
                                ),
                              );
                            },
                            child: Text(
                              lang.t('button_learn'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Box 3
                  Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 32,
                          color: Colors.blue,
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          "Tourist Wiki",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          lang.t('info_home_7'),
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children:  [
                           const Icon(Icons.add, size: 18),
                           const  SizedBox(width: 8),
                            Text(lang.t('info_home_8')),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children:  [
                            const Icon(Icons.add, size: 18),
                            const SizedBox(width: 8),
                            Text(lang.t('info_home_9')),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children:  [
                            const Icon(Icons.add, size: 18),
                            SizedBox(width: 8),
                            Text(lang.t('info_home_10')),
                          ],
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WikiScreen(),
                                ),
                              );
                            },
                            child: Text(
                              lang.t('info_home_11'),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}