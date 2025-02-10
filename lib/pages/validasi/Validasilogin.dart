class Validasilogin {
  static String? validasiEmail(String email) {
    if (email.isEmpty) {
      return "Email tidak boleh kosong!";
    }
    // Regex sederhana untuk validasi format email
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email)) {
      return "Format email tidak valid!";
    }
    return null; // Tidak ada error
  }

  static String? vaidasiPassword(String password) {
    if (password.isEmpty) {
      return "Password tidak boleh kosong!";
    }
    if (password.length < 5) {
      return "Password minimal 5 karakter!";
    }
    return null; // Tidak ada error
  }
}
