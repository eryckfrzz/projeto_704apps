import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projeto_704apps/services/foreground_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workmanager/workmanager.dart';

import 'package:projeto_704apps/screens/widgets/sliding_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedOptionIndex = 1;
  String _serviceStatusMessage = 'Serviço inativo.';

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.microphone,
      Permission.notification,
    ].request();
  }

  Future<void> _startService() async {
    await FlutterForegroundTask.startService(
      notificationTitle: 'Monitoramento de áudio ativo',
      notificationText: 'O app está ouvindo e analisando hostilidade.',
      callback: startCallback,
    );
  }

  Future<void> _stopService() async {
    await FlutterForegroundTask.stopService();
  }

  void _handleButtonChange(int index) {
    setState(() => _selectedOptionIndex = index);

    if (index == 1) {
      _stopService();
      _serviceStatusMessage = 'Serviço inativo.';
    } else {
      _startService();
      _serviceStatusMessage = 'Serviço ativo.';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 50, color: Colors.black),
            onPressed: () => Navigator.pushNamed(context, 'config'),
          ),
        ],
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage(
                'assets/images/WhatsApp_Image_2025-06-20_at_17.56.48-removebg-preview.png',
              ),
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
              colorFilter: ColorFilter.mode(
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
              const Text(
                'MOBILITY WATCH',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 37,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomToggleButton(
                options: const ['AUTO', 'OFF', 'ON'],
                initialIndex: _selectedOptionIndex,
                onChanged: _handleButtonChange,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _serviceStatusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(AudioMonitorTaskHandler());
}
