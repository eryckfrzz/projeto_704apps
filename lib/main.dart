import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:provider/provider.dart';
import 'my_app.dart';
import 'stores/badword_store.dart';
import 'stores/contact_store.dart';
import 'stores/device_store.dart';
import 'stores/incident_store.dart';
import 'stores/login_store.dart';
import 'stores/user_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'hostility_detection',
      channelName: 'Hostility Detection Service',
      channelDescription: 'Serviço para gravação e análise de áudio.',
      channelImportance: NotificationChannelImportance.LOW,
      priority: NotificationPriority.LOW,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      autoRunOnBoot: true,
      allowWakeLock: true,
      allowWifiLock: true, eventAction: ForegroundTaskEventAction.repeat(30000),
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<UserStore>(create: (_) => UserStore()),
        Provider<ContactStore>(create: (_) => ContactStore()),
        Provider<DeviceStore>(create: (_) => DeviceStore()),
        Provider<LoginStore>(create: (_) => LoginStore()),
        Provider<IncidentStore>(create: (_) => IncidentStore()),
        Provider<BadwordStore>(create: (_) => BadwordStore()),
      ],
      child: const MyApp(),
    ),
  );
}
