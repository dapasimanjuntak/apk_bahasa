import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';
import 'language_service.dart';
import 'upload_data_screen.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController usernameController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          usernameController.text = doc.data()?['username'] ?? '';
        });
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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                  ),
                  child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1B4B)),
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                lang.t('settings_title'),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1E1B4B)),
              ),
              const SizedBox(height: 8),
              Text(
                lang.t('set_info'),
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),

              const SizedBox(height: 32),

              // Profile Card
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(Icons.person_rounded, lang.t('profile_info'), purplePrimary, purpleSurface),
                    const SizedBox(height: 24),
                    _buildLabel(lang.t('name')),
                    const SizedBox(height: 8),
                    TextField(
                      controller: usernameController,
                      decoration: _inputDecoration(Icons.badge_outlined, purpleLight, purpleSurface, purpleBorder),
                    ),
                    const SizedBox(height: 20),
                    _buildLabel(lang.t('email')),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 20, color: Colors.grey),
                          const SizedBox(width: 12),
                          Text(FirebaseAuth.instance.currentUser?.email ?? '-', 
                              style: const TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(lang.t('email_cannot_change'), style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Language Card
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(Icons.translate_rounded, lang.t('language_pref'), purplePrimary, purpleSurface),
                    const SizedBox(height: 24),
                    _buildLabel(lang.t('recent_language')),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: lang.currentLang,
                      decoration: _inputDecoration(Icons.language_rounded, purpleLight, purpleSurface, purpleBorder),
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text("English")),
                        DropdownMenuItem(value: 'id', child: Text("Bahasa Indonesia")),
                        DropdownMenuItem(value: 'es', child: Text("Español")),
                        DropdownMenuItem(value: 'ru', child: Text("Русский язык")),
                        DropdownMenuItem(value: 'zh', child: Text("中文")),
                      ],
                      onChanged: (value) {
                        if (value != null) lang.changeLanguage(value);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Actions
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purplePrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: _isSaving ? null : _saveChanges,
                      child: _isSaving 
                          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : Text(lang.t('save_changes'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _handleLogout,
                      child: Text(lang.t('logout_button'), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),


            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    final newUsername = usernameController.text.trim();
    if (user == null || newUsername.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'username': newUsername});
      await user.updateDisplayName(newUsername);
      if (!mounted) return;
      final lang = Provider.of<LanguageService>(context, listen: false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang.t('changes_saved_msg'))));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleLogout() async {
    final lang = Provider.of<LanguageService>(context, listen: false);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang.t('logout_confirm_title')),
        content: Text(lang.t('logout_confirm_content')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(lang.t('cancel_button'))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(lang.t('logout_button'), style: const TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
    }
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color primary, Color surface) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: primary),
        ),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B)));
  }

  InputDecoration _inputDecoration(IconData icon, Color iconColor, Color fillColor, Color borderColor) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: iconColor, size: 20),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: iconColor, width: 1.5)),
    );
  }
}