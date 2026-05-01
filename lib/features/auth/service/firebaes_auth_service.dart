import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_app/features/auth/models/phone_auth_result.dart';
import 'auth_service.dart';


/// Firbase based authentication service.
class FirebasePhoneAuthService implements PhoneNoAuthService<UserCredential, String> {

  /// Phone number must be in format: '+X XXXXXXXXXX'
  @override
  Future<PhoneAuthResult> verifyPhoneNumber(String phoneNumber) async {
    final completer = Completer<PhoneAuthResult>();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Android only: Auto-retrieval of SMS code on some devices.
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        completer.complete(PhoneAutoVerified(userCredential));
      },
      verificationFailed: (FirebaseAuthException e) {
        completer.complete(PhoneAuthFailure(e.message));
      },
      codeSent: (String verificationId, int? resendToken) {
        // Store this ID to use later for manual OTP entry.
        completer.complete(PhoneSMSCodeSent(verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    return await completer.future;
  }

  /// Verify sms code.
  @override
  Future<UserCredential> verifySmsCode(String smsCode, String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
