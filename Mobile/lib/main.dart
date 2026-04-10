import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:route_pulse_mobile/core/router/app_router.dart';
import 'package:route_pulse_mobile/core/themes/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
