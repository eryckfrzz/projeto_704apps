import 'package:projeto_704apps/features/models/contact.dart';

abstract class ContactDao {
  Future<Contact?> registerContact(Contact contact, {required String token});
  Future<List<Contact>> getContacts({required String token});
  getContactById(int id, {required String token});
  // Future<bool> updateContact(Contact contact, int id, {required String token});
}
