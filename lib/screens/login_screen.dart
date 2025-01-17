import 'package:flutter/material.dart';
import 'package:shopping_list_app/auth/auth_service.dart';
import 'package:shopping_list_app/screens/shopping_list_screen.dart';
import 'package:shopping_list_app/screens/registration_screen.dart';
import 'package:shopping_list_app/theme.dart'; // Import theme for consistent styling
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';  // Import for social icons

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Get auth service
  final authService = AuthService();

  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // Track loading state
  bool _isPasswordVisible = false; // Track password visibility

  // Login button pressed
// Login button pressed
void login() async {
  // Prepare data
  final email = _emailController.text;
  final password = _passwordController.text;

  // Validate inputs
  if (email.isEmpty || password.isEmpty) {
    _showFriendlyError("Oops! Please fill in all fields. 😊");
    return;
  }

  // Check password complexity
  if (!_isPasswordComplex(password)) {
    _showPasswordComplexityWarning();
    return;
  }

  // Set loading state
  setState(() {
    _isLoading = true;
  });

  // Attempt login
  try {
    await authService.signInWithEmailPassword(email, password);

    // Get the current user's id after successful login
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      // Navigate to ShoppingListScreen after login and pass the userId
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ShoppingListScreen(userId: userId),
        ),
      );
    } else {
      _showFriendlyError("User not authenticated. Please log in again.");
    }
  } catch (e) {
    // Catch any errors and show a snackbar
    _showFriendlyError("Something went wrong! 😓 Please try again.");
  } finally {
    // Reset loading state
    setState(() {
      _isLoading = false;
    });
  }
}

  // Show custom error message with friendly style
  void _showFriendlyError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white), // Error icon
              const SizedBox(width: 10),
              Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
            ],
          ),
          backgroundColor: Colors.redAccent, // Bright background for visibility
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Check password complexity
  bool _isPasswordComplex(String password) {
    // Example password complexity rule: at least 8 characters, 1 uppercase letter, 1 number, and 1 special character
    return password.length >= 8 &&
           RegExp(r'[A-Z]').hasMatch(password) &&
           RegExp(r'[0-9]').hasMatch(password) &&
           RegExp(r'[@$!%*?&]').hasMatch(password);
  }

  // Show password complexity warning message
  void _showPasswordComplexityWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white), // Warning icon
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Password must be at least 8 characters long, contain one uppercase letter, one number, and one special character (e.g., @, !).",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orangeAccent, // Warning color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Icon(
                    Icons.shopping_cart,
                    size: 100,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "QaderSho",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Custom Email TextField with Angled Curve and Transparent Background
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                        filled: true,
                        fillColor: const Color.fromARGB(78, 150, 135, 135), // Transparent background
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20), // Angled curve
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Custom Password TextField with Angled Curve and Transparent Background
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                        filled: true,
                        fillColor: const Color.fromARGB(78, 150, 135, 135), // Transparent background
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20), // Angled curve
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : login,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login", style: TextStyle(fontSize: 16)),
                    style: ButtonStyles.elevatedButtonStyle(),
                  ),
                  const SizedBox(height: 16.0),

                  // Additional Actions (Sign Up, Forgot Password)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text("Don't have an account? Register here."),
                        style: ButtonStyles.textButtonStyle(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),

                  // Social Media Login Options (Google/Facebook)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
