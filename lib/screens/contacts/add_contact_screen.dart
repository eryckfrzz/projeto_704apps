// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_704apps/features/models/contact.dart';
import 'package:projeto_704apps/stores/contact_store.dart';
import 'package:provider/provider.dart';
// import 'package:geolocator/geolocator.dart'; // Importar o geolocator

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
  String? _currentLocation; // Variável para armazenar a localização formatada

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
  // NOVO: Controlador para o campo de texto do áudio da ligação
  final TextEditingController _callAudioTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _requestLocationAndSetText(); // Solicita permissão de localização e define o texto
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contactStore = Provider.of<ContactStore>(context);
  }

  // // Função para solicitar permissão de localização e obter a localização atual
  // Future<void> _requestLocationAndSetText() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Teste se os serviços de localização estão habilitados.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     _showSnackBar('Serviços de localização desabilitados. Habilite-os para obter a localização.', isError: true);
  //     return;
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       _showSnackBar('Permissão de localização negada. Não será possível obter a localização.', isError: true);
  //       return;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     _showSnackBar('Permissão de localização negada permanentemente. Habilite-a nas configurações do aplicativo.', isError: true);
  //     return;
  //   }

  //   // Quando as permissões são concedidas, obtenha a localização atual
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     setState(() {
  //       _currentLocation = 'Lat: ${position.latitude.toStringAsFixed(6)}, Lon: ${position.longitude.toStringAsFixed(6)}';
  //       _updateCallAudioHintText(); // Atualiza o texto do campo de áudio com a localização
  //     });
  //     _showSnackBar('Localização obtida com sucesso!');
  //   } catch (e) {
  //     _showSnackBar('Erro ao obter localização: ${e.toString()}', isError: true);
  //     print('Erro ao obter localização: $e');
  //   }
  // }

  // Função auxiliar para exibir SnackBar
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // Função para atualizar o texto do campo de áudio da ligação
  void _updateCallAudioHintText() {
    final name = _titleController.text.isNotEmpty ? _titleController.text : 'você';
    final locationPart = _currentLocation != null ? 'minha localização é $_currentLocation' : 'localização desconhecida';
    _callAudioTextController.text = 'Alô, sou $name, estou em perigo, $locationPart';
  }

  Future<void> _handleAddContact() async {
    final title = _titleController.text;
    final number = _numberController.text;
    bool isEmitter = false;

    if(_isGroup == true) {
      isEmitter = false;
    }else{
      isEmitter = true;
    }
    
    final newContact = Contact(
      // id: 0, // Ajuste o ID conforme a sua lógica de backend (se for auto-incremento, pode ser 0 ou null)
      title: title,
      number: number,
      isEmitter: isEmitter,
      // Você pode adicionar a localização ao Contact se o seu modelo Contact tiver um campo para isso
    );

    final bool addedSuccessfully = await _contactStore.registerContact(
      newContact,
    );

    if (addedSuccessfully) {
      _showSnackBar('Contato adicionado com sucesso!');
      Navigator.of(context).pop(true);
    } else {
      _showSnackBar('Falha ao adicionar contato.', isError: true);
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
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[90],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O título não pode ser vazio.';
                      }
                      return null;
                    },
                    onChanged: (_) => _updateCallAudioHintText(), // Atualiza o texto do áudio ao mudar o nome
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Telefone',
                      border: const OutlineInputBorder(),
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
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[90],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O número do Whatsapp não pode ser vazio.';
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
                      const Text('Grupo', style: TextStyle(fontSize: 16)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Notificar por:'),
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
                          const Text('Sms', style: TextStyle(fontSize: 16)),
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
                          const Text('Whatsapp', style: TextStyle(fontSize: 16)),
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
                          const Text('Ligação', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Texto do áudio da ligação'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _callAudioTextController, // Atribuído o novo controlador
                          decoration: InputDecoration(
                            hintText: 'Alô, sou ${_titleController.text}, estou em perigo, minha localização é $_currentLocation',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(fontSize: 16, color: Colors.black),
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
                      const Text(
                        'Notificar para os níveis:',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        width: double.infinity,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedLevel,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            iconSize: 24,
                            style: const TextStyle(color: Colors.black, fontSize: 16),
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
                      padding: const EdgeInsets.symmetric(
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