import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpwYXVlcHZudHFqenppb3hscGZjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3MTM4MTEsImV4cCI6MjA1NDI4OTgxMX0.jfexCnm2rFp3wXd4WbF67Mf9ihnVJ6po8cmDfsVmGQY';
  String projectUrl = 'https://jpauepvntqjzzioxlpfc.supabase.co';
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: projectUrl,
    anonKey: supabaseKey,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
