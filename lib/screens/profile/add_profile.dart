import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_704apps/features/models/user.dart';
import 'package:projeto_704apps/services/remote/users_dao_impl.dart';
import 'package:projeto_704apps/stores/user_store.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importado para SharedPreferences

class AddProfile extends StatefulWidget {
  const AddProfile({super.key});

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _moreInfoController = TextEditingController();

  final UsersDaoImpl service = UsersDaoImpl();
  late UserStore _userStore;

  XFile? _profileImage; // Para a foto de perfil
  List<XFile> _otherImages = []; // Para as fotos diversas (veículo, trabalho, etc.)

  bool _isLoading = false; // Para controlar o estado de carregamento

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData(); // Carrega os dados do usuário ao iniciar a tela
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userStore = Provider.of<UserStore>(context);
  }

  // Função para carregar os dados do usuário e preencher os campos
  Future<void> _loadCurrentUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');
      int? userId = prefs.getInt('user_id'); 

      if (token != null && userId != null) {
        // Chame o método da sua UserStore para buscar o usuário
        await _userStore.getUserId(userId, userAppFlag: true);

        if (_userStore.user != null) {
          _nameController.text = _userStore.user!.name ?? '';
          _phoneController.text = _userStore.user!.phone ?? '';
          _whatsappController.text = _userStore.user!.whatsapp ?? '';
          _emailController.text = _userStore.user!.email ?? '';
          _addressController.text = _userStore.user!.adress ?? ''; // Corrigido para 'adress'
          _moreInfoController.text = _userStore.user!.extraInfos ?? '';
          // Se tiver URLs de imagens no modelo User, você pode carregá-las aqui
        } else {
          _showSnackBar('Não foi possível carregar os dados do perfil.', isError: true);
        }
      } else {
        _showSnackBar('Token ou ID do usuário não encontrados. Faça login novamente.', isError: true);
      }
    } catch (e) {
      _showSnackBar('Erro ao carregar dados do perfil: ${e.toString()}', isError: true);
      print('Erro ao carregar dados do perfil: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para selecionar a foto de perfil
  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          _profileImage = file;
        });
        _showSnackBar('Foto de perfil selecionada!');
      }
    } catch (e) {
      _showSnackBar('Falha ao selecionar foto de perfil: ${e.toString()}', isError: true);
      print('Erro ao selecionar foto de perfil: $e');
    }
  }

  // Função para selecionar múltiplas fotos (veículo, trabalho, etc.)
  Future<void> _pickOtherImages() async {
    final ImagePicker picker = ImagePicker();
    try {
      List<XFile> files = await picker.pickMultiImage();
      if (files.isNotEmpty) {
        if(_otherImages.length + files.length > 4) {
          _showSnackBar('Só é possível adicionar até 4 imagens!', isError: true);
          return;
        }
        setState(() {
          _otherImages.addAll(files); // Adiciona as novas fotos à lista existente
        });
        _showSnackBar('${files.length} fotos selecionadas!');
      }
    } catch (e) {
      _showSnackBar('Falha ao selecionar fotos: ${e.toString()}', isError: true);
      print('Erro ao selecionar fotos: $e');
    }
  }

  // Função auxiliar para exibir SnackBar
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _handleUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    final name = _nameController.text;
    final phone = _phoneController.text;
    final whatsapp = _whatsappController.text;
    final email = _emailController.text;
    final address = _addressController.text;
    final extraInfos = _moreInfoController.text;

    // Garante que o ID do usuário não seja nulo para atualização
    if (_userStore.user?.id == null) {
      _showSnackBar('ID do usuário não disponível para atualização do perfil.', isError: true);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    User updatedUser = User(
      id: _userStore.user!.id, // Use o ID existente
      email: email,
      name: name,
      password: null, // Senha não é atualizada aqui
      phone: phone,
      adress: address,
      whatsapp: whatsapp,
      extraInfos: extraInfos,
    );

    final bool profileUpdated = await _userStore.addUser( // Reutilizando addUser para atualização
      updatedUser,
      userAppFlag: true, // Certifique-se de que userAppFlag é relevante para sua API
    );

    if (profileUpdated) {
      _showSnackBar('Perfil atualizado com sucesso!');

      // Tenta fazer upload da foto de perfil
      if (_profileImage != null) {
        final bool profileImageUploaded = await _userStore.uploadProfileImage(
          _userStore.user!.id!, // Passa o ID do usuário
          _profileImage!.path,
        );
        if (profileImageUploaded) {
          _showSnackBar('Foto de perfil enviada com sucesso!');
        } else {
          _showSnackBar('Falha ao enviar foto de perfil.', isError: true);
        }
      }

      // Tenta fazer upload das outras fotos
      if (_otherImages.isNotEmpty) {
        final List<String> imagePaths = _otherImages.map((xfile) => xfile.path).toList();
        final bool otherImagesUploaded = await _userStore.uploadOtherImages(
          _userStore.user!.id!, // Passa o ID do usuário
          imagePaths,
        );
        if (otherImagesUploaded) {
          _showSnackBar('Fotos diversas enviadas com sucesso!');
        } else {
          _showSnackBar('Falha ao enviar fotos diversas.', isError: true);
        }
      }
      // Opcional: Navegar de volta ou mostrar confirmação
      // Navigator.of(context).pop(true);
    } else {
      _showSnackBar('Falha ao atualizar o perfil!', isError: true);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Perfil',
            style: TextStyle(
              color: Colors.deepPurple[400],
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.deepPurple[400]),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.deepPurple[400],
            width: 350,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Indicador de carregamento
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: _pickProfileImage, // Chama a função para selecionar foto de perfil
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(13)),
                              color: Colors.grey,
                              image: _profileImage != null
                                  ? DecorationImage(
                                      image: FileImage(File(_profileImage!.path)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _profileImage == null
                                ? const Center(
                                    child: Text(
                                      'Foto de Perfil',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[90],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O nome não pode ser vazio.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _phoneController,
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
                      controller: _whatsappController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Whatsapp',
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
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[90],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O e-mail não pode ser vazio.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Endereço',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[90],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O endereço não pode ser vazio.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mais informações sobre você, seu transporte, seu trabalho, etc...',
                            style: TextStyle(fontSize: 11),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _moreInfoController,
                            decoration: const InputDecoration(
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

                    const SizedBox(height: 5),

                    // Botão para adicionar fotos diversas
                    GestureDetector(
                      onTap: _pickOtherImages, // Chama a função para selecionar múltiplas fotos
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(13)),
                          color: Colors.deepPurple[100],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, color: Colors.deepPurple),
                            SizedBox(width: 8),
                            Text(
                              'Adicionar Fotos (Veículo, Trabalho, etc.)',
                              style: TextStyle(fontSize: 14, color: Colors.deepPurple),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Exibição das fotos diversas selecionadas
                    if (_otherImages.isNotEmpty)
                      SizedBox(
                        height: 100, // Altura fixa para a lista de imagens
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _otherImages.length,
                          itemBuilder: (context, index) {
                            
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      image: DecorationImage(
                                        image: FileImage(File(_otherImages[index].path)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _otherImages.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.remove_circle,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            return null;
                          },
                        ),
                      ),
                    const SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: _handleUserProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.fromLTRB(90, 20, 90, 20),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(23)),
                        ),
                      ),
                      child: const Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
