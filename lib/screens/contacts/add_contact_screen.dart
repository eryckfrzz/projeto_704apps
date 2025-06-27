// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_704apps/features/models/contact.dart';
import 'package:projeto_704apps/stores/contact_store.dart';
import 'package:provider/provider.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  late ContactStore _contactStore;
  bool _isGroup = false;
  bool _isSms = false;
  bool _isWhats = false;
  bool _isCall = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _instanceEmitterController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contactStore = Provider.of<ContactStore>(context);
  }

  Future<void> _handleAddContact() async {
    final title = _titleController.text;
    final number = _numberController.text;
    final instanceEmitter = _instanceEmitterController.text;

    final newContact = Contact(
      id: 0,
      title: title,
      number: number,
      instanceEmitter: instanceEmitter,
    );

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
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[90],
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
                    decoration: InputDecoration(
                      labelText: 'Telefone',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[90],
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O número não pode ser vazio.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _instanceEmitterController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Whatsapp',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[90],
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O número não pode ser vazio.';
                      }

                      return null;
                    },
                  ),

                  Row(
                    children: [
                      Checkbox(
                        value: _isGroup,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _isGroup = newValue ?? false;
                          });
                        },

                        activeColor: Colors.green,
                        checkColor: Colors.white,
                      ),

                      Text('Grupo', style: TextStyle(fontSize: 16)),
                    ],
                  ),

                  SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notificar por:'),
                      Row(
                        children: [
                          Checkbox(
                            value: _isSms,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _isSms = newValue ?? false;
                              });
                            },

                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),

                          Text('Sms', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isWhats,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _isWhats = newValue ?? false;
                              });
                            },

                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),

                          Text('Whatsapp', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isCall,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _isCall = newValue ?? false;
                              });
                            },

                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),

                          Text('Ligação', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),

                  //adicionar campo para texto de transcrição e escolha de nível de ofensa

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleAddContact,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.green
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
