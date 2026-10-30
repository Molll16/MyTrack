import 'package:flutter/material.dart';

class Catatan {
  final String id;
  final String judulCatatan;
  final String isiCatatan;
  final String kategori;
  final String tanggal;
  final String prioritas;
  final Color warna;

  const Catatan({
    required this.id,
    required this.judulCatatan,
    required this.isiCatatan,
    required this.kategori,
    required this.tanggal,
    this.prioritas = 'Sedang',
    this.warna = const Color(0xFFFFF3CD),
  });
}
