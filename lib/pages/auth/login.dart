import 'package:flutter/material.dart'; // Mengimpor pustaka Flutter untuk membangun UI.
import 'package:supabase_flutter/supabase_flutter.dart'; // Mengimpor pustaka Supabase untuk autentikasi.
import 'home.dart'; // Mengimpor halaman utama setelah login berhasil.

// Kelas LoginPage yang merupakan StatefulWidget
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

// State untuk LoginPage
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Key untuk form validation.
  final _emailController = TextEditingController(); // Controller untuk input email.
  final _passwordController = TextEditingController(); // Controller untuk input password.
  bool _isLoading = false; // Status untuk menampilkan loading indicator.
  String? _errorMessage; // Menyimpan pesan kesalahan jika login gagal.

  @override
  void dispose() {
    // Membersihkan controller saat widget dihapus untuk mencegah kebocoran memori.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk melakukan proses login ke Supabase
  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return; // Jika form tidak valid, hentikan proses login.
    }

    setState(() {
      _isLoading = true; // Menampilkan loading saat proses login.
      _errorMessage = null; // Reset pesan error sebelum login.
    });

    try {
      final email = _emailController.text.trim(); // Mengambil email yang diinputkan.
      final password = _passwordController.text.trim(); // Mengambil password yang diinputkan.

      // Melakukan autentikasi menggunakan Supabase
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Jika login berhasil, navigasi ke halaman HomePage
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } else {
        // Jika login gagal, tampilkan pesan error
        setState(() {
          _errorMessage = "Email atau Password salah";
        });
      }
    } catch (error) {
      // Menampilkan pesan error jika terjadi kesalahan dalam proses login
      setState(() {
        _errorMessage = "Email atau Password salah";
      });
    } finally {
      // Menyembunyikan loading indicator setelah proses login selesai
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255), // Warna latar belakang halaman login
      body: Align(
        alignment: Alignment.center, // Menengahkan isi halaman login.
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20), // Memberikan padding.
          child: SingleChildScrollView( // Membungkus dengan scroll untuk tampilan yang lebih fleksibel.
            child: Form(
              key: _formKey, // Menggunakan _formKey untuk validasi input.
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("assets/images/g1.jpeg"), // Menampilkan gambar logo.
                    height: 100,
                    width: 140,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 20), // Jarak antara elemen UI.
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      color: Colors.white, // Warna teks putih.
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController, // Menggunakan controller untuk input email.
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)), // Memberikan border melingkar.
                      filled: true,
                      fillColor: Colors.white, // Latar belakang input berwarna putih.
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email tidak boleh kosong"; // Validasi jika email kosong.
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController, // Menggunakan controller untuk input password.
                    obscureText: true, // Menyembunyikan teks agar tidak terlihat saat diketik.
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong"; // Validasi jika password kosong.
                      }
                      return null;
                    },
                  ),
                  if (_errorMessage != null) // Menampilkan pesan error jika ada.
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red), // Warna merah untuk pesan kesalahan.
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signIn, // Jika loading, tombol dinonaktifkan.
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50), // Ukuran tombol.
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)), // Bentuk tombol melingkar.
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)) // Menampilkan indikator loading.
                        : const Text(
                            "Masuk",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
