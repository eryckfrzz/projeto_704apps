// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'package:projeto_704apps/features/models/user.dart';
import 'package:projeto_704apps/stores/user_store.dart';

class EditScreen extends StatefulWidget {
  final int userId;
  const EditScreen({super.key, required this.userId});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late UserStore _userStore;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _userProfile = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userStore = Provider.of<UserStore>(context);

    if (_userStore.user?.id != widget.userId || _userStore.user == null) {
      _userStore.getUserId(widget.userId, userAppFlag: false);
    }
    if (_userStore.user != null) {
      _nameController.text = _userStore.user!.name ?? '';
      _emailController.text = _userStore.user!.email ?? '';
    }
  }

  Future<void> _handleSave() async {
    final updatedName = _nameController.text;
    final updatedEmail = _emailController.text;

    final updatedUser = User(
      id: widget.userId,
      name: updatedName,
      email: updatedEmail,
      password: '',
      //role: '',
      //userApp: _userProfile,
      phone: '',
      adress: '',
      whatsapp: '',
      //moreInfo: '', 
      extraInfos: '',
    );

    final bool updatedSuccessfully = await _userStore.updateUser(updatedUser);

    if (updatedSuccessfully) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário atualizado com sucesso!')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Falha ao atualizar usuário!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Observer(
        builder: (_) {
          if (_userStore.user == null) {
            return const Center(child: Text('Usuário não encontrado.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
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
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O email não pode ser vazio.';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Por favor, insira um email válido.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
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
            ),
          );
        },
      ),
    );
  }
}
