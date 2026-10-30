import 'package:flutter/material.dart';

import 'beranda_screen.dart';

class LoginScreen extends StatelessWidget {
  // Kata 'const' di sini dihapus karena kelas ini menggunakan variabel dinamis di bawahnya
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Variabel pengontrol teks (untuk menampung input email dan password dari pengguna)
    final TextEditingController emailController = TextEditingController();
    final TextEditingController kataSandiController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(Icons.edit_note, size: 60, color: Colors.blue),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'MyTrack',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const Center(
                  child: Text(
                    'Masuk untuk melanjutkan',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 40),

                // Label dan Kotak Input Email
                const Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Label dan Kotak Input Password
                const Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: kataSandiController,
                  obscureText:
                      true, // Menyembunyikan teks sandi (bintang-bintang)
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: const Icon(Icons.visibility_off),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Tombol Masuk
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Langsung navigasi ke Beranda tanpa cek database (karena login statis)
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BerandaScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Masuk',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
