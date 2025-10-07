import 'package:flutter/material.dart';
import 'package:flutter_application_1/portofolio_page.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://bmrqmxuxsrrtsubjucaj.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJtcnFteHV4c3JydHN1Ymp1Y2FqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5MDE3MjQsImV4cCI6MjA3MzQ3NzcyNH0.eymXIuYVzgghsay7jxSSA_iuGGxaa8biSbjDqZfyTrs",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PortfolioPage(),
    );
  }
}
