import 'package:daftar_ktp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('/add');
              },
              child: Text('Tambah Pengguna'),
            ),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('/view');
              },
              child: Text('Lihat Pengguna'),
            ),
          ],
        ),
      ),
    );
  }
}
