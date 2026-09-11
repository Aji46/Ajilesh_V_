import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/portfolio_provider.dart';
import 'controllers/nav_provider.dart';
import 'controllers/theme_provider.dart';
import 'utils/app_theme.dart';
import 'views/home_view.dart';

void main() {
  runApp(const AjileshPortfolioApp());
}

class AjileshPortfolioApp extends StatelessWidget {
  const AjileshPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
        ChangeNotifierProvider(create: (_) => NavProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MaterialApp(
        title: 'Ajilesh V | Portfolio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeView(),
      ),
    );
  }
}
