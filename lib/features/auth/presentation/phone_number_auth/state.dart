part of 'bloc.dart';


abstract class PhoneAuthState {}

class AuthEnterPhoneNumberState extends PhoneAuthState {}

class AuthPhoneNumberVerificationInProgressState extends PhoneAuthState {
  final String phoneNumber;

  AuthPhoneNumberVerificationInProgressState(this.phoneNumber);
}

class AuthPhoneNumberVerificationFailedState extends PhoneAuthState {
  final String phoneNumber;
  final String? message;

  AuthPhoneNumberVerificationFailedState({
    required this.phoneNumber,
    this.message,
  });
}

class AuthPhoneNumberVerifiedState extends PhoneAuthState {
  final String phoneNumber;
  final bool isAutoVerified;

  AuthPhoneNumberVerifiedState({
    required this.phoneNumber,
    required this.isAutoVerified,
  });
}

class AuthEnterSMSCodeState extends PhoneAuthState {
  final String phoneNumber;
  final String verificationId;

  AuthEnterSMSCodeState({
    required this.phoneNumber,
    required this.verificationId,
  });
}

class AuthSMSCodeVerificationInProgressState extends PhoneAuthState {
  final String phoneNumber;

  AuthSMSCodeVerificationInProgressState(this.phoneNumber);
}

class AuthSMSCodeVerificationFailedState extends PhoneAuthState {
  final String phoneNumber;
  final String? message;

  AuthSMSCodeVerificationFailedState({
    required this.phoneNumber,
    this.message,
  });
}