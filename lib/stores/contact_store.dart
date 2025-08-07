import 'package:mobx/mobx.dart';
import 'package:projeto_704apps/features/models/contact.dart';
import 'package:projeto_704apps/services/remote/contacts_dao_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'contact_store.g.dart';

class ContactStore = _ContactStore with _$ContactStore;

abstract class _ContactStore with Store {
  @observable
  Contact? contact;

  @observable
  ObservableList<Contact> contacts = ObservableList<Contact>();

  final ContactsDaoImpl service = ContactsDaoImpl();

  @action
  Future<void> fetchContacts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final fetchedContacts = await service.getContacts(token: token!);

    contacts = fetchedContacts.asObservable();
    print('Contatos encontrados! ${contacts.length}');
  }

  @action
  Future<bool> registerContact(Contact newContact) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final Contact? addContact = await service.registerContact(
      newContact,
      token: token!,
    );

    if (addContact != null) {
      contacts.add(addContact);
      contact = addContact;
      return true;
    }

    return false;
  }

  @action
  Future<void> fetchContactId(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final fetchedId = await service.getContactById(id, token: token!);

    if (fetchedId != null) {
      contact = fetchedId;
    }
  }

  // @action
  // Future<bool> updateContact(Contact contact) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   String? token = prefs.getString('access_token');

  //   final contactUpdated = service.updateContact(
  //     contact,
  //     // contact.id,
  //     token: token!,
  //   );

  //   if (contactUpdated != null) {
  //     this.contact = contact;

  //     // final int index = contacts.indexWhere((c) => c.id == contact.id);

  //     // if (index != -1) {
  //     //   contacts[index] = contact;
  //     // }

  //     return true;
  //   }

  //   return false;
  // }
}
