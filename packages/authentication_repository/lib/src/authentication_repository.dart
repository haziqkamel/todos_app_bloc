import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;

/// {@template sign_in_with_email_and_password_failure}
/// Exception thrown when an exception occurs during the sign in with email
/// and password process.
/// {@endtemplate}
class SignUpWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown error occurred',
  ]);

  /// Create an authentication message
  /// from a Firebase authentication exception code.
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'The user corresponding to the given email has been disabled',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'The email is already in use',
        );
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'The email address is not valid',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'The email/password provider is not enabled',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'The password is too weak',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// A human-readable message describing the error.
  final String message;
}

/// {@template sign_in_with_email_and_password_failure}
/// Exception thrown when an exception occurs during the sign in with email
/// and password process.
/// {@endtemplate}
class SignInWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_in_with_email_and_password_failure}
  const SignInWithEmailAndPasswordFailure([
    this.message = 'An unknown error occurred',
  ]);

  /// Create an authentication message
  /// from a Firebase authentication exception code.
  factory SignInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'user-disabled':
        return const SignInWithEmailAndPasswordFailure(
          'The user corresponding to the given email has been disabled',
        );
      case 'user-not-found':
        return const SignInWithEmailAndPasswordFailure(
          'The user corresponding to the given email does not exist',
        );
      case 'wrong-password':
        return const SignInWithEmailAndPasswordFailure(
          'The password is invalid for the given email',
        );
      case 'invalid-email':
        return const SignInWithEmailAndPasswordFailure(
          'The email address is not valid',
        );
      default:
        return const SignInWithEmailAndPasswordFailure();
    }
  }

  /// A human-readable message describing the error.
  final String message;
}

/// {@template sign_in_with_google_failure}
/// Exception thrown when an exception occurs during the sign in with Google
/// process.
/// {@endtemplate}
class SignInWithGoogleFailure implements Exception {
  /// {@macro sign_in_with_google_failure}
  const SignInWithGoogleFailure([
    this.message = 'An unknown error occurred',
  ]);

  /// Create an authentication message
  /// from a Firebase authentication exception code.
  factory SignInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const SignInWithGoogleFailure(
          '''
          An account already exists with the same email address 
          but different sign-in credentials. 
          ''',
        );
      case 'invalid-credential':
        return const SignInWithGoogleFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const SignInWithGoogleFailure(
          'Operation is not allowed. Please contact support.',
        );
      case 'user-disabled':
        return const SignInWithGoogleFailure(
          'The user corresponding to the given email has been disabled',
        );
      case 'user-not-found':
        return const SignInWithGoogleFailure(
          'Email is not found. Please sign up.',
        );
      case 'wrong-password':
        return const SignInWithGoogleFailure(
          'The password is invalid for the given email',
        );
      case 'invalid-verification-code':
        return const SignInWithGoogleFailure(
          'The verification code is invalid',
        );
      case 'invalid-verification-id':
        return const SignInWithGoogleFailure(
          'The verification ID is invalid',
        );
      default:
        return const SignInWithGoogleFailure();
    }
  }

  /// A human-readable message describing the error.
  final String message;
}

/// Thrown during the sign out process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages the authentication domain.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Whether or not the current environment is web
  /// Should only be overridden for testing purposes. Otherwise,
  /// defaults to the value of [kIsWeb].
  @visibleForTesting
  bool isWeb = kIsWeb;

  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  /// Returns the current cached user.
  /// If there is no cached user, [User.empty] is returned.
  User get currentUser {
    return _cache.read(key: userCacheKey) ?? User.empty;
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// Signs in a user with the provided [email] and [password].
  ///
  /// Throws a [SignInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignInWithEmailAndPasswordFailure();
    }
  }

  /// Signs in a user with Google Sign In.
  ///
  /// Throws a [SignInWithGoogleFailure] if an exception occurs.
  Future<void> signInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;

      if (isWeb) {
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final userCredential =
            await _firebaseAuth.signInWithPopup(googleProvider);
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }

      await _firebaseAuth.signInWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const SignInWithGoogleFailure();
    }
  }

  /// Signs out the current user.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        if (!isWeb) _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  /// Maps a [firebase_auth.User] to a [User].
  User get toUser {
    return User(
      id: uid,
      email: email,
      name: displayName,
      photo: photoURL,
    );
  }
}
