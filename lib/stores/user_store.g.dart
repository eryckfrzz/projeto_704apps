// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStore, Store {
  late final _$userAtom = Atom(name: '_UserStore.user', context: context);

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$usersAtom = Atom(name: '_UserStore.users', context: context);

  @override
  ObservableList<User> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(ObservableList<User> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  late final _$getUsersAsyncAction =
      AsyncAction('_UserStore.getUsers', context: context);

  @override
  Future<void> getUsers() {
    return _$getUsersAsyncAction.run(() => super.getUsers());
  }

  late final _$getUserIdAsyncAction =
      AsyncAction('_UserStore.getUserId', context: context);

  @override
  Future<void> getUserId(int id) {
    return _$getUserIdAsyncAction.run(() => super.getUserId(id));
  }

  late final _$addUserAsyncAction =
      AsyncAction('_UserStore.addUser', context: context);

  @override
  Future<bool> addUser(User newUser) {
    return _$addUserAsyncAction.run(() => super.addUser(newUser));
  }

  late final _$deleteUserAsyncAction =
      AsyncAction('_UserStore.deleteUser', context: context);

  @override
  Future<bool> deleteUser(int id) {
    return _$deleteUserAsyncAction.run(() => super.deleteUser(id));
  }

  late final _$updateUserAsyncAction =
      AsyncAction('_UserStore.updateUser', context: context);

  @override
  Future<bool> updateUser(User user) {
    return _$updateUserAsyncAction.run(() => super.updateUser(user));
  }

  late final _$_UserStoreActionController =
      ActionController(name: '_UserStore', context: context);

  @override
  void removeUserFromList(int userId) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.removeUserFromList');
    try {
      return super.removeUserFromList(userId);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void userSelected(int index) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.userSelected');
    try {
      return super.userSelected(index);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
users: ${users}
    ''';
  }
}
