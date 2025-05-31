import 'package:flutter/material.dart';
import 'package:projeto_704apps/services/login_dao_impl.dart';
import 'package:projeto_704apps/services/users_dao_impl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginDaoImpl loginDao = LoginDaoImpl();

  final UsersDaoImpl usersDao = UsersDaoImpl();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(16),
        child: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'E-mail',
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),

                  SizedBox(height: 20),

                  TextFormField(
                    obscureText: _obscureText,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      labelText: 'Senha',
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () async {
                      bool value = await loginDao.login(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );

                      if (value) {
                        Navigator.pushNamed(context, 'home');
                        loginDao.getProfile();
                      }
                    },
                    child: Text('Continuar', style: TextStyle(color: Colors.black),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
