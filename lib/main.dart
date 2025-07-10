import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key}); // Adicionado Key

  @override
  // Corrigido para retornar um tipo público
  MyAppState createState() => MyAppState();
}

// Renomeado de _MyAppState para MyAppState
class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bíblia Estudo IA',
      theme: ThemeData(
        // Removido brightness para evitar conflito
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light, // Definir brightness aqui
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        // Removido brightness para evitar conflito
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark, // Definir brightness aqui
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: AuthGate(toggleTheme: toggleTheme, currentThemeMode: _themeMode),
    );
  }
}

class AuthGate extends StatelessWidget {
  final VoidCallback toggleTheme;
  final ThemeMode currentThemeMode;

  const AuthGate(
      {super.key, required this.toggleTheme, required this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().user,
      builder: (context, snapshot) {
        // Usuário não está logado
        if (!snapshot.hasData) {
          return const LoginPage();
        }

        // Usuário está logado
        return HomePage(
            toggleTheme: toggleTheme, currentThemeMode: currentThemeMode);
      },
    );
  }
}
