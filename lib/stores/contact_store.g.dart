// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ContactStore on _ContactStore, Store {
  late final _$contactAtom =
      Atom(name: '_ContactStore.contact', context: context);

  @override
  Contact? get contact {
    _$contactAtom.reportRead();
    return super.contact;
  }

  @override
  set contact(Contact? value) {
    _$contactAtom.reportWrite(value, super.contact, () {
      super.contact = value;
    });
  }

  late final _$contactsAtom =
      Atom(name: '_ContactStore.contacts', context: context);

  @override
  ObservableList<Contact> get contacts {
    _$contactsAtom.reportRead();
    return super.contacts;
  }

  @override
  set contacts(ObservableList<Contact> value) {
    _$contactsAtom.reportWrite(value, super.contacts, () {
      super.contacts = value;
    });
  }

  late final _$fetchContactsAsyncAction =
      AsyncAction('_ContactStore.fetchContacts', context: context);

  @override
  Future<void> fetchContacts() {
    return _$fetchContactsAsyncAction.run(() => super.fetchContacts());
  }

  late final _$registerContactAsyncAction =
      AsyncAction('_ContactStore.registerContact', context: context);

  @override
  Future<bool> registerContact(Contact newContact) {
    return _$registerContactAsyncAction
        .run(() => super.registerContact(newContact));
  }

  late final _$fetchContactIdAsyncAction =
      AsyncAction('_ContactStore.fetchContactId', context: context);

  @override
  Future<void> fetchContactId(int id) {
    return _$fetchContactIdAsyncAction.run(() => super.fetchContactId(id));
  }

  late final _$updateContactAsyncAction =
      AsyncAction('_ContactStore.updateContact', context: context);

  @override
  Future<bool> updateContact(Contact contact) {
    return _$updateContactAsyncAction.run(() => super.updateContact(contact));
  }

  @override
  String toString() {
    return '''
contact: ${contact},
contacts: ${contacts}
    ''';
  }
}
