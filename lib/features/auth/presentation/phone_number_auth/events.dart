part of 'bloc.dart';


abstract class PhoneAuthEvents {}

class AuthVerifyPhoneNumberEvent extends PhoneAuthEvents {
  final String phoneNumber;

  AuthVerifyPhoneNumberEvent(this.phoneNumber);
}

class AuthVerifySMSCodeEvent extends PhoneAuthEvents {
  final String phoneNumber;
  final String verificationId;
  final String smsCode;

  AuthVerifySMSCodeEvent({
    required this.phoneNumber,
    required this.verificationId,
    required this.smsCode,
  });
}