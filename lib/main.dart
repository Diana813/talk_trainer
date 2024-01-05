import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talk_trainer/screens/android_welcome_screen.dart';
import 'package:talk_trainer/screens/web_search_screen.dart';
import 'package:talk_trainer/utils/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appName = 'talk trainer';

    return MaterialApp(
      title: appName,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.lightBackground,
        highlightColor: AppColors.primaryHighlight,
        primaryColor: AppColors.lightBackground,
        primarySwatch: AppColors.white,
        primaryColorLight: AppColors.white,
        primaryColorDark: AppColors.primaryBackground,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppColors.primaryBackground),
        indicatorColor: AppColors.secondaryBackground,
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryBackground),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primaryShadow,
          selectionColor: AppColors.primaryBackground.withOpacity(0.3),
          selectionHandleColor: AppColors.primaryBackground.shade700,
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.lora(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          titleMedium: GoogleFonts.lora(
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.lora(fontSize: 16),
          displaySmall: GoogleFonts.pacifico(),
        ),
      ),
      home: const MyHomePage(
        title: appName,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).shadowColor,
                )),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: kIsWeb ? WebSearchScreen() : const AndroidWelcomeScreen(),
    );
  }
}
