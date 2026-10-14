import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_viewmodel.dart';
import '../routes/route_manager.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return; // Ensure the widget is still mounted

    if (!authVM.isLoggedIn) {
      Navigator.pushReplacementNamed(context, RouteManager.login);
    } else {
      Navigator.pushReplacementNamed(context, RouteManager.parentHome);
    }

    setState(() {
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return const SizedBox.shrink();
  }
}
