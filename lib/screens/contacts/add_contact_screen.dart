// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_704apps/domain/models/contact.dart';
import 'package:projeto_704apps/stores/contact_store.dart';
import 'package:provider/provider.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  late ContactStore _contactStore;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contactStore = Provider.of<ContactStore>(context);
  }

  Future<void> _handleAddContact() async {
    final title = _titleController.text;
    final number = _numberController.text;

    final newContact = Contact(id: 0, title: title, number: number);

    final bool addedSuccessfully = await _contactStore.registerContact(
      newContact,
    );

    if (addedSuccessfully) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contato adicionado com sucesso!')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Falha ao adicionar contato.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Novo Contato')),
      body: Observer(
        builder: (_) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.abc),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O título não pode ser vazio.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O número não pode ser vazio.';
                      }
                    
                      return null;
                    },
                  ),


                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleAddContact,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Adicionar Contato',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
