import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_models/auth_viewmodel.dart';
import '../view_models/application_viewmodel.dart';
import '../routes/route_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hrkzdekzmqjiejjuwybh.supabase.co',
    publishableKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhya3pkZWt6bXFqaWVqanV3eWJoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc2NzkwMTAsImV4cCI6MjEwMzI1NTAxMH0.OjJSoMWUOSn3HUXii0qcGaME7R1TE2BOP72e6qVhQNs',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ApplicationViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Setshabelo Admission System',
        initialRoute: RouteManager.splash,
        onGenerateRoute: RouteManager.generateRoute,
        theme: _buildTheme(),
      ),
    );
  }
}
