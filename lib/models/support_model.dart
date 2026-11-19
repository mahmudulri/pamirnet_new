import 'dart:convert';

SupportModel supportModelFromJson(String str) =>
    SupportModel.fromJson(json.decode(str));

String supportModelToJson(SupportModel data) => json.encode(data.toJson());

class SupportModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  SupportModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory SupportModel.fromJson(Map<String, dynamic> json) => SupportModel(
    success: json["success"] == null ? null : json["success"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    payload: json["payload"] == null
        ? null
        : List<dynamic>.from(json["payload"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data?.toJson(),
    "payload": payload == null
        ? null
        : List<dynamic>.from(payload!.map((x) => x)),
  };
}

class Data {
  final List<Contact>? contacts;

  Data({this.contacts});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    contacts: json["contacts"] == null
        ? null
        : List<Contact>.from(json["contacts"].map((x) => Contact.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "contacts": contacts == null
        ? null
        : List<dynamic>.from(contacts!.map((x) => x.toJson())),
  };
}

class Contact {
  final int? id;
  final String? title;
  final String? description;
  final String? phone;
  final bool? isWhatsapp;
  final bool? isPhone;
  final String? status;
  final Links? links;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Contact({
    this.id,
    this.title,
    this.description,
    this.phone,
    this.isWhatsapp,
    this.isPhone,
    this.status,
    this.links,
    this.createdAt,
    this.updatedAt,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    phone: json["phone"] == null ? null : json["phone"],
    isWhatsapp: json["is_whatsapp"] == null ? null : json["is_whatsapp"],
    isPhone: json["is_phone"] == null ? null : json["is_phone"],
    status: json["status"] == null ? null : json["status"],
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "phone": phone,
    "is_whatsapp": isWhatsapp,
    "is_phone": isPhone,
    "status": status,
    "links": links?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Links {
  final String? website;
  final String? telegram;

  Links({this.website, this.telegram});

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    website: json["website"] == null ? null : json["website"],
    telegram: json["telegram"] == null ? null : json["telegram"],
  );

  Map<String, dynamic> toJson() => {"website": website, "telegram": telegram};
}
