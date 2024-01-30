import 'package:flutter/services.dart';

abstract class KtpLocalDataSource {
  Future<String> getProvinces();
  Future<String> getRegencies();
}

class KtpLocalDataSourceImpl implements KtpLocalDataSource {
  @override
  Future<String> getProvinces() async {
    return await rootBundle.loadString('provinces.json');
  }

  @override
  Future<String> getRegencies() async {
    return await rootBundle.loadString('regencies.json');
  }
}
