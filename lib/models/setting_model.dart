import 'dart:convert';

AppSettingModel appSettingModelFromJson(String str) =>
    AppSettingModel.fromJson(json.decode(str));

String appSettingModelToJson(AppSettingModel data) =>
    json.encode(data.toJson());

class AppSettingModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  AppSettingModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory AppSettingModel.fromJson(Map<String, dynamic> json) =>
      AppSettingModel(
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
  final Settings? settings;

  Data({this.settings});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    settings: json["settings"] == null
        ? null
        : Settings.fromJson(json["settings"]),
  );

  Map<String, dynamic> toJson() => {"settings": settings?.toJson()};
}

class Settings {
  final int? id;
  final bool? maintenanceMode;
  final bool? allowNewRegistrations;
  final bool? autoConfirm;
  final String? defaultCurrency;
  final String? exchangeRateUsdAfn;
  final String? supportPhone;
  final String? supportEmail;
  final String? supportWhatsapp;
  final String? alternativeContactPhone;
  final String? alternativeWhatsapp;
  final String? telegramUsername;
  final String? telegramUrl;
  final String? facebookPageUrl;
  final String? instagramHandle;
  final String? instagramUrl;
  final String? twitterUrl;
  final String? tiktokUrl;
  final String? youtubeUrl;
  final String? websiteUrl;
  final String? appName;
  final String? appNameDisplay;
  final String? appSloganDisplay;
  final String? logoUrl;
  final String? primaryColor;
  final String? secondaryColor;
  final String? primaryFontColor;
  final String? secondaryFontColor;
  final ExtraSettings? extraSettings;
  final String? afgCustomRechargeAdjustType;
  final String? afgCustomRechargeAdjustMode;
  final String? afgCustomRechargeAdjustValue;
  final String? afgCustomRechargeSellingPriceAdjustType;
  final String? afgCustomRechargeSellingPriceAdjustMode;
  final String? afgCustomRechargeSellingPriceAdjustValue;
  final String? setaraganAdminBuyingPricePercentage;
  final DateTime? updatedAt;

  Settings({
    this.id,
    this.maintenanceMode,
    this.allowNewRegistrations,
    this.autoConfirm,
    this.defaultCurrency,
    this.exchangeRateUsdAfn,
    this.supportPhone,
    this.supportEmail,
    this.supportWhatsapp,
    this.alternativeContactPhone,
    this.alternativeWhatsapp,
    this.telegramUsername,
    this.telegramUrl,
    this.facebookPageUrl,
    this.instagramHandle,
    this.instagramUrl,
    this.twitterUrl,
    this.tiktokUrl,
    this.youtubeUrl,
    this.websiteUrl,
    this.appName,
    this.appNameDisplay,
    this.appSloganDisplay,
    this.logoUrl,
    this.primaryColor,
    this.secondaryColor,
    this.primaryFontColor,
    this.secondaryFontColor,
    this.extraSettings,
    this.afgCustomRechargeAdjustType,
    this.afgCustomRechargeAdjustMode,
    this.afgCustomRechargeAdjustValue,
    this.afgCustomRechargeSellingPriceAdjustType,
    this.afgCustomRechargeSellingPriceAdjustMode,
    this.afgCustomRechargeSellingPriceAdjustValue,
    this.setaraganAdminBuyingPricePercentage,
    this.updatedAt,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    id: json["id"] == null ? null : json["id"],
    maintenanceMode: json["maintenance_mode"] == null
        ? null
        : json["maintenance_mode"],
    allowNewRegistrations: json["allow_new_registrations"] == null
        ? null
        : json["allow_new_registrations"],
    autoConfirm: json["auto_confirm"] == null ? null : json["auto_confirm"],
    defaultCurrency: json["default_currency"] == null
        ? null
        : json["default_currency"],
    exchangeRateUsdAfn: json["exchange_rate_usd_afn"] == null
        ? null
        : json["exchange_rate_usd_afn"],
    supportPhone: json["support_phone"] == null ? null : json["support_phone"],
    supportEmail: json["support_email"] == null ? null : json["support_email"],
    supportWhatsapp: json["support_whatsapp"] == null
        ? null
        : json["support_whatsapp"],
    alternativeContactPhone: json["alternative_contact_phone"] == null
        ? null
        : json["alternative_contact_phone"],
    alternativeWhatsapp: json["alternative_whatsapp"] == null
        ? null
        : json["alternative_whatsapp"],
    telegramUsername: json["telegram_username"] == null
        ? null
        : json["telegram_username"],
    telegramUrl: json["telegram_url"] == null ? null : json["telegram_url"],
    facebookPageUrl: json["facebook_page_url"] == null
        ? null
        : json["facebook_page_url"],
    instagramHandle: json["instagram_handle"] == null
        ? null
        : json["instagram_handle"],
    instagramUrl: json["instagram_url"] == null ? null : json["instagram_url"],
    twitterUrl: json["twitter_url"] == null ? null : json["twitter_url"],
    tiktokUrl: json["tiktok_url"] == null ? null : json["tiktok_url"],
    youtubeUrl: json["youtube_url"] == null ? null : json["youtube_url"],
    websiteUrl: json["website_url"] == null ? null : json["website_url"],
    appName: json["app_name"] == null ? null : json["app_name"],
    appNameDisplay: json["app_name_display"] == null
        ? null
        : json["app_name_display"],
    appSloganDisplay: json["app_slogan_display"] == null
        ? null
        : json["app_slogan_display"],
    logoUrl: json["logo_url"] == null ? null : json["logo_url"],
    primaryColor: json["primary_color"] == null ? null : json["primary_color"],
    secondaryColor: json["secondary_color"] == null
        ? null
        : json["secondary_color"],
    primaryFontColor: json["primary_font_color"] == null
        ? null
        : json["primary_font_color"],
    secondaryFontColor: json["secondary_font_color"] == null
        ? null
        : json["secondary_font_color"],
    extraSettings: json["extra_settings"] == null
        ? null
        : ExtraSettings.fromJson(json["extra_settings"]),
    afgCustomRechargeAdjustType: json["afg_custom_recharge_adjust_type"] == null
        ? null
        : json["afg_custom_recharge_adjust_type"],
    afgCustomRechargeAdjustMode: json["afg_custom_recharge_adjust_mode"] == null
        ? null
        : json["afg_custom_recharge_adjust_mode"],
    afgCustomRechargeAdjustValue:
        json["afg_custom_recharge_adjust_value"] == null
        ? null
        : json["afg_custom_recharge_adjust_value"],
    afgCustomRechargeSellingPriceAdjustType:
        json["afg_custom_recharge_selling_price_adjust_type"] == null
        ? null
        : json["afg_custom_recharge_selling_price_adjust_type"],
    afgCustomRechargeSellingPriceAdjustMode:
        json["afg_custom_recharge_selling_price_adjust_mode"] == null
        ? null
        : json["afg_custom_recharge_selling_price_adjust_mode"],
    afgCustomRechargeSellingPriceAdjustValue:
        json["afg_custom_recharge_selling_price_adjust_value"] == null
        ? null
        : json["afg_custom_recharge_selling_price_adjust_value"],
    setaraganAdminBuyingPricePercentage:
        json["setaragan_admin_buying_price_percentage"] == null
        ? null
        : json["setaragan_admin_buying_price_percentage"],
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "maintenance_mode": maintenanceMode,
    "allow_new_registrations": allowNewRegistrations,
    "auto_confirm": autoConfirm,
    "default_currency": defaultCurrency,
    "exchange_rate_usd_afn": exchangeRateUsdAfn,
    "support_phone": supportPhone,
    "support_email": supportEmail,
    "support_whatsapp": supportWhatsapp,
    "alternative_contact_phone": alternativeContactPhone,
    "alternative_whatsapp": alternativeWhatsapp,
    "telegram_username": telegramUsername,
    "telegram_url": telegramUrl,
    "facebook_page_url": facebookPageUrl,
    "instagram_handle": instagramHandle,
    "instagram_url": instagramUrl,
    "twitter_url": twitterUrl,
    "tiktok_url": tiktokUrl,
    "youtube_url": youtubeUrl,
    "website_url": websiteUrl,
    "app_name": appName,
    "app_name_display": appNameDisplay,
    "app_slogan_display": appSloganDisplay,
    "logo_url": logoUrl,
    "primary_color": primaryColor,
    "secondary_color": secondaryColor,
    "primary_font_color": primaryFontColor,
    "secondary_font_color": secondaryFontColor,
    "extra_settings": extraSettings?.toJson(),
    "afg_custom_recharge_adjust_type": afgCustomRechargeAdjustType,
    "afg_custom_recharge_adjust_mode": afgCustomRechargeAdjustMode,
    "afg_custom_recharge_adjust_value": afgCustomRechargeAdjustValue,
    "afg_custom_recharge_selling_price_adjust_type":
        afgCustomRechargeSellingPriceAdjustType,
    "afg_custom_recharge_selling_price_adjust_mode":
        afgCustomRechargeSellingPriceAdjustMode,
    "afg_custom_recharge_selling_price_adjust_value":
        afgCustomRechargeSellingPriceAdjustValue,
    "setaragan_admin_buying_price_percentage":
        setaraganAdminBuyingPricePercentage,
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class ExtraSettings {
  final int? maxTopupAmount;
  final int? minTopupAmount;
  final int? maxOrderPerDay;

  ExtraSettings({
    this.maxTopupAmount,
    this.minTopupAmount,
    this.maxOrderPerDay,
  });

  factory ExtraSettings.fromJson(Map<String, dynamic> json) => ExtraSettings(
    maxTopupAmount: json["max_topup_amount"] == null
        ? null
        : json["max_topup_amount"],
    minTopupAmount: json["min_topup_amount"] == null
        ? null
        : json["min_topup_amount"],
    maxOrderPerDay: json["max_order_per_day"] == null
        ? null
        : json["max_order_per_day"],
  );

  Map<String, dynamic> toJson() => {
    "max_topup_amount": maxTopupAmount,
    "min_topup_amount": minTopupAmount,
    "max_order_per_day": maxOrderPerDay,
  };
}
