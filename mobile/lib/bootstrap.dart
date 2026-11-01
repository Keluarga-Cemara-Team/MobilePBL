import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/app.dart';
import 'core/services/notification_service.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  try {
    await NotificationService.instance.init();
  } catch (e) {
    debugPrint('NotificationService initialization error: $e');
  }

  runApp(const ProviderScope(child: AntiBurnoutApp()));
}
