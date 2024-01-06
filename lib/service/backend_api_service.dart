import 'dart:typed_data';

import 'package:talk_trainer/models/user_success_rate.dart';

class BackendApiService {
  BackendApiService._instantiate();

  static final BackendApiService backendApiServiceInstance =
      BackendApiService._instantiate();

  Future<bool> sendAudioStreamAndReceivePauseOrder(
      Stream<Uint8List> audioStream) async {
    await Future.delayed(const Duration(seconds: 3));
    return true;
  }

  Future<UserSuccessRate> sendUserAudioStreamAndReceiveSuccessRate(
      Stream<Uint8List> audioStream) async {
    await Future.delayed(const Duration(seconds: 3));
    return UserSuccessRate(
      wordsAccuracy: 0.78,
      accentAccuracy: 0.59,
      intonationAccuracy: 0.9,
      pronunciationAccuracy: 0.8,
    );
  }
}
