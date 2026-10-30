import 'package:flutter/material.dart';

import '../models/catatan.dart';
import 'detail_catatan_screen.dart';
import 'login_screen.dart';
import 'tambah_catatan_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  // List biasa (bukan const) supaya bisa ditambah, diubah, dan dihapus
  final List<Catatan> _daftarCatatan = [
    const Catatan(
      id: '1',
      judulCatatan: 'Ide Aplikasi',
      isiCatatan: 'Ide untuk membuat aplikasi catatan sederhana dengan fitur kategori, warna, dan prioritas.',
      kategori: 'Penting',
      tanggal: '19 Oktober 2026 • 09.30',
      prioritas: 'Tinggi',
      warna: Color(0xFFFFF3CD),
    ),
    const Catatan(
      id: '2',
      judulCatatan: 'Rencana Mingguan',
      isiCatatan: 'Menyelesaikan tugas praktikum pemrograman mobile menggunakan Flutter.',
      kategori: 'Pribadi',
      tanggal: '18 Oktober 2026',
      prioritas: 'Sedang',
      warna: Color(0xFFD7F5E9),
    ),
  ];

  final TextEditingController _cariController = TextEditingController();
  final List<String> _daftarKategori = ['Semua', 'Penting', 'Pribadi', 'Kerja'];

  String _kategoriAktif = 'Semua';
  String _kataKunci = '';
  int _tabAktif = 0;

  @override
  void dispose() {
    _cariController.dispose();
    super.dispose();
  }

  // Daftar setelah difilter kategori dan pencarian
  List<Catatan> get _catatanTampil {
    return _daftarCatatan.where((c) {
      final cocokKategori =
          _kategoriAktif == 'Semua' || c.kategori == _kategoriAktif;
      final kunci = _kataKunci.toLowerCase();
      final cocokCari =
          c.judulCatatan.toLowerCase().contains(kunci) ||
          c.isiCatatan.toLowerCase().contains(kunci);
      return cocokKategori && cocokCari;
    }).toList();
  }

  Future<void> _bukaTambah() async {
    final hasil = await Navigator.push<Catatan>(
      context,
      MaterialPageRoute(builder: (context) => const TambahCatatanScreen()),
    );
    if (hasil == null || !mounted) return;
    setState(() => _daftarCatatan.insert(0, hasil));
  }

  Future<void> _bukaDetail(Catatan catatan) async {
    final hasil = await Navigator.push<Object>(
      context,
      MaterialPageRoute(
        builder: (context) => DetailCatatanScreen(catatan: catatan),
      ),
    );
    if (!mounted) return;

    if (hasil is Catatan) {
      // Catatan diedit
      setState(() {
        final i = _daftarCatatan.indexWhere((c) => c.id == hasil.id);
        if (i != -1) _daftarCatatan[i] = hasil;
      });
    } else if (hasil == 'hapus') {
      // Catatan dihapus
      setState(() => _daftarCatatan.removeWhere((c) => c.id == catatan.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _bangunAppBar(),
      body: IndexedStack(
        index: _tabAktif,
        children: [_bangunTabBeranda(), _bangunTabArsip(), _bangunTabProfil()],
      ),
      floatingActionButton: _tabAktif == 0
          ? FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: _bukaTambah,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabAktif,
        onTap: (indeks) => setState(() => _tabAktif = indeks),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Arsip'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  PreferredSizeWidget _bangunAppBar() {
    if (_tabAktif == 0) {
      return AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, Maulana',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Apa yang ingin kamu catat hari ini?',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(child: Icon(Icons.person)),
            onPressed: () => setState(() => _tabAktif = 2),
          ),
        ],
      );
    }
    return AppBar(title: Text(_tabAktif == 1 ? 'Arsip' : 'Profil'));
  }

  // ---------- TAB 0: BERANDA ----------
  Widget _bangunTabBeranda() {
    final tampil = _catatanTampil;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _cariController,
            onChanged: (nilai) => setState(() => _kataKunci = nilai),
            decoration: InputDecoration(
              hintText: 'Cari catatan...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.tune),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
          const SizedBox(height: 15),

          // Chip kategori (bisa diklik untuk memfilter)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _daftarKategori.map((kategori) {
              final aktif = _kategoriAktif == kategori;
              return ChoiceChip(
                label: Text(kategori),
                selected: aktif,
                selectedColor: Colors.blue,
                showCheckmark: false,
                labelStyle: TextStyle(color: aktif ? Colors.white : null),
                onSelected: (_) => setState(() => _kategoriAktif = kategori),
              );
            }).toList(),
          ),
          const SizedBox(height: 15),

          Expanded(
            child: tampil.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada catatan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: tampil.length,
                    itemBuilder: (context, indeks) {
                      final item = tampil[indeks];
                      return Card(
                        color: item.warna,
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.sticky_note_2_outlined,
                            color: Colors.blue,
                            size: 36,
                          ),
                          title: Text(
                            item.judulCatatan,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                item.isiCatatan,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.tanggal,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.more_vert),
                          onTap: () => _bukaDetail(item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ---------- TAB 1: ARSIP ----------
  Widget _bangunTabArsip() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_open, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Belum ada catatan di arsip',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ---------- TAB 2: PROFIL ----------
  Widget _bangunTabProfil() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(radius: 44, child: Icon(Icons.person, size: 48)),
          const SizedBox(height: 16),
          const Text(
            'Maulana',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Total catatan: ${_daftarCatatan.length}',
            style: const TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Keluar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
