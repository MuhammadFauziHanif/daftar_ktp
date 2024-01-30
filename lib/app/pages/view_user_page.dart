import 'package:daftar_ktp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ViewUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final List<User> users = context.watch<UserBloc>().state;

    // retrieve data from hive
    final userBox = Hive.box('users');
    final List users = userBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Lihat Pengguna'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('users').listenable(),
        builder: (context, Box box, _) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final user = box.getAt(index);
              Map<String, dynamic> userMap =
                  Map<String, dynamic>.from(user as Map);
              return ListTile(
                title: Text(
                  userMap['name'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userMap['occupation']),
                    Text(userMap['education']),
                    Text(userMap['regency'] + ', ' + userMap['province'])
                  ],
                ),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editUser(context, index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteDialog(context, index);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Pengguna'),
          content: Text('Apakah Anda yakin ingin menghapus pengguna ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                final userBox = Hive.box('users');
                userBox.deleteAt(index);
                Navigator.of(context).pop();
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _editUser(BuildContext context, int index) {
    final usersBox = Hive.box('users');
    final user = usersBox.getAt(index);
    Map<String, dynamic> userMap = Map<String, dynamic>.from(user as Map);
    GoRouter.of(context).go('/update/', extra: {
      'name': userMap['name'],
      'birthPlace': userMap['birthPlace'],
      'regency': userMap['regency'],
      'province': userMap['province'],
      'proviceId': userMap['provinceId'],
      'occupation': userMap['occupation'],
      'education': userMap['education'],
      'index': index.toString(),
    });
    usersBox.deleteAt(index);
  }
}
