import 'package:flutter/material.dart';

class AppColors {
  // Define your custom color palette
  static const Color primaryColor = Color(0xFF083D77);  // Deep blue (Primary color)
  static const Color secondaryColor = Color(0xFF429EA6); // Teal (Secondary color)
  static const Color backgroundColor = Color(0xFFEBEBD3); // Light beige (Background color)
  static const Color surfaceColor = Colors.white; // Surface background
  static const Color errorColor = Color(0xFFF4D35E); // Yellow (Error or highlight color)
  static const Color appBarColor = Color(0xFFAAC0AF);  // Soft green (AppBar background color)
  static const Color buttonColor = Color(0xFFF4D35E);  // Yellow (Buttons primary color)
  static const Color textColor = Colors.black87; // Main text color
  static const Color subtitleColor = Colors.black54; // Subtitle text color
}

class AppStyles {
  // Define TextStyles for consistent fonts across your app
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.subtitleColor,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

class AppBarThemeData {
  // Customize the AppBar theme
  static AppBarTheme appBarTheme() {
    return const AppBarTheme(
      color: AppColors.appBarColor,
      elevation: 0,
      titleTextStyle: AppStyles.titleTextStyle,
    );
  }
}

class ButtonStyles {
  // Customize button styles
  static ButtonStyle elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 0, 0, 0), backgroundColor: const Color.fromARGB(255, 167, 158, 127),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: AppStyles.buttonTextStyle,
    );
  }

  static ButtonStyle textButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: AppColors.primaryColor, textStyle: AppStyles.buttonTextStyle,
    );
  }
}

class AppTheme {
  // Combine everything to create a global theme
  static ThemeData theme() {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColor, // Set background color
      appBarTheme: AppBarThemeData.appBarTheme(),
      textButtonTheme: TextButtonThemeData(style: ButtonStyles.textButtonStyle()),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyles.elevatedButtonStyle()),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textColor), // Main body text color
        bodyMedium: TextStyle(color: AppColors.subtitleColor), // Subtext color
        titleLarge: AppStyles.titleTextStyle, // Title text style for headings
        titleMedium: AppStyles.subtitleTextStyle, // Subtitle text style
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
