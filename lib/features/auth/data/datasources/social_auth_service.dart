import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthResult {
  final String idToken;
  final String firstName;
  final String lastName;
  final String email;

  SocialAuthResult({
    required this.idToken,
    required this.firstName,
    required this.lastName,
    required this.email,
  });
}

class SocialAuthService {
  static Future<SocialAuthResult?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    final User? user = userCredential.user;
    if (user == null) return null;
    final idToken = await user.getIdToken();
    if (idToken == null) return null;

    final nameParts = (user.displayName ?? '').split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : 'User';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return SocialAuthResult(
      idToken: idToken,
      firstName: firstName,
      lastName: lastName,
      email: user.email ?? '',
    );
  }

  static Future<SocialAuthResult?> signInWithApple() async {
    final AuthorizationCredentialAppleID appleCredential =
        await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

    final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
    final OAuthCredential credential = oAuthProvider.credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    final User? user = userCredential.user;
    if (user == null) return null;
    final idToken = await user.getIdToken();
    if (idToken == null) return null;

    String firstName = appleCredential.givenName ?? '';
    String lastName = appleCredential.familyName ?? '';

    // Apple only provides the name on the very first sign-in.
    // If we don't get it, we try to fallback to Firebase User info.
    if (firstName.isEmpty && lastName.isEmpty) {
      final nameParts = (user.displayName ?? '').split(' ');
      firstName = nameParts.isNotEmpty ? nameParts.first : 'User';
      lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    }

    return SocialAuthResult(
      idToken: idToken,
      firstName: firstName,
      lastName: lastName,
      email: appleCredential.email ?? user.email ?? '',
    );
  }

  static String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  static Future<SocialAuthResult?> signInWithFacebook() async {
    final rawNonce = _generateNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final LoginResult result = await FacebookAuth.instance.login(
      nonce: hashedNonce,
    );
    if (result.status != LoginStatus.success) return null;

    final token = result.accessToken!;
    late AuthCredential credential;

    // Check if the token is a limited login token (iOS 17+ requirement for tracking consent)
    // flutter_facebook_auth exposes `declinedPermissions` or we can just try to see if it's a limited token.
    // wait, `flutter_facebook_auth`'s `AccessToken` might not expose `type` in older versions.
    // Let me check if `flutter_facebook_auth` has `isLimitedLogin` or similar. Wait, the prompt specifically says:
    // "loginResult.accessToken!.type == AccessTokenType.classic"
    if (token.type == AccessTokenType.classic) {
      credential = FacebookAuthProvider.credential(token.tokenString);
    } else {
      credential = OAuthCredential(
        providerId: 'facebook.com',
        signInMethod: 'oauth',
        idToken: token.tokenString,
        rawNonce: rawNonce,
      );
    }

    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    final User? user = userCredential.user;
    if (user == null) return null;
    final idToken = await user.getIdToken();
    if (idToken == null) return null;

    final nameParts = (user.displayName ?? '').split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : 'User';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return SocialAuthResult(
      idToken: idToken,
      firstName: firstName,
      lastName: lastName,
      email: user.email ?? '',
    );
  }
}
