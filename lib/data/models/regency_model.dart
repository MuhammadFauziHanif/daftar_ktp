// To parse this JSON data, do
//
//     final regencyModel = regencyModelFromJson(jsonString);

import 'dart:convert';

List<RegencyModel> regencyModelFromJson(String str) => List<RegencyModel>.from(
    json.decode(str).map((x) => RegencyModel.fromJson(x)));

String regencyModelToJson(List<RegencyModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegencyModel {
  String id;
  String provinceId;
  String name;
  String altName;
  double latitude;
  double longitude;

  RegencyModel({
    required this.id,
    required this.provinceId,
    required this.name,
    required this.altName,
    required this.latitude,
    required this.longitude,
  });

  factory RegencyModel.fromJson(Map<String, dynamic> json) => RegencyModel(
        id: json["id"],
        provinceId: json["province_id"],
        name: json["name"],
        altName: json["alt_name"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "province_id": provinceId,
        "name": name,
        "alt_name": altName,
        "latitude": latitude,
        "longitude": longitude,
      };
}
