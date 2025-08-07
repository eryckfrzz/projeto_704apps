// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ImageStore on _ImageStore, Store {
  late final _$imageAtom = Atom(name: '_ImageStore.image', context: context);

  @override
  ListImages? get image {
    _$imageAtom.reportRead();
    return super.image;
  }

  @override
  set image(ListImages? value) {
    _$imageAtom.reportWrite(value, super.image, () {
      super.image = value;
    });
  }

  late final _$registerImageAnalysisAsyncAction =
      AsyncAction('_ImageStore.registerImageAnalysis', context: context);

  @override
  Future<ListImages?> registerImageAnalysis(int userId, List<String> paths) {
    return _$registerImageAnalysisAsyncAction
        .run(() => super.registerImageAnalysis(userId, paths));
  }

  @override
  String toString() {
    return '''
image: ${image}
    ''';
  }
}
