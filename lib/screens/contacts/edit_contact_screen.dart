import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_704apps/domain/models/contact.dart';
import 'package:projeto_704apps/stores/contact_store.dart';
import 'package:provider/provider.dart';

class EditContactScreen extends StatefulWidget {
  final int contactId;
  const EditContactScreen({super.key, required this.contactId});

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  late ContactStore _contactStore; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contactStore = Provider.of<ContactStore>(context); 

    if (_contactStore.contact?.id != widget.contactId || _contactStore.contact == null) {
      _contactStore.fetchContactId(widget.contactId);
    }
    if (_contactStore.contact != null) {
      _titleController.text = _contactStore.contact!.title ?? '';
      _numberController.text = _contactStore.contact!.number ?? '';
    }
  }

  Future<void> _handleSave() async {
    final title = _titleController.text;
    final number = _numberController.text;

    if (title.isEmpty || number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    final updatedContact = Contact(
      id: widget.contactId,
      title: title,
      number: number,
    );

    final bool updatedSuccessfully = await _contactStore.updateContact(
      updatedContact,
    );

    if (updatedSuccessfully) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contato atualizado com sucesso!')),
      );

      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Falha ao atualizar contato.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Observer(
        builder: (context) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
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
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Número',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O número não pode ser vazio.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Salvar Alterações',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
