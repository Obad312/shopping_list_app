import 'package:flutter/material.dart';
import 'package:shopping_list_app/screens/login_screen.dart'; // Import login screen
import 'package:shopping_list_app/screens/shopping_list_screen.dart'; // Import shopping list screen
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Show loading indicator while waiting for connection
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Check if there is a valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;

        // First screen is LoginPage when no session is present
        if (session == null) {
          return const LoginPage(); // Login page shown initially
        } else {
          // Retrieve user_id from the session
          final userId = session.user?.id;

          if (userId != null) {
            // Pass the user_id to the ShoppingListScreen
            return ShoppingListScreen(userId: userId); // Shopping list page if authenticated
          } else {
            // If no user_id is found, return to LoginPage
            return const LoginPage();
          }
        }
      },
    );
  }
}
