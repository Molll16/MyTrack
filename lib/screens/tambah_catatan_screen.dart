import 'package:flutter/material.dart';

import '../models/catatan.dart';

class TambahCatatanScreen extends StatefulWidget {
  // Kalau diisi, halaman ini berfungsi sebagai mode edit
  final Catatan? catatan;

  const TambahCatatanScreen({super.key, this.catatan});

  @override
  State<TambahCatatanScreen> createState() => _TambahCatatanScreenState();
}

class _TambahCatatanScreenState extends State<TambahCatatanScreen> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();

  final List<String> _daftarKategori = ['Penting', 'Pribadi', 'Kerja'];
  final List<Color> _daftarWarna = const [
    Color(0xFFFFF3CD),
    Color(0xFFD7F5E9),
    Color(0xFFE3F2FD),
    Color(0xFFFFE0EC),
    Color(0xFFEDE7F6),
  ];

  String? _kategori;
  String _prioritas = 'Sedang';
  late Color _warna;

  bool get _modeEdit => widget.catatan != null;

  @override
  void initState() {
    super.initState();
    final c = widget.catatan;
    _warna = c?.warna ?? _daftarWarna.first;
    if (c != null) {
      _judulController.text = c.judulCatatan;
      _isiController.text = c.isiCatatan;
      _kategori = c.kategori;
      _prioritas = c.prioritas;
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  String _formatTanggal(DateTime d) {
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final jam = d.hour.toString().padLeft(2, '0');
    final menit = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${bulan[d.month - 1]} ${d.year} • $jam.$menit';
  }

  void _simpan() {
    final judul = _judulController.text.trim();
    final isi = _isiController.text.trim();

    if (judul.isEmpty || isi.isEmpty || _kategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul, isi, dan kategori wajib diisi')),
      );
      return;
    }

    final hasil = Catatan(
      id:
          widget.catatan?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      judulCatatan: judul,
      isiCatatan: isi,
      kategori: _kategori!,
      tanggal: widget.catatan?.tanggal ?? _formatTanggal(DateTime.now()),
      prioritas: _prioritas,
      warna: _warna,
    );

    // Kirim catatan ke halaman sebelumnya
    Navigator.pop(context, hasil);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modeEdit ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Judul Catatan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _judulController,
                decoration: InputDecoration(
                  hintText: 'Masukkan judul catatan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Isi Catatan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _isiController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Tulis catatan Anda di sini...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Kategori',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                // ignore: deprecated_member_use
                value: _kategori,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                hint: const Text('Pilih kategori'),
                items: _daftarKategori
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (nilai) => setState(() => _kategori = nilai),
              ),
              const SizedBox(height: 20),
              const Text(
                'Warna',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: _daftarWarna.map((warna) {
                  final dipilih = _warna == warna;
                  return GestureDetector(
                    onTap: () => setState(() => _warna = warna),
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: warna,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: dipilih ? Colors.blue : Colors.grey.shade300,
                          width: dipilih ? 3 : 1,
                        ),
                      ),
                      child: dipilih
                          ? const Icon(
                              Icons.check,
                              size: 18,
                              color: Colors.blue,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Prioritas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Rendah', label: Text('Rendah')),
                    ButtonSegment(value: 'Sedang', label: Text('Sedang')),
                    ButtonSegment(value: 'Tinggi', label: Text('Tinggi')),
                  ],
                  selected: {_prioritas},
                  onSelectionChanged: (pilihan) =>
                      setState(() => _prioritas = pilihan.first),
                ),
              ),
              const SizedBox(height: 30),
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
                  onPressed: _simpan,
                  child: const Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
