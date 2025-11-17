import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  User? get currentUser => _auth.currentUser;


  Stream<User?> get authState => _auth.authStateChanges();

  Future<void> login(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> register(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<void> logout() => _auth.signOut();
}


String firebaseErrorMessage(String error) {
  if (error.contains('invalid-email')) {
    return "Invalid email format. Please check your email.";
  }
  else if (error.contains('user-not-found')) {
    return "User not found. Please create an account.";
  }
  else if (error.contains('wrong-password')) {
    return "Incorrect password. Please try again.";
  }
  else if (error.contains('email-already-in-use')) {
    return "Email already registered. Please try logging in.";
  }
  else if (error.contains('weak-password')) {
    return "Password must be at least 6 characters.";
  }
  else if (error.contains('network-request-failed')) {
    return "Network error. Please check your internet connection.";
  }
  else if (error.contains('too-many-requests')) {
    return "Too many attempts. Try again later.";
  }
  return "Something went wrong. Please try again.";
}
