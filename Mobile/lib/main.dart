import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:route_pulse_mobile/core/database/hive_config.dart';
import 'package:route_pulse_mobile/core/dotenv_config.dart';
import 'package:route_pulse_mobile/core/router/app_router.dart';
import 'package:route_pulse_mobile/core/themes/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DotenvConfig.initDotenv();

  // init hive local storage
  final appDir = await getApplicationDocumentsDirectory();
  await HiveConfig.init('${appDir.path}/route_pulse_db');

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme.theme(context),
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
