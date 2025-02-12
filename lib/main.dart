import 'package:flutter/material.dart'; // Mengimpor pustaka Flutter untuk membangun UI.
import 'package:supabase_flutter/supabase_flutter.dart'; // Mengimpor pustaka Supabase untuk menghubungkan aplikasi ke backend.
import 'pages/auth/login.dart'; // Mengimpor halaman login dari folder pages/auth.

// Fungsi utama untuk menjalankan aplikasi Flutter
void main() async {
  // Memastikan binding widget telah diinisialisasi sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase dengan URL proyek dan anonKey
  await Supabase.initialize(
    url: 'https://jpauepvntqjzzioxlpfc.supabase.co', // URL proyek Supabase
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpwYXVlcHZudHFqenppb3hscGZjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3MTM4MTEsImV4cCI6MjA1NDI4OTgxMX0.jfexCnm2rFp3wXd4WbF67Mf9ihnVJ6po8cmDfsVmGQY', // Kunci anon yang digunakan untuk autentikasi Supabase
  );

  // Menjalankan aplikasi Flutter dengan widget MyApp sebagai root
  runApp(const MyApp());
}

// Kelas utama aplikasi yang merupakan StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug di pojok kanan atas
      title: 'My App', // Judul aplikasi
      theme: ThemeData(
        primarySwatch: Colors.blue, // Menentukan tema warna utama aplikasi
      ),
      home: LoginPage(), // Menentukan halaman pertama yang ditampilkan, yaitu halaman login
    );
  }
}
