import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/app_provider.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/dashboard/presentation/main_layout.dart';

void main() {
  runApp(const DasaWismaApp());
}

class DasaWismaApp extends StatelessWidget {
  const DasaWismaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        title: 'Sistem Informasi Dasa Wisma Desa Japan',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/dashboard': (context) => const MainLayout(),
        },
      ),
    );
  }
}
