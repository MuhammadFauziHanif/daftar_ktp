import 'package:daftar_ktp/data/datasources/ktp_local_datasource.dart';
import 'package:daftar_ktp/data/models/province_model.dart';
import 'package:daftar_ktp/data/models/regency_model.dart';

class KtpRepository {
  final KtpLocalDataSource localDataSource = KtpLocalDataSourceImpl();

  Future<List<ProvinceModel>> getProvinces() async {
    var stringProvinces = await localDataSource.getProvinces();
    var listProvinces = provinceModelFromJson(stringProvinces);
    return listProvinces;
  }

  Future<List<RegencyModel>> getRegencies() async {
    var stringRegencies = await localDataSource.getRegencies();
    var listRegencies = regencyModelFromJson(stringRegencies);
    return listRegencies;
  }
}
