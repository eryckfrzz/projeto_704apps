// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'package:projeto_704apps/domain/models/user.dart';
import 'package:projeto_704apps/stores/user_store.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  late UserStore _userStore;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userStore = Provider.of<UserStore>(context);
  }

  Future<void> _handleAddUser() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final role = _roleController.text;

    final newUser = User(
      id: 0,
      name: name,
      email: email,
      password: password,
      role: role,
    );

    final bool addedSuccessfully = await _userStore.addUser(newUser);

    if (addedSuccessfully) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário adicionado com sucesso!')),
      );
      Navigator.of(
        context,
      ).pop(true); 
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Falha ao adicionar usuário.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Novo Usuário')),
      body: Observer(
        builder: (_) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
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
                      prefixIcon: Icon(Icons.email),
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
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.key),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A senha não pode ser vazia.';
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _roleController,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.key),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O campo não pode ser vazio.';
                      }
                    },
                  ),

                   const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleAddUser,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Adicionar Usuário',
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
