import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  /// Constructor to initialize FirebaseAuth and FirebaseFirestore instances.
  AuthRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Creates a new user and stores their details in Firestore.
  Future<User?> signUp(String email, String password, String name) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
      'name': name,
    });
    return userCredential.user;
  }

  /// Signs in an existing user with email and password.
  Future<User?> signIn(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }


  /// Signs out the currently authenticated user.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Gets the currently signed-in user, if any.
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
