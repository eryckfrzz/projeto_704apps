import 'package:flutter/material.dart';
import 'package:projeto_704apps/screens/widgets/sliding_button.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'dart:io' show exit;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedOptionIndex = 1;

  String _serviceStatusMessage =
      'Serviço inativo.'; // Mensagem de status do serviço

  @override
  void initState() {
    super.initState();
    _requestPermissions(); // Solicitar permissões ao iniciar a tela
    _listenToServiceUpdates(); // Começa a escutar atualizações do serviço
    _checkInitialServiceState(); // Verifica o estado inicial do serviço
  }

  // Verifica o estado inicial do serviço ao carregar a tela
  void _checkInitialServiceState() async {
    final service = FlutterBackgroundService();
    final isRunning = await service.isRunning();
    if (isRunning) {
      // Se o serviço estiver rodando, podemos tentar descobrir seu estado
      // Isso pode ser mais complexo sem um mecanismo de estado no serviço
      // Por simplicidade, vamos apenas indicar que está ativo.
      setState(() {
        _serviceStatusMessage = 'Serviço ativo (verifique o modo).';
        // Tentar definir o _selectedOptionIndex com base no estado do serviço
        // Isso exigiria que o serviço enviasse seu estado inicial ao UI
        // Por enquanto, manteremos o OFF como padrão visual.
      });
    }
  }

  // Escuta as mensagens enviadas pelo serviço de background
  void _listenToServiceUpdates() {
    FlutterBackgroundService().on('update').listen((event) {
      if (event != null) {
        final message = event['message'] as String?;
        final date = event['current_date'] as String?;
        setState(() {
          _serviceStatusMessage =
              '$message (${date != null ? DateTime.parse(date).toLocal().toString().substring(11, 19) : ''})';
        });
      }
    });
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [
          Permission.microphone,
          Permission.notification, // Para Android 13+ para foreground service
        ].request();

    if (statuses[Permission.microphone] != PermissionStatus.granted) {
      print("Permissão de microfone negada!");
      //Opcional: mostrar um diálogo ao usuário e levá-lo para as configurações
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Permissão Necessária'),
              content: Text(
                'Para capturar áudio em segundo plano, precisamos da permissão do microfone.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    openAppSettings(); // Abre as configurações do aplicativo
                  },
                  child: Text('Abrir Configurações'),
                ),
              ],
            ),
      );
    }
    if (statuses[Permission.notification] != PermissionStatus.granted) {
      print(
        "Permissão de notificação negada! (Pode afetar o foreground service no Android 13+)",
      );
    }
  }

  void _handleButtonChange(int index) async {
    setState(() {
      _selectedOptionIndex = index;
    });

    final service = FlutterBackgroundService();
    final isRunning = await service.isRunning();

    switch (index) {
      case 0: // AUTO
        print(
          'Modo AUTO selecionado: Fica em background, funcionando e capturando áudio.',
        );
        if (!isRunning) {
          await service.startService();
        }

        
        // Coloca o serviço em foreground (com notificação)
        service.invoke('setAsForeground');
        service.invoke('startRecording'); // Inicia a gravação no serviço
        setState(() {
          _serviceStatusMessage = 'Modo AUTO: Monitorando...';
        });
        if (mounted) { // Verifica se o widget ainda está montado antes de navegar/sair
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
        break;
      case 1: // OFF
        print('Modo OFF selecionado: Desliga e sai do app.');
        if (isRunning) {
          service.invoke('stopRecording'); // Para a gravação no serviço
          service.invoke('stop'); // Para o serviço de background
        }
        setState(() {
          _serviceStatusMessage = 'Serviço inativo.';
        });
        exit(0); // Força a saída do aplicativo

      case 2: // ON
        print(
          'Modo ON selecionado: Escutando direto os áudios e buscando interação.',
        );
        if (!isRunning) {
          await service.startService();
        }
        // Coloca o serviço em background (sem notificação persistente, se configurado assim)
        service.invoke(
          'setAsBackground',
        ); // Ou setAsForeground se preferir notificação persistente
        service.invoke('startRecording'); // Inicia a gravação no serviço
        setState(() {
          _serviceStatusMessage = 'Modo ON: Escutando direto...';
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'config');
            },
            icon: Icon(Icons.settings, size: 50, color: Colors.black),
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/WhatsApp_Image_2025-06-20_at_17.56.48-removebg-preview.png',
            ),
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,

            colorFilter: ColorFilter.mode(
              // ignore: deprecated_member_use
              Colors.white.withOpacity(0.1),
              BlendMode.dstATop,
            ),
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/images/WhatsApp_Image_2025-06-20_at_17.56.48-removebg-preview.png',
              width: 190,
              height: 190,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'MOBILITY WATCH',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 37,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            CustomToggleButton(
              options: const ['AUTO', 'OFF', 'ON'],
              initialIndex: _selectedOptionIndex,
              onChanged: _handleButtonChange,
            ),
          ],
        ),
      ),
    );
  }
}
