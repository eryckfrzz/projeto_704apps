// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badword_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BadwordStore on _BadwordStore, Store {
  late final _$defaultBadwordsAtom =
      Atom(name: '_BadwordStore.defaultBadwords', context: context);

  @override
  ObservableList<Badword> get defaultBadwords {
    _$defaultBadwordsAtom.reportRead();
    return super.defaultBadwords;
  }

  @override
  set defaultBadwords(ObservableList<Badword> value) {
    _$defaultBadwordsAtom.reportWrite(value, super.defaultBadwords, () {
      super.defaultBadwords = value;
    });
  }

  late final _$configuredBadwordsAtom =
      Atom(name: '_BadwordStore.configuredBadwords', context: context);

  @override
  ObservableList<Badword> get configuredBadwords {
    _$configuredBadwordsAtom.reportRead();
    return super.configuredBadwords;
  }

  @override
  set configuredBadwords(ObservableList<Badword> value) {
    _$configuredBadwordsAtom.reportWrite(value, super.configuredBadwords, () {
      super.configuredBadwords = value;
    });
  }

  late final _$customBadwordsAtom =
      Atom(name: '_BadwordStore.customBadwords', context: context);

  @override
  ObservableList<Badword> get customBadwords {
    _$customBadwordsAtom.reportRead();
    return super.customBadwords;
  }

  @override
  set customBadwords(ObservableList<Badword> value) {
    _$customBadwordsAtom.reportWrite(value, super.customBadwords, () {
      super.customBadwords = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_BadwordStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_BadwordStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$fetchAllBadwordsAsyncAction =
      AsyncAction('_BadwordStore.fetchAllBadwords', context: context);

  @override
  Future<void> fetchAllBadwords() {
    return _$fetchAllBadwordsAsyncAction.run(() => super.fetchAllBadwords());
  }

  late final _$registerCustomBadwordAsyncAction =
      AsyncAction('_BadwordStore.registerCustomBadword', context: context);

  @override
  Future<bool> registerCustomBadword(Badword badword) {
    return _$registerCustomBadwordAsyncAction
        .run(() => super.registerCustomBadword(badword));
  }

  late final _$updateBadwordAsyncAction =
      AsyncAction('_BadwordStore.updateBadword', context: context);

  @override
  Future<bool> updateBadword(int userId, String oldWord, String newWord) {
    return _$updateBadwordAsyncAction
        .run(() => super.updateBadword(userId, oldWord, newWord));
  }

  late final _$deleteBadwordCustomAsyncAction =
      AsyncAction('_BadwordStore.deleteBadwordCustom', context: context);

  @override
  Future<bool> deleteBadwordCustom(int userId, String word) {
    return _$deleteBadwordCustomAsyncAction
        .run(() => super.deleteBadwordCustom(userId, word));
  }

  @override
  String toString() {
    return '''
defaultBadwords: ${defaultBadwords},
configuredBadwords: ${configuredBadwords},
customBadwords: ${customBadwords},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
