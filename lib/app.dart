import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'vistas/inicio_sesion.dart';

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('es', 'MX'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('es', 'MX')],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFCFB53B)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: Color(0xFFCFB53B),
        ),
        scaffoldBackgroundColor: const Color(0xFF06132f),

      ),
      home: const InicioSesion(),
    );
  }
}
