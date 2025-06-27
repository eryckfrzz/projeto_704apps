import 'package:flutter/material.dart';
import 'package:projeto_704apps/services/remote/login_dao_impl.dart';
import 'package:projeto_704apps/services/remote/users_dao_impl.dart';

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
      backgroundColor: Colors.black,

      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              SizedBox(height: 30),
              Image.asset(
                'assets/images/WhatsApp_Image_2025-06-20_at_17.56.48-removebg-preview.png',
                width: 170,
                height: 170,
              ),

              SizedBox(height: 20),

              Text(
                'MOBILITY WATCH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 37,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                'Seja bem-vindo(a) ao seu protetor digital!',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),

              SizedBox(height: 90),

              TextFormField(
                cursorColor: Colors.black,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),

                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  floatingLabelStyle: TextStyle(color: Colors.transparent),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                ),
              ),

              SizedBox(height: 20),

              TextFormField(
                cursorColor: Colors.black,
                obscureText: _obscureText,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  floatingLabelStyle: TextStyle(color: Colors.transparent),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Esqueci minha senha',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
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
                child: Text(
                  'Continuar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'addUserScreen');
                },
                child: Text(
                  'Criar conta',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ),

              SizedBox(height: 40),

              Text(
                'Power By',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                'ZAFIRA.IA',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
