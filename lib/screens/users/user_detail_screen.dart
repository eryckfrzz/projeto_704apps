// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_704apps/commom/exception_dialog.dart';
import 'package:provider/provider.dart';

import 'package:projeto_704apps/stores/user_store.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;
  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late UserStore _userStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userStore = Provider.of<UserStore>(context);

    _userStore.getUserId(widget.userId);
  }

  Future<void> _handleDelete() async {
    final bool? confirmDelete = await showAlertDialog(
      context,
      title: 'Atenção!',
      content: 'Você realmente deseja excluir o usuário selecionado?',
    );

    if (confirmDelete == true) {
      final bool deletedSuccessfully = await _userStore.deleteUser(
        widget.userId,
      );

      if (deletedSuccessfully) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário deletado com sucesso!')),
        );

        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Falha ao deletar usuário.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Observer(
        builder: (_) {
          if (_userStore.user == null) {
            return const Center(
              child: Text('Nenhum dado de usuário disponível.'),
            );
          }

          final user = _userStore.user!;

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ID: ${user.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'NAME: ${user.name}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'EMAIL: ${user.email}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              'editUser',
                              arguments: user.id,
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.green),
                        ),
                        IconButton(
                          onPressed: _handleDelete,
                          icon: const Icon(Icons.delete, color: Colors.red),
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
