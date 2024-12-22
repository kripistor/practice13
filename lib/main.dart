import 'package:flutter/material.dart';
import 'package:practice11/pages/main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: 'https://xheicxquhnayjtoxlntg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhoZWljeHF1aG5heWp0b3hsbnRnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ3NzA5ODgsImV4cCI6MjA1MDM0Njk4OH0.48mKQdC67N_rY-XC6I3_-DdQ58U-QQn5S97MDctG_0Q',
  );
  runApp(const MyApp());
}
final supabase = Supabase.instance.client;
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final session = Supabase.instance.client.auth.currentSession;

        if (session != null) {
          return MainPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}