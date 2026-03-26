import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignUp = false;
  bool isSubmitting = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _mapAuthError(FirebaseAuthException e, {required bool isSignUp}) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email sudah digunakan';
      case 'user-not-found':
        return 'Akun tidak ditemukan';
      case 'wrong-password':
        return 'Password salah';
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return 'Email atau password salah';
      case 'weak-password':
        return 'Password terlalu lemah (min 6 karakter)';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-disabled':
        return 'Akun ini dinonaktifkan';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi beberapa saat.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Coba lagi.';
      case 'operation-not-allowed':
        return isSignUp
            ? 'Pendaftaran email/password belum diaktifkan di Firebase'
            : 'Metode login ini belum diaktifkan di Firebase';
      default:
        return e.message?.trim().isNotEmpty == true
            ? e.message!
            : 'Terjadi kesalahan autentikasi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center( // Center seluruh konten layar
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ikon buku biru
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.menu_book, size: 60, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Indonesian for Tourist',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Master Indonesian phrases in your native language',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Box utama
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Segmen toggle SignIn / SignUp
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isSignUp = false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: !isSignUp ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                        color: !isSignUp ? Colors.black : Colors.grey,
                                        fontWeight: !isSignUp ? FontWeight.bold : FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isSignUp = true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSignUp ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: isSignUp ? Colors.black : Colors.black,
                                        fontWeight: isSignUp ? FontWeight.bold : FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Form fields
                      if (isSignUp) ...[
                        TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: isSubmitting
                              ? null
                              : () async {
                            setState(() => isSubmitting = true);
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            final username = usernameController.text.trim();

                            // ✅ Validasi
                            if (email.isEmpty || password.isEmpty) {
                              _showMessage("Email dan password wajib diisi");
                              if (mounted) setState(() => isSubmitting = false);
                              return;
                            }
                            // ✅ Validasi jika SignUp dan username kosong
                            if (isSignUp && username.isEmpty) {
                              _showMessage("Username wajib diisi");
                              if (mounted) setState(() => isSubmitting = false);
                              return;
                            }
                            try {
                              if (isSignUp) {
                                // 🔥 SIGN UP
                                final userCredential = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );

                                // ✅ Simpan user name dan tampilkan data
                                final user = userCredential.user!;
                                await user.updateDisplayName(username);
                                await user.reload();
                                // ✅ Simpan data ke Firestore
                                final uid = user.uid;
                                await FirebaseFirestore.instance.collection('users').doc(uid).set({
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
                                  'createdAt': FieldValue.serverTimestamp(),
                                });
                              } else {
                                // 🔥 SIGN IN
                                await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                              }

                              // ✅ Kalau sukses → ke Home
                              if (!mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const HomeScreen()),
                              );

                            } on FirebaseAuthException catch (e) {
                              _showMessage(_mapAuthError(e, isSignUp: isSignUp));
                            } catch (e) {
                              _showMessage("Terjadi kesalahan. Coba lagi.");
                            } finally {
                              if (mounted) {
                                setState(() => isSubmitting = false);
                              }
                            }
                          },
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
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
    );
  }
}