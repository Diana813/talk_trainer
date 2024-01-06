import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';

class MyCustomSource extends StreamAudioSource {
  final Stream<Uint8List> bytes;

  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length as int;
    return StreamAudioResponse(
      sourceLength: bytes.length as int,
      contentLength: end - start,
      offset: start,
      stream: bytes,
      contentType: 'audio/mp3',
    );
  }
}
