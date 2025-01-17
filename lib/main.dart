import 'package:flutter/material.dart'; 
import 'package:shopping_list_app/screens/login_screen.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hlmobvdzudvbnjgbhzra.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhsbW9idmR6dWR2Ym5qZ2JoenJhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY1MzQwODIsImV4cCI6MjA1MjExMDA4Mn0.gx3UeYCQ2kpkqrWJlrHD5sZMRXOrNLl2vJ3PMHq9VsU',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shopping List',
      // The first page shown is controlled by AuthGate, which will decide 
      // whether to show the LoginPage or the ShoppingListScreen based on auth state.
      home: LoginPage(),
    );
  }
}
