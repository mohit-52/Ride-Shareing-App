import 'dart:async';

import 'package:ride_app/features/auth/models/phone_auth_result.dart';


/// Abstract Phone number based authentication service.
abstract class PhoneNoAuthService<T, D> {
  Future<PhoneAuthResult> verifyPhoneNumber(String phoneNumber);
  Future<T> verifySmsCode(String smsCode, D data);
}

