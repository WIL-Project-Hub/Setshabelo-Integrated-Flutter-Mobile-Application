import 'package:flutter/material.dart';
import '../views/auth_wrapper.dart';
import '../views/login.dart';
import '../views/home.dart';
import '../views/application_form.dart';
import '../views/check_status.dart';
import '../views/view_application.dart';
import '../views/view_achievements.dart';
import '../views/view_notifications.dart';
import '../views/splash_view.dart';

class RouteManager {
  static const String splash = '/';
  static const String login = '/login';
  static const String parentHome = '/Home';
  static const String applicationForm = '/applicationForm';
  static const String applicationStatus = '/applicationStatus';
  static const String applicationDetail = '/applicationDetail';
  static const String achievement = '/achievements';
  static const String notification = '/notifications';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case parentHome:
        return MaterialPageRoute(builder: (_) => const ParentHomeView());
      case applicationForm:
        return MaterialPageRoute(builder: (_) => const ApplicationFormView());
      case applicationStatus:
        return MaterialPageRoute(builder: (_) => const ApplicationStatusView());
      case applicationDetail:
        return MaterialPageRoute(builder: (_) => const ApplicationDetailView());
      case achievement:
        return MaterialPageRoute(builder: (_) => const AchievementsView());
      case notification:
        return MaterialPageRoute(builder: (_) => const NotificationView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
