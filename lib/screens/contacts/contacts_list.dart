import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_704apps/services/contacts_dao_impl.dart'; // Mantido, mas não usado diretamente aqui
import 'package:projeto_704apps/stores/contact_store.dart';
import 'package:provider/provider.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  late ContactStore _contactStore;
  bool _isInitialLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _contactStore = Provider.of<ContactStore>(context, listen: false);

    if (_isInitialLoad) {
      _contactStore.fetchContacts();
      _isInitialLoad = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Contatos'),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              _contactStore.fetchContacts();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: Observer(
        builder: (context) {
          if (_contactStore.contacts.isEmpty) {
            return const Center(child: Text('Nenhum contato encontrado.'));
          }

          return ListView.builder(
            itemCount: _contactStore.contacts.length,
            itemBuilder: (context, index) {
              final contact = _contactStore.contacts[index];

              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    'contactDetail',
                    arguments: contact.id,
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${contact.id}'),
                        Text('TITLE: ${contact.title}'),
                        Text('NUMBER: ${contact.number}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
