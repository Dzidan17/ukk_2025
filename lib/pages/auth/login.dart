import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'home.dart';
import 'package:ukk_2025/pages/validasi/Validasilogin.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  get error => null;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } else {
        setState(() {
          _errorMessage = "Login gagal. Periksa kembali email dan password.";
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = "Terjadi kesalahan: ${error.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    _emailController.text = "dzidannn@gmail.com";
    _passwordController.text = "12345";

    return Scaffold(
      backgroundColor: const Color(0xFFBF360C),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: const Image(
                    image: AssetImage("assets/images/g1.jpeg"),
                    height: 100,
                    width: 140,
                    fit: BoxFit.fill,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 19),
                  child: Text(
                    "LOGIN",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 25,
                      color: Color(0xFFFAFAFA),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                  child: TextField(
                    controller: _emailController,
                    obscureText: false,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xFFFAFAFA),
                    ),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            const BorderSide(color: Color(0xFFE64A19), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            const BorderSide(color: Color(0xFFE64A19), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            const BorderSide(color: Color(0xFFE64A19), width: 1),
                      ),
                      hintText: "Email",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Color(0xFFFAFAFA),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFF5722),
                      isDense: false,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      prefixIcon: const Icon(Icons.person,
                          color: Color(0xff212435), size: 23),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xFFFAFAFA),
                    ),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            const BorderSide(color: Color(0xFFE64A19), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            const BorderSide(color: Color(0xFFE64A19), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            const BorderSide(color: Color(0xFFE64A19), width: 1),
                      ),
                      hintText: "Password",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Color(0xFFFAFAFA),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFF5722),
                      isDense: false,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      prefixIcon: const Icon(Icons.vpn_key,
                          color: Color(0xff212435), size: 17),
                    ),
                  ),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                MaterialButton(
                  onPressed: _isLoading ? null : _signIn,
                  color: const Color(0xFFE64A19),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Color(0xFFE64A19), width: 1),
                  ),
                  padding: const EdgeInsets.all(16),
                  textColor: const Color(0xFFFAFAFA),
                  height: 40,
                  minWidth: 140,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF6500f)),
                        )
                      : const Text(
                          "Masuk",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}