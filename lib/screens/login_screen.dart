import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'forgot_password_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import 'language_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool isSignUp = false;
  bool isSubmitting = false;
  bool _isGoogleLoading = false;
  bool _obscurePassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ── Warna selaras home_screen ──
  static const _gradientStart = Color(0xFF3A6FF7);
  static const _gradientEnd   = Color(0xFF6B4FE0);
  static const _accent        = Color(0xFF4F80FF);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _mapAuthError(FirebaseAuthException e, {required bool isSignUp, required LanguageService lang}) {
    switch (e.code) {
      case 'email-already-in-use':
        return lang.currentLang == 'id' ? 'Email sudah digunakan' : 'Email already in use';
      case 'user-not-found':
        return lang.currentLang == 'id' ? 'Akun tidak ditemukan' : 'Account not found';
      case 'wrong-password':
        return lang.currentLang == 'id' ? 'Password salah' : 'Incorrect password';
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return lang.currentLang == 'id' ? 'Email atau password salah' : 'Invalid email or password';
      case 'weak-password':
        return lang.currentLang == 'id' ? 'Password terlalu lemah (min 6 karakter)' : 'Password too weak';
      case 'invalid-email':
        return lang.currentLang == 'id' ? 'Format email tidak valid' : 'Invalid email format';
      case 'user-disabled':
        return lang.currentLang == 'id' ? 'Akun ini dinonaktifkan' : 'Account disabled';
      case 'too-many-requests':
        return lang.currentLang == 'id' ? 'Terlalu banyak percobaan. Coba lagi beberapa saat.' : 'Too many requests. Try again later.';
      default:
        return e.message ?? (lang.currentLang == 'id' ? 'Terjadi kesalahan autentikasi' : 'Authentication error');
    }
  }

  void _toggleMode(bool signUp) {
    setState(() => isSignUp = signUp);
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageService>(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_gradientStart, _gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Lingkaran dekoratif
            Positioned(
              top: -60,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: -70,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ─── Logo ───
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.20),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.school_rounded, size: 40, color: _accent),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            lang.t('login_title'),
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 32),

                          // ─── Card form ───
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.14),
                                  blurRadius: 32,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Toggle Sign In / Sign Up
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F4FF),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      _buildTab(lang.t('signin_tab'), !isSignUp, () => _toggleMode(false), lang: lang),
                                      _buildTab(lang.t('signup_tab'), isSignUp, () => _toggleMode(true), lang: lang),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 24),

                                if (isSignUp) ...[
                                  _buildTextField(
                                    controller: usernameController,
                                    label: lang.t('username_label'),
                                    icon: Icons.person_outline_rounded,
                                  ),
                                  const SizedBox(height: 14),
                                ],

                                _buildTextField(
                                  controller: emailController,
                                  label: lang.t('email_label'),
                                  icon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                ),

                                const SizedBox(height: 14),

                                _buildTextField(
                                  controller: passwordController,
                                  label: lang.t('password_label'),
                                  icon: Icons.lock_outline_rounded,
                                  obscureText: _obscurePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey[400],
                                      size: 20,
                                    ),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                ),

                                if (!isSignUp) 
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                                        );
                                      },
                                      child: Text(lang.t('forgot_password_link'), style: const TextStyle(color: _accent)),
                                    ),
                                  ),

                                const SizedBox(height: 20),

                                // Submit Button
                                SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _accent,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      elevation: 0,
                                    ),
                                    onPressed: isSubmitting ? null : () => _handleSubmit(lang),
                                    child: isSubmitting
                                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                        : Text(isSignUp ? lang.t('create_account_button') : lang.t('signin_button'), 
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // OR Divider
                                Row(
                                  children: [
                                    const Expanded(child: Divider()),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(lang.t('or_divider'), style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                                    ),
                                    const Expanded(child: Divider()),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Google Sign In Button
                                SizedBox(
                                  height: 52,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 13),
                                      side: BorderSide(color: Colors.grey[200]!),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                    onPressed: _isGoogleLoading ? null : _handleGoogleSignIn,
                                    child: _isGoogleLoading
                                        ? const CircularProgressIndicator(strokeWidth: 2)
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset('lib/widgets/google_logo.svg', width: 24, height: 24),
                                              const SizedBox(width: 10),
                                              Text(lang.t('continue_with_google'), style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit(LanguageService lang) async {
    setState(() => isSubmitting = true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final username = usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || (isSignUp && username.isEmpty)) {
      _showMessage(lang.t('auth_error_filling'));
      setState(() => isSubmitting = false);
      return;
    }

    try {
      if (isSignUp) {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        await cred.user!.updateDisplayName(username);
        await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
          'uid': cred.user!.uid,
          'username': username,
          'email': email,
          'level': 1,
          'progress': 0.0,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      }

      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      _showMessage(_mapAuthError(e, isSignUp: isSignUp, lang: lang));
    } catch (e) {
      _showMessage("Error: $e");
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);
    try {
      final user = await AuthService.signInWithGoogle();
      if (!mounted) return;
      if (user != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } catch (e) {
      _showMessage("Google Sign-In failed: $e");
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Widget _buildTab(String label, bool active, VoidCallback onTap, {required LanguageService lang}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
          ),
          child: Center(
            child: Text(label, style: TextStyle(color: active ? _accent : Colors.grey[500], fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, bool obscureText = false, TextInputType? keyboardType, Widget? suffixIcon}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: _accent, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF4F6FF),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: _accent, width: 1.5)),
      ),
    );
  }
}