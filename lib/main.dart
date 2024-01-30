import 'package:daftar_ktp/app/pages/add_user_page.dart';
import 'package:daftar_ktp/app/pages/update_user_page.dart';
import 'package:daftar_ktp/app/pages/view_user_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'app/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    Hive.initFlutter();
  } else {
    Hive.initFlutter();
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  }
  await Hive.openBox('users');

  runApp(MyApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      name: 'add',
      path: '/add',
      builder: (context, state) => AddUserPage(),
    ),
    GoRoute(
      name: 'view',
      path: '/view',
      builder: (context, state) => ViewUserPage(),
    ),
    GoRoute(
        name: 'update',
        path: '/update',
        builder: (context, state) {
          final user = state.extra;
          return UpdateUserPage(user: user);
        })
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(),
      child: MaterialApp.router(
        title: 'Flutter App',
        routerConfig: _router,
      ),
    );
  }
}

class User {
  final String name;
  final String birthPlace;
  final String regency;
  final String province;
  final String occupation;
  final String education;

  User({
    required this.name,
    required this.birthPlace,
    required this.regency,
    required this.province,
    required this.occupation,
    required this.education,
  });
}

class UserBloc extends Cubit<List<User>> {
  UserBloc() : super([]);

  void addUser(User user) {
    emit([...state, user]);
  }

  void deleteUser(int index) {
    state.removeAt(index);
    emit([...state]);
  }
}
