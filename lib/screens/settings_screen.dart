import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';
import 'language_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        usernameController.text = doc.data()?['username'] ?? '';
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageService>(context);

    const purplePrimary = Color(0xFF8B5CF6);
    const purpleLight = Color(0xFFA78BFA);
    const purpleSurface = Color(0xFFF5F3FF);
    const purpleBorder = Color(0xFFEDE9FE);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                Container(
                  decoration: BoxDecoration(
                    color: purpleSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: purpleBorder),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: purplePrimary),
                  ),
                ),

                const SizedBox(height: 20),

                // Header
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 32,
                      decoration: BoxDecoration(
                        color: purplePrimary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.t('settings_title'),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1B4B),
                          ),
                        ),
                        Text(
                          lang.t('set_info'),
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // CARD 1 — Profile Info
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: purpleSurface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.person_rounded,
                                size: 22, color: purplePrimary),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang.t('profile_info'),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1B4B),
                                ),
                              ),
                              Text(
                                lang.t('update_details'),
                                style: const TextStyle(
                                    color: Colors.black45, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _buildLabel(lang.t('name')),
                      const SizedBox(height: 8),
                      TextField(
                        controller: usernameController,
                        style: const TextStyle(color: Color(0xFF1E1B4B)),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.badge_outlined,
                              color: purpleLight, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: purpleBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: purpleBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: purplePrimary, width: 2),
                          ),
                          filled: true,
                          fillColor: purpleSurface,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                        ),
                      ),

                      const SizedBox(height: 18),

                      _buildLabel(lang.t('email')),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F0F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: purpleBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.email_outlined,
                                size: 18, color: Colors.black38),
                            const SizedBox(width: 10),
                            Text(
                              FirebaseAuth.instance.currentUser?.email ??'-',
                              style: const TextStyle(
                                  color: Colors.black45, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        lang.t('email_cannot_change'),
                        style: const TextStyle(
                            color: Colors.black38, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // CARD 2 — Language
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: purpleSurface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.language_rounded,
                                size: 22, color: purplePrimary),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang.t('language_pref'),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1B4B),
                                ),
                              ),
                              Text(
                                lang.t('choose_language'),
                                style: const TextStyle(
                                    color: Colors.black45, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _buildLabel(lang.t('recent_language')),
                      const SizedBox(height: 8),

                      DropdownButtonFormField<String>(
                        value: lang.currentLang,
                        dropdownColor: Colors.white,
                        style: const TextStyle(
                            color: Color(0xFF1E1B4B), fontSize: 14),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.translate_rounded,
                              color: purpleLight, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: purpleBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: purpleBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: purplePrimary, width: 2),
                          ),
                          filled: true,
                          fillColor: purpleSurface,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'en',
                              child: Text("English")),
                          DropdownMenuItem(
                              value: 'id',
                              child: Text("Bahasa Indonesia")),
                          DropdownMenuItem(
                              value: 'es',
                              child: Text("Español")),
                          DropdownMenuItem(
                              value: 'ru',
                              child: Text("Русский язык")),
                          DropdownMenuItem(
                              value: 'zh',
                              child: Text("中文")),
                        ],
                        onChanged: (value) {
                          if (value != null) lang.changeLanguage(value);
                        },
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade50,
                              Colors.deepPurple.shade50,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: purpleBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded,
                                color: purplePrimary, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                lang.t('note_language_change'),
                                style: const TextStyle(
                                  color: purplePrimary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // BUTTON ROW
                Row(
                  children: [
                    // Save Changes Button
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: purplePrimary.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            final user = FirebaseAuth.instance.currentUser;
                            final newUsername = usernameController.text.trim();

                            if (user == null || newUsername.isEmpty) return;

                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .update({'username': newUsername});

                              await user.updateDisplayName(newUsername);

                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(lang.t('save_changes') +
                                      ' ✓'),
                                  backgroundColor: purplePrimary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Gagal update: $e"),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.save_rounded,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                lang.t('save_changes'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Logout Button
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(color: Colors.red),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signOut();

                            if (!context.mounted) return;

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                                  (route) => false,
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Gagal logout: $e"),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_rounded,
                                color: Colors.red, size: 18),
                            SizedBox(width: 6),
                            Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE9FE)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF4C1D95),
        fontSize: 13,
        letterSpacing: 0.3,
      ),
    );
  }
}