import 'package:daftar_ktp/data/repositories/ktp_repository.dart';

class GetRegeciesUseCase {
  final KtpRepository repository = KtpRepository();

  Future<List<Map<String, dynamic>>> call() async {
    var listRegencies = await repository.getRegencies();
    var listRegencyNames = listRegencies
        .map<Map<String, dynamic>>((regency) => {
              'provinceId': regency.provinceId,
              'name': regency.name,
            })
        .toList();
    return listRegencyNames;
  }
}
