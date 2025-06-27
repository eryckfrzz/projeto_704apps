// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'package:projeto_704apps/features/models/user.dart';
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
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Falha ao adicionar usuário.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Observer(
        builder: (_) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/LOGO_ZAFIRA-01b.png',
                    width: 190,
                    height: 190,
                  ),

                  SizedBox(height: 60),

                  TextFormField(
                     cursorColor: Colors.black,
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),

                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
                      floatingLabelStyle: TextStyle(color: Colors.transparent),
                      fillColor: Colors.white,
                      filled: true,

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O nome não pode ser vazio.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                     cursorColor: Colors.black,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),

                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
                      floatingLabelStyle: TextStyle(color: Colors.transparent),
                      fillColor: Colors.white,
                      filled: true,

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
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
                  const SizedBox(height: 25),

                  TextFormField(
                    cursorColor: Colors.black,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),

                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
                      floatingLabelStyle: TextStyle(color: Colors.transparent),
                      fillColor: Colors.white,
                      filled: true,

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A senha não pode ser vazia.';
                      }
                    },
                  ),

                  const SizedBox(height: 25),

                  TextFormField(
                    controller: _roleController,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),

                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
                      floatingLabelStyle: TextStyle(color: Colors.transparent),
                      fillColor: Colors.white,
                      filled: true,

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O campo não pode ser vazio.';
                      }
                    },
                  ),

                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: _handleAddUser,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      backgroundColor: Colors.blue
                    ),
                    child: const Text(
                      'Adicionar Usuário',
                      style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18, color: Colors.white),
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
