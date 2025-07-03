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
  String? _selectedLevel = 'Maior que 5';

  final List<String> _levels = [
    'Nível 1',
    'Nível 2',
    'Nível 3',
    'Nível 4',
    'Nível 5',
    'Maior que 5',
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _instanceEmitterController =
      TextEditingController();

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

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text('Texto do áudio da ligação'),
                        SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            hintText:
                                'Alô, sou ${_titleController.text}, estou em perigo, minha localização é //adicionar localização aqui',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),

                          style: TextStyle(fontSize: 16, color: Colors.black),

                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    
                    children: [
                      Text(
                        'Notificar para os níveis:',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),

                      SizedBox(height: 8),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        width: double.infinity,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1 )),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: _selectedLevel,
                            icon: Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            iconSize: 24,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            items: _levels.map((String level) {
                              return DropdownMenuItem<String>(
                                value: level,
                                child: Text(level),
                              );
                            }).toList(),
                            onChanged: (String? newvalue) {
                              setState(() {
                                _selectedLevel = newvalue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleAddContact,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
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
