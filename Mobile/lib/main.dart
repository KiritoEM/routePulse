import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:route_pulse_mobile/core/dotenv_config.dart';
import 'package:route_pulse_mobile/core/router/app_router.dart';
import 'package:route_pulse_mobile/core/themes/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DotenvConfig.initDotenv();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const ProviderScope(child: const MyApp()));
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
