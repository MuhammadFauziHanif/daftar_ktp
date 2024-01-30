import 'package:daftar_ktp/domain/usecases/get_provinces_usecase.dart';
import 'package:daftar_ktp/domain/usecases/get_regencies_usecase.dart';
import 'package:daftar_ktp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

final List<String> _regencies = ['Regency A', 'Regency B', 'Regency C'];
final List<String> _provinces = ['Province X', 'Province Y', 'Province Z'];
final List<String> _occupations = ['Swasta', 'PNS', 'Wirausaha'];
final List<String> _educations = ['S1', 'S2', 'S3'];

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late List<String> _regencies;
  late List<String> _provinces;
  String? _selectedRegency;
  String? _selectedProvince;
  String? _selectedProvinceId;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  String _selectedOccupation = _occupations.first;
  String _selectedEducation = _educations.first;

  void _saveUser() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = {
      'name': _nameController.text,
      'birthPlace': _birthPlaceController.text,
      'regency': _selectedRegency,
      'province': _selectedProvince,
      'occupation': _selectedOccupation,
      'education': _selectedEducation,
    };

    final userBox = Hive.box('users');
    userBox.add(user);
    context.go('/view');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pengguna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _birthPlaceController,
                decoration: InputDecoration(labelText: 'Tempat Tanggal Lahir'),
                validator: (value) => value!.isEmpty
                    ? 'Tempat tanggal lahir tidak boleh kosong'
                    : null,
              ),
              FutureBuilder(
                future: GetProvinceUseCase().call(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    final regencies = snapshot.data!
                        .where((regency) =>
                            regency['provinceId'] == _selectedProvinceId)
                        .map<String>((regency) => regency['name'])
                        .toList();
                    return DropdownButtonFormField<String>(
                      validator: (value) =>
                          value == null ? 'Provinsi tidak boleh kosong' : null,
                      value: _selectedProvince,
                      onChanged: (value) {
                        setState(() {
                          _selectedProvince = value!;
                          _selectedProvinceId = snapshot.data!.firstWhere(
                              (province) =>
                                  province['name'] == _selectedProvince)['id'];
                        });
                      },
                      items: snapshot.data!
                          .map<DropdownMenuItem<String>>((province) {
                        return DropdownMenuItem<String>(
                          value: province['name'],
                          child: Text(province['name']),
                        );
                      }).toList(),
                      hint: Text('Pilih Provinsi'),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return LinearProgressIndicator();
                  }
                },
              ),
              FutureBuilder(
                future: GetRegeciesUseCase().call(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    final regencies = snapshot.data!
                        .where((regency) =>
                            regency['provinceId'] == _selectedProvinceId)
                        .map<String>((regency) => regency['name'])
                        .toList();
                    return DropdownButtonFormField<String>(
                      validator: (value) =>
                          value == null ? 'Kabupaten tidak boleh kosong' : null,
                      value: _selectedRegency,
                      onChanged: (value) {
                        setState(() {
                          _selectedRegency = value!;
                        });
                      },
                      items: regencies.map<DropdownMenuItem<String>>((regency) {
                        return DropdownMenuItem<String>(
                          value: regency,
                          child: Text(regency),
                        );
                      }).toList(),
                      hint: Text('Pilih Kabupaten'),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return LinearProgressIndicator();
                  }
                },
              ),
              DropdownButtonFormField<String>(
                validator: (value) =>
                    value == null ? 'Pekerjaan tidak boleh kosong' : null,
                value: _selectedOccupation,
                onChanged: (value) {
                  setState(() {
                    _selectedOccupation = value!;
                  });
                },
                items: _occupations.map((occupation) {
                  return DropdownMenuItem<String>(
                    value: occupation,
                    child: Text(occupation),
                  );
                }).toList(),
                hint: Text('Pilih Pekerjaan'),
              ),
              DropdownButtonFormField<String>(
                validator: (value) =>
                    value == null ? 'Pendidikan tidak boleh kosong' : null,
                value: _selectedEducation,
                onChanged: (value) {
                  setState(() {
                    _selectedEducation = value!;
                  });
                },
                items: _educations.map((education) {
                  return DropdownMenuItem<String>(
                    value: education,
                    child: Text(education),
                  );
                }).toList(),
                hint: Text('Pilih Pendidikan'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _saveUser();
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
