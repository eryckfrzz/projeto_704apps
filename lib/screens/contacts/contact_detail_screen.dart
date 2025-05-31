import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_704apps/stores/contact_store.dart';
import 'package:provider/provider.dart';

class ContactDetailScreen extends StatefulWidget {
  final int contactId;
  const ContactDetailScreen({super.key, required this.contactId});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  late ContactStore _contactStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contactStore = Provider.of<ContactStore>(context);

    _contactStore.fetchContactId(widget.contactId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Observer(
        builder: (context) {
          if (_contactStore.contact == null) {
            return const Center(child: Text('Nenhum contato encontrado'));
          }

          final contact = _contactStore.contact!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                   mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${contact.id}'),
                    Text('TITLE: ${contact.title}'),
                    Text('NUMBER: ${contact.number}'),
            
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              'editContact',
                              arguments: contact.id,
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
