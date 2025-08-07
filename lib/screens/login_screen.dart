import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:projeto_704apps/features/models/user.dart';
import 'package:projeto_704apps/screens/home.dart';
import 'package:projeto_704apps/services/background_service.dart';
import 'package:projeto_704apps/services/remote/login_dao_impl.dart';
import 'package:projeto_704apps/features/models/device.dart';
import 'package:projeto_704apps/stores/device_store.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workmanager/workmanager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final LoginDaoImpl _loginDao = LoginDaoImpl();
  late DeviceStore _deviceStore;

  bool _obscureText = true;
  // String? _deviceIdentifier;
  // bool _isGettingDeviceInfo = false;
  // String? _deviceErrorMessage;

  @override
  void initState() {
    super.initState();
    // _getDeviceIdentifier();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _deviceStore = Provider.of<DeviceStore>(context);
  }

 Future<void> _handleLogin() async {
  final User? loggedInUser = await _loginDao.login(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
  );

  if (loggedInUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email ou senha inválidos.')),
    );
    return;
  }

  final prefs = await SharedPreferences.getInstance();

  // Recupera token salvo pelo loginDao
  final token = prefs.getString('access_token');
  if (token == null || token.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro: Token de acesso não recebido.')),
    );
    return;
  }

  // Carrega chave do Google Speech de assets
  String googleSpeechApiKey;
  try {
    googleSpeechApiKey = (await rootBundle.loadString(
      'assets/google_speech_api_key.txt',
    ))
        .trim();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Erro ao carregar chave da API do Google Speech.'),
      ),
    );
    return;
  }

  if (googleSpeechApiKey.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chave do Google Speech está vazia.')),
    );
    return;
  }

  // Salva chave no SharedPreferences (será usada pelo serviço)
  await prefs.setString('google_speech_api_key', googleSpeechApiKey);

  // // 🔄 Para qualquer instância anterior do serviço
  // await FlutterForegroundTask.stopService();

  // // ⚙ Inicializa antes de iniciar (garante compatibilidade)
  // FlutterForegroundTask.init(
  //   androidNotificationOptions: AndroidNotificationOptions(
  //     channelId: 'hostility_detection',
  //     channelName: 'Hostility Detection Service',
  //     channelDescription:
  //         'Serviço para gravação e análise de áudio em segundo plano.',
  //     channelImportance: NotificationChannelImportance.LOW,
  //     priority: NotificationPriority.LOW,
  //     iconData: const NotificationIconData(
  //       resType: ResourceType.mipmap,
  //       resPrefix: ResourcePrefix.ic,
  //       name: 'launcher',
  //     ),
  //   ),
  //   iosNotificationOptions: const IOSNotificationOptions(
  //     showNotification: true,
  //     playSound: false,
  //   ),
  //   foregroundTaskOptions: const ForegroundTaskOptions(
  //     interval: 5000, // Checa a cada 5 segundos
  //     autoRunOnBoot: true,
  //     allowWakeLock: true,
  //   ),
  // );

  // // 🚀 Inicia serviço em foreground
  // await FlutterForegroundTask.startService(
  //   notificationTitle: 'Monitoramento de áudio ativo',
  //   notificationText: 'O app está ouvindo e analisando hostilidade.',
  //   callback: startCallback,
  // );

  // Vai para a Home
  Navigator.pushReplacementNamed(
    context,
    'home',
    arguments: {'userId': loggedInUser.id},
  );
}
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
                    onPressed: () {
                      Navigator.pushNamed(context, 'forgoutPassword');
                    },
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
                  _handleLogin();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  'Continuar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
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
