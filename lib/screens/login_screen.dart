import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool isSignUp = false;
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

  void _toggleMode(bool signUp) {
    setState(() => isSignUp = signUp);
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background = gradient biru-ungu, sama persis dengan hero card home_screen
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
            // Lingkaran dekoratif — identik dengan hero card di home_screen
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
            Positioned(
              bottom: -50,
              right: -30,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),

                          // ─── Logo dalam lingkaran putih ───
                          Container(
                            width: 96,
                            height: 96,
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
                            child: ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: SvgPicture.asset(
                                  'lib/widgets/Logo.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ─── Title — putih menyatu dengan gradient ───
                          const Text(
                            'Indonesian for Tourist',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'Master Indonesian phrases in your native language',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.white.withOpacity(0.78),
                              height: 1.45,
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
                                      _buildTab('Sign In', !isSignUp,
                                              () => _toggleMode(false)),
                                      _buildTab('Sign Up', isSignUp,
                                              () => _toggleMode(true)),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Form fields
                                if (isSignUp) ...[
                                  _buildTextField(
                                    controller: usernameController,
                                    label: 'Username',
                                    icon: Icons.person_outline_rounded,
                                  ),
                                  const SizedBox(height: 14),
                                ],

                                _buildTextField(
                                  controller: emailController,
                                  label: 'Email',
                                  icon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                ),

                                const SizedBox(height: 14),

                                _buildTextField(
                                  controller: passwordController,
                                  label: 'Password',
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
                                    onPressed: () => setState(() =>
                                    _obscurePassword = !_obscurePassword),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Submit — gradient biru-ungu sama dengan home_screen
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [_accent, _gradientEnd],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _accent.withOpacity(0.38),
                                          blurRadius: 14,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final email = emailController.text.trim();
                                        final password =
                                        passwordController.text.trim();
                                        final username =
                                        usernameController.text.trim();

                                        if (email.isEmpty || password.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Email dan password wajib diisi")),
                                          );
                                          return;
                                        }
                                        if (isSignUp && username.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Username wajib diisi")),
                                          );
                                          return;
                                        }
                                        try {
                                          if (isSignUp) {
                                            final userCredential =
                                            await FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                              email: email,
                                              password: password,
                                            );

                                            final user = userCredential.user!;
                                            await user
                                                .updateDisplayName(username);
                                            await user.reload();
                                            final updatedUser = FirebaseAuth
                                                .instance.currentUser;
                                            final uid = user.uid;
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(uid)
                                                .set({
                                              'uid': uid,
                                              'username': username,
                                              'email': email,
                                              'level': 1,
                                              'progress': 0.0,
                                              'currentLevel': 'beginner',
                                              'currentScenario': 'airport',
                                              'currentType': 'listening',
                                              'completedLessons': [],
                                              'completedScenarios': [],
                                              'createdAt':
                                              FieldValue.serverTimestamp(),
                                            });
                                          } else {
                                            await FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                              email: email,
                                              password: password,
                                            );
                                          }

                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                const HomeScreen()),
                                          );
                                        } on FirebaseAuthException catch (e) {
                                          String message = "Terjadi kesalahan";
                                          if (e.code ==
                                              'email-already-in-use') {
                                            message = "Email sudah digunakan";
                                          } else if (e.code ==
                                              'user-not-found') {
                                            message = "User tidak ditemukan";
                                          } else if (e.code ==
                                              'wrong-password') {
                                            message = "Password salah";
                                          } else if (e.code ==
                                              'weak-password') {
                                            message =
                                            "Password terlalu lemah (min 6 karakter)";
                                          } else if (e.code ==
                                              'invalid-email') {
                                            message =
                                            "Format email tidak valid";
                                          }
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(message)),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text("Error: $e")),
                                          );
                                        }
                                      },
                                      child: Text(
                                        isSignUp ? 'Create Account' : 'Sign In',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Footer
                          Text(
                            'Learn Indonesian — one phrase at a time 🇮🇩',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.white.withOpacity(0.65),
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),
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

  Widget _buildTab(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(
              colors: [_accent, _gradientEnd],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
                : null,
            color: active ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: active
                ? [
              BoxShadow(
                color: _accent.withOpacity(0.28),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.grey[500],
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, color: Color(0xFF1A1F36)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        prefixIcon: Icon(icon, color: _accent, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF4F6FF),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: _accent, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFDDE3FF), width: 1),
        ),
      ),
    );
  }
}