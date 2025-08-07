// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'audio_store.dart';

// // **************************************************************************
// // StoreGenerator
// // **************************************************************************

// // ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

// mixin _$AudioStore on _AudioStore, Store {
//   late final _$audioAtom = Atom(name: '_AudioStore.audio', context: context);

//   @override
//   Audio? get audio {
//     _$audioAtom.reportRead();
//     return super.audio;
//   }

//   @override
//   set audio(Audio? value) {
//     _$audioAtom.reportWrite(value, super.audio, () {
//       super.audio = value;
//     });
//   }

//   late final _$registerAudioAnalysisAsyncAction =
//       AsyncAction('_AudioStore.registerAudioAnalysis', context: context);

//   @override
//   Future<Audio?> registerAudioAnalysis(Uint8List audioData, String timeStamp) {
//     return _$registerAudioAnalysisAsyncAction
//         .run(() => super.registerAudioAnalysis(audioData, timeStamp));
//   }

//   @override
//   String toString() {
//     return '''
// audio: ${audio}
//     ''';
//   }
// }
