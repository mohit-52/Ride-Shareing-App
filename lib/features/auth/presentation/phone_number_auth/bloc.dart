import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_app/features/auth/models/phone_auth_result.dart';
import 'package:ride_app/features/auth/service/auth_service.dart';
import 'package:ride_app/features/auth/service/firebaes_auth_service.dart';

part 'events.dart';
part 'state.dart';


final class PhoneNoAuthBloc extends Bloc<PhoneAuthEvents, PhoneAuthState> {
  final PhoneNoAuthService<UserCredential, String> _phoneAuthService;

  PhoneNoAuthBloc([
    PhoneAuthState? initialState,
    PhoneNoAuthService<UserCredential, String>? phoneAuthService,
  ])
    : _phoneAuthService = phoneAuthService ?? FirebasePhoneAuthService(),
      super(initialState ?? AuthEnterPhoneNumberState())
  {
    on<AuthVerifyPhoneNumberEvent>(_verifyPhoneNumber);
    on<AuthVerifySMSCodeEvent>(_verifySMSCode);
  }

  FutureOr<void> _verifyPhoneNumber(
    AuthVerifyPhoneNumberEvent event,
    Emitter<PhoneAuthState> emit,
  ) async {
    emit(AuthPhoneNumberVerificationInProgressState(event.phoneNumber));

    final result = await _phoneAuthService.verifyPhoneNumber(event.phoneNumber);

    final newState = (switch (result) {
      PhoneSMSCodeSent(:final verificationId) => AuthEnterSMSCodeState(
        phoneNumber: event.phoneNumber,
        verificationId: verificationId,
      ),
      PhoneAutoVerified() => AuthPhoneNumberVerifiedState(
        phoneNumber: event.phoneNumber,
        isAutoVerified: true,
      ),
      PhoneAuthFailure(:final message) => AuthPhoneNumberVerificationFailedState(
        phoneNumber: event.phoneNumber,
        message: message,
      ),
      _ => null,
    });

    if (newState != null) emit(newState);
  }

  FutureOr<void> _verifySMSCode(
    AuthVerifySMSCodeEvent event,
    Emitter<PhoneAuthState> emit,
  ) async {
    emit(AuthSMSCodeVerificationInProgressState(event.phoneNumber));

    try {
      await _phoneAuthService.verifySmsCode(
        event.smsCode,
        event.verificationId,
      );

      emit(AuthPhoneNumberVerifiedState(
        phoneNumber: event.phoneNumber,
        isAutoVerified: false,
      ));
    } catch (e) {
      emit(AuthSMSCodeVerificationFailedState(
        phoneNumber: event.phoneNumber,
        message: e.toString(),
      ));
    }
  }
}
