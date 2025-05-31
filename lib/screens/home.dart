import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_704apps/stores/contact_store.dart';
import 'package:projeto_704apps/stores/user_store.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final userStore = Provider.of<UserStore>(context);

    final contactStore = Provider.of<ContactStore>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Observer(
        builder:
            (_) => Container(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(90)),
                        color: Colors.black,
                      ),
                      child: Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    SizedBox(height: 100),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap:
                              () =>
                                  Navigator.pushNamed(context, 'addUserScreen'),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.black,
                            ),
                            width: 180,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_add_alt_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 15),

                                Text(
                                  'Cadastro de',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Usuários',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'usersList');
                            userStore.getUsers();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.black,
                            ),
                            width: 180,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.list_alt_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 15),

                                Text(
                                  'Lista de',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Usuários',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap:
                              () =>
                                  Navigator.pushNamed(context, 'addContactScreen'),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.black,
                            ),
                            width: 180,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_add_alt_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 15),

                                Text(
                                  'Cadastro de',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Contatos',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'contactsList');
                            userStore.getUsers();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.black,
                            ),
                            width: 180,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.contact_page_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 15),

                                Text(
                                  'Lista de',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Contatos',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 90),

                    Text(
                      'Bem-vindo(a) a Zafira!',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
