import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/app_settings.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/expedition_form_screen.dart';
import 'screens/expedition_details_screen.dart';
import 'screens/route_manager_screen.dart';
import 'screens/gear_manager_screen.dart';
import 'screens/trail_logs_screen.dart';
import 'screens/budget_tasks_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/settings_screen.dart';

class ExpeditionPlannerApp extends StatelessWidget {
  const ExpeditionPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) {
        final settings = AppSettings.instance;

        return MaterialApp(
          title: 'Expedition Planner',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(settings.accentColor),
          darkTheme: AppTheme.darkTheme(settings.accentColor),
          themeMode: settings.themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/expedition-form': (context) => const ExpeditionFormScreen(),
            '/expedition-details': (context) => const ExpeditionDetailsScreen(),
            '/routes': (context) => const RouteManagerScreen(),
            '/gear': (context) => const GearManagerScreen(),
            '/logs': (context) => const TrailLogsScreen(),
            '/budget-tasks': (context) => const BudgetTasksScreen(),
            '/analytics': (context) => const AnalyticsScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}