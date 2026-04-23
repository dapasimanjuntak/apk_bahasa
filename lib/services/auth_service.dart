import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _googleSignIn = GoogleSignIn(
    serverClientId:
        '706326455197-68ncsvsce8tnbh6js880sa4i4kden4fc.apps.googleusercontent.com',
  );
  static final _firestore = FirebaseFirestore.instance;

  /// Login dengan Google — mengembalikan User jika berhasil, null jika dibatalkan
  static Future<User?> signInWithGoogle() async {
    // Tampilkan dialog pilih akun Google
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // user batalkan

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user!;

    //  Simpan ke Firestore hanya jika user baru (belum pernah login sebelumnya)
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'uid': user.uid,
        'username': user.displayName ?? 'Google User',
        'email': user.email ?? '',
        'level': 1,
        'progress': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return user;
  }

  /// Logout dari Firebase dan Google
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
