import 'package:meta/meta.dart';
import 'dart:convert';

NewServiceCatModel NewServiceCatModelFromJson(Map<String, dynamic> json) =>
    NewServiceCatModel.fromJson(json);

String NewServiceCatModelToJson(NewServiceCatModel data) =>
    json.encode(data.toJson());

class NewServiceCatModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;

  NewServiceCatModel({this.success, this.code, this.message, this.data});

  factory NewServiceCatModel.fromJson(Map<String, dynamic> json) =>
      NewServiceCatModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final List<Servicecategory>? servicecategories;

  Data({this.servicecategories});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    servicecategories: List<Servicecategory>.from(
      json["servicecategories"].map((x) => Servicecategory.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "servicecategories": List<dynamic>.from(
      servicecategories!.map((x) => x.toJson()),
    ),
  };
}

class Servicecategory {
  final int? id;
  final String? categoryName;
  final String? type;
  final dynamic categoryImageUrl;

  final List<Service>? services;

  Servicecategory({
    this.id,
    this.categoryName,
    this.type,
    this.categoryImageUrl,
    this.services,
  });

  factory Servicecategory.fromJson(
    Map<String, dynamic> json,
  ) => Servicecategory(
    id: json["id"] == null ? null : json["id"],
    categoryName: json["category_name"] == null ? null : json["category_name"],
    type: json["type"] == null ? null : json["type"],
    categoryImageUrl: json["category_image_url"] == null
        ? null
        : json["category_image_url"],
    services: json["services"] == null
        ? null
        : List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_name": categoryName,
    "type": type,
    "category_image_url": categoryImageUrl,
    "services": List<dynamic>.from(services!.map((x) => x.toJson())),
  };
}

class Service {
  final int? id;
  final String? serviceCategoryId;
  final String? companyId;
  final Company? company;

  Service({this.id, this.serviceCategoryId, this.companyId, this.company});

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"] == null ? null : json["id"],
    serviceCategoryId: json["service_category_id"] == null
        ? null
        : json["service_category_id"],
    companyId: json["company_id"] == null ? null : json["company_id"],
    company: json["company"] == null ? null : Company.fromJson(json["company"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_category_id": serviceCategoryId,
    "company_id": companyId,
    "company": company != null ? company!.toJson() : null,
  };
}

class Company {
  final int? id;
  final String? companyName;
  final String? companyLogo;
  final String? countryId;
  final String? telegramChatId;
  final Country? country;

  Company({
    this.id,
    this.companyName,
    this.companyLogo,
    this.countryId,
    this.telegramChatId,
    this.country,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"] == null ? null : json["id"],
    companyName: json["company_name"] == null ? null : json["company_name"],
    companyLogo: json["company_logo"] == null ? null : json["company_logo"],
    countryId: json["country_id"] == null ? null : json["country_id"],
    telegramChatId: json["telegram_chat_id"] == null
        ? null
        : json["telegram_chat_id"],
    country: json["country"] == null ? null : Country.fromJson(json["country"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_name": companyName,
    "company_logo": companyLogo,
    "country_id": countryId,
    "telegram_chat_id": telegramChatId,
    "country": country != null ? country!.toJson() : null,
  };
}

class Country {
  final int? id;
  final String? countryName;
  final String? countryFlagImageUrl;
  final String? languageId;
  final String? countryTelecomCode;
  final String? phoneNumberLength;
  final bool? enableOperatorLookup;

  Country({
    this.id,
    this.countryName,
    this.countryFlagImageUrl,
    this.languageId,
    this.countryTelecomCode,
    this.phoneNumberLength,
    this.enableOperatorLookup,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"] == null ? null : json["id"],
    countryName: json["country_name"] == null ? null : json["country_name"],
    countryFlagImageUrl: json["country_flag_image_url"] == null
        ? null
        : json["country_flag_image_url"],
    languageId: json["language_id"] == null ? null : json["language_id"],
    countryTelecomCode: json["country_telecom_code"] == null
        ? null
        : json["country_telecom_code"],
    phoneNumberLength: json["phone_number_length"] == null
        ? null
        : json["phone_number_length"],
    enableOperatorLookup: json["enable_operator_lookup"] == null
        ? null
        : json["enable_operator_lookup"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_name": countryName,
    "country_flag_image_url": countryFlagImageUrl,
    "language_id": languageId,
    "country_telecom_code": countryTelecomCode,
    "phone_number_length": phoneNumberLength,
    "enable_operator_lookup": enableOperatorLookup,
  };
}
