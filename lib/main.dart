import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'viewmodels/parent_home_viewmodel.dart';
import 'screens/login_screen.dart';
import 'screens/parent_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: '',
    publishableKey: '',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParentHomeViewModel()),
      ],
      child: MaterialApp(
        title: 'Setshabelo Admission',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B4D3E)),
          useMaterial3: true,
        ),
        home: Supabase.instance.client.auth.currentSession != null
            ? const ParentHomeScreen()
            : const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
