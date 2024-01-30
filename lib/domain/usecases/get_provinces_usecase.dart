import 'package:daftar_ktp/data/repositories/ktp_repository.dart';

class GetProvinceUseCase {
  final KtpRepository repository = KtpRepository();

  Future<List<Map<String, dynamic>>> call() async {
    var listProvinces = await repository.getProvinces();
    var listProvinceNames = listProvinces
        .map<Map<String, dynamic>>((province) => {
              'id': province.id,
              'name': province.name,
            })
        .toList();
    return listProvinceNames;
  }
}
