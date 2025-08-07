// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart'; // Para Observer
import 'package:projeto_704apps/stores/user_store.dart'; // Seu UserStore
import 'package:provider/provider.dart'; // Para Provider.of

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  late UserStore _userStore;
  bool _isInitialLoad = true; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userStore = Provider.of<UserStore>(context);

   if (_isInitialLoad || _userStore.users.isEmpty) {
      _userStore.getUsers();
      _isInitialLoad = false; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _userStore.getUsers(),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_userStore.users.isEmpty) {
            return const Center(child: Text('Nenhum usuário disponível.'));
          }

          return ListView.builder(
            itemCount: _userStore.users.length,
            itemBuilder: (context, index) {
              final user = _userStore.users[index];

              // return Card(
              //   margin: const EdgeInsets.all(8),
              //   child: InkWell(
              //     onTap: () async {
              //       final bool? wasDeleted = await Navigator.of(
              //         context,
              //       // ).pushNamed('userDetail', arguments: user.id) as bool?;

              //       if (wasDeleted == true) {
              //         _userStore.removeUserFromList(user.id!);   
              //       }
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.all(16.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'ID: ${user.id}',
              //             style: const TextStyle(fontWeight: FontWeight.bold),
              //           ),
              //           Text('NAME: ${user.name}'),
              //           Text('EMAIL: ${user.email}'),
              //         ],
              //       ),
              //     ),
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
