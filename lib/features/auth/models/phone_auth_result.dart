import 'package:firebase_auth/firebase_auth.dart';


abstract class PhoneAuthResult {}

class PhoneSMSCodeSent extends PhoneAuthResult {
  final String verificationId;

  PhoneSMSCodeSent(this.verificationId);
}

class PhoneAutoVerified extends PhoneAuthResult {
  final UserCredential userCredential;

  PhoneAutoVerified(this.userCredential);
}

class PhoneAuthFailure extends PhoneAuthResult {
  final String? message;

  PhoneAuthFailure(this.message);
}
