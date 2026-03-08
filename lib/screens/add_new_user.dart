import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pamirnet/controllers/add_sub_reseller_controller.dart';
import 'package:pamirnet/controllers/country_list_controller.dart';
import 'package:pamirnet/controllers/district_controller.dart';
import 'package:pamirnet/controllers/province_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/global_controller/page_controller.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:pamirnet/widgets/authtextfield.dart';
import 'package:pamirnet/widgets/button_one.dart';
import 'package:pamirnet/widgets/ktext.dart';

import '../controllers/commission_group_controller.dart';
import '../global_controller/font_controller.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({super.key});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    await addSubResellerController.uploadImage();

    if (addSubResellerController.imageFile != null) {
      setState(() {
        _selectedImage = addSubResellerController.imageFile;
      });
    }
  }

  final box = GetStorage();
  final Mypagecontroller mypagecontroller = Get.find();

  final addSubResellerController = Get.find<AddSubResellerController>();
  final countryListController = Get.find<CountryListController>();
  final provinceController = Get.find<ProvinceController>();
  final commissionlistController = Get.find<CommissionGroupController>();
  final districtController = Get.find<DistrictController>();
  LanguagesController languagesController = Get.put(LanguagesController());

  String selected_comissiongroup = "";

  String selected_country = "";

  String selected_province = "";

  String selected_district = "";

  @override
  void initState() {
    super.initState();
    _resetDatafield();
    commissionlistController.fetchGrouplist();
  }

  void _resetDatafield() {
    addSubResellerController.groupId.value = '';
    selected_comissiongroup = "";
    addSubResellerController.countryId.value = '';
    selected_country = "";
    addSubResellerController.provinceId.value = '';
    selected_province = "";
    addSubResellerController.districtID.value = '';
    selected_district = "";
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffFFFFFF),
              AppColors.primaryColor.withOpacity(0.20),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Transform.rotate(
                    angle: 0.785398,
                    child: Container(
                      height: 7,
                      width: 7,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Expanded(
                    child: Container(height: 1, color: Colors.grey.shade300),
                  ),
                  SizedBox(width: 8),
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        countryListController.fetchCountryData();
                      },
                      child: Text(
                        languagesController.tr("ADD_NEW_USER"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.022,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(height: 2, color: Colors.grey.shade300),
                  ),
                  Transform.rotate(
                    angle: 0.785398, // 45 degrees in radians (π/4 or 0.785398)
                    child: Container(
                      height: 7,
                      width: 7,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              Obx(
                () => Center(
                  child: GestureDetector(
                    onTap: () async {
                      await addSubResellerController.uploadImage();
                      _selectedImage = addSubResellerController.imageFile;
                    },
                    child: DottedBorder(
                      color: Colors.grey.shade300, // Dotted border color
                      strokeWidth: 2,
                      dashPattern: [6, 3],
                      borderType: BorderType.Circle,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          child:
                              addSubResellerController
                                      .selectedImagePath
                                      .value ==
                                  ""
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/upload_image.png",
                                      height: 30,
                                    ),
                                    Text(
                                      languagesController.tr("UPLOAD_PHOTO"),
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: screenHeight * 0.013,
                                      ),
                                    ),
                                  ],
                                )
                              : ClipOval(
                                  child: Image.file(
                                    addSubResellerController.imageFile!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12),

              Text(
                languagesController.tr("FULL_NAME"),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenHeight * 0.020,
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                ),
              ),
              SizedBox(height: 5),
              Authtextfield(
                hinttext: languagesController.tr("ADD_FIRST_AND_LAST_NAME"),
                controller: addSubResellerController.resellerNameController,
              ),
              SizedBox(height: 5),
              Text(
                languagesController.tr("CONTACT_NAME"),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenHeight * 0.020,
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                ),
              ),
              SizedBox(height: 5),
              Authtextfield(
                hinttext: languagesController.tr("CONTACT_NAME"),
                controller: addSubResellerController.contactNameController,
              ),
              SizedBox(height: 5),
              Text(
                languagesController.tr("PHONENUMBER"),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenHeight * 0.020,
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                ),
              ),
              SizedBox(height: 7),
              Authtextfield(
                hinttext: languagesController.tr("ENTER_PHONE_NUMBER"),
                controller: addSubResellerController.phoneController,
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    languagesController.tr("EMAIL"),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.020,
                      fontFamily: box.read("language").toString() == "Fa"
                          ? Get.find<FontController>().currentFont
                          : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "(${languagesController.tr("OPTIONAL")})",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.015,
                      fontFamily: box.read("language").toString() == "Fa"
                          ? Get.find<FontController>().currentFont
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Authtextfield(
                hinttext: languagesController.tr("ENTER_EMAIL_ADDRESS"),
                controller: addSubResellerController.emailController,
              ),
              SizedBox(height: 5),
              Text(
                languagesController.tr("COMMISSION_GROUP"),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenHeight * 0.020,
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Obx(() {
                  // Use dynamic if model type isn't imported
                  final List<dynamic> groups =
                      (commissionlistController.allgrouplist.value.data?.groups
                          as List?) ??
                      <dynamic>[];

                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    alignment: box.read("language").toString() != "Fa"
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    value: (addSubResellerController.groupId.value.isEmpty)
                        ? null
                        : addSubResellerController.groupId.value,
                    items: groups.map<DropdownMenuItem<String>>((g) {
                      final String idStr = ((g?.id) ?? '').toString();
                      final String name = ((g?.groupName) ?? '').toString();
                      return DropdownMenuItem<String>(
                        value: idStr,
                        child: Text(
                          name,
                          style: TextStyle(
                            fontFamily: box.read("language").toString() == "Fa"
                                ? Get.find<FontController>().currentFont
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      // find picked
                      dynamic picked;
                      for (final g in groups) {
                        if (((g?.id) ?? '').toString() == value) {
                          picked = g;
                          break;
                        }
                      }
                      picked ??= groups.isNotEmpty ? groups.first : null;

                      // update both ID and visible text
                      addSubResellerController.groupId.value = value;
                      selected_comissiongroup = ((picked?.groupName) ?? '')
                          .toString();
                      // if this is inside StatefulWidget, refresh UI
                      if (Get.isRegistered<
                        StateMixin
                      >()) {} // optional; ignore if not needed
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    icon: const Icon(
                      FontAwesomeIcons.chevronDown,
                      color: Colors.grey,
                      size: 20,
                    ),
                    hint: Text(
                      selected_comissiongroup.isEmpty
                          ? ''
                          : selected_comissiongroup,
                      style: TextStyle(
                        fontSize: screenHeight * 0.020,
                        color: Colors.grey.shade600,
                        fontFamily: box.read("language").toString() == "Fa"
                            ? Get.find<FontController>().currentFont
                            : null,
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: 5),
              Text(
                languagesController.tr("COUNTRY_OF_RESIDENCE"),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenHeight * 0.020,
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Obx(() {
                  // Use dynamic if you don’t have a strong model imported here
                  final List<dynamic> countries =
                      (countryListController
                              .allcountryListData
                              .value
                              .data
                              ?.countries
                          as List?) ??
                      <dynamic>[];

                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    alignment: box.read("language").toString() != "Fa"
                        ? Alignment.centerLeft
                        : Alignment.centerRight,

                    // selected value = countryId (String)
                    value: addSubResellerController.countryId.value.isEmpty
                        ? null
                        : addSubResellerController.countryId.value,

                    items: countries.map<DropdownMenuItem<String>>((c) {
                      final String idStr = ((c?.id) ?? '').toString();
                      final String name = ((c?.countryName) ?? '').toString();
                      final String flagUrl = ((c?.countryFlagImageUrl) ?? '')
                          .toString();

                      return DropdownMenuItem<String>(
                        value: idStr,
                        child: Row(
                          children: [
                            // Flag
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                flagUrl,
                                height: 24,
                                width: 36,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const SizedBox(height: 24, width: 36),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Name
                            Text(
                              name,
                              style: TextStyle(
                                fontFamily:
                                    box.read("language").toString() == "Fa"
                                    ? Get.find<FontController>().currentFont
                                    : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      if (value == null) return;

                      // find picked country
                      dynamic picked;
                      for (final c in countries) {
                        if (((c?.id) ?? '').toString() == value) {
                          picked = c;
                          break;
                        }
                      }
                      picked ??= countries.isNotEmpty ? countries.first : null;

                      // update controller + label
                      addSubResellerController.countryId.value = value;
                      selected_country = ((picked?.countryName) ?? '')
                          .toString();
                    },

                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),

                    icon: const Icon(
                      FontAwesomeIcons.chevronDown,
                      color: Colors.grey,
                      size: 20,
                    ),

                    // Show current selection text like before
                    hint: Text(
                      selected_country.isEmpty ? '' : selected_country,
                      style: TextStyle(
                        fontSize: screenHeight * 0.020,
                        color: Colors.grey.shade600,
                        fontFamily: box.read("language").toString() == "Fa"
                            ? Get.find<FontController>().currentFont
                            : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
              ),

              SizedBox(height: 5),
              Text(
                languagesController.tr("PROVINCE"),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenHeight * 0.020,
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Obx(() {
                  // Use dynamic if the concrete model type isn't imported
                  final List<dynamic> provinces =
                      (provinceController.allprovincelist.value.data?.provinces
                          as List?) ??
                      <dynamic>[];

                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    alignment: box.read("language").toString() != "Fa"
                        ? Alignment.centerLeft
                        : Alignment.centerRight,

                    // Selected value is provinceId (String)
                    value: addSubResellerController.provinceId.value.isEmpty
                        ? null
                        : addSubResellerController.provinceId.value,

                    items: provinces.map<DropdownMenuItem<String>>((p) {
                      final String idStr = ((p?.id) ?? '').toString();
                      final String nameStr = ((p?.provinceName) ?? '')
                          .toString();

                      return DropdownMenuItem<String>(
                        value: idStr,
                        child: Text(
                          nameStr,
                          style: TextStyle(
                            fontFamily: box.read("language").toString() == "Fa"
                                ? Get.find<FontController>().currentFont
                                : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      if (value == null) return;

                      // find picked province
                      dynamic picked;
                      for (final p in provinces) {
                        if (((p?.id) ?? '').toString() == value) {
                          picked = p;
                          break;
                        }
                      }
                      picked ??= provinces.isNotEmpty ? provinces.first : null;

                      // update controller + label
                      addSubResellerController.provinceId.value = value;
                      selected_province = ((picked?.provinceName) ?? '')
                          .toString();
                    },

                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),

                    icon: const Icon(
                      FontAwesomeIcons.chevronDown,
                      color: Colors.grey,
                      size: 20,
                    ),

                    // Show current selection like before
                    hint: Text(
                      selected_province.isEmpty ? '' : selected_province,
                      style: TextStyle(
                        fontSize: screenHeight * 0.020,
                        color: Colors.grey.shade600,
                        fontFamily: box.read("language").toString() == "Fa"
                            ? Get.find<FontController>().currentFont
                            : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
              ),

              SizedBox(height: 5),
              Text(
                languagesController.tr("DISTRICT"),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenHeight * 0.020,
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Obx(() {
                  // dynamic list to avoid model import; strong-type later if desired
                  final List<dynamic> districts =
                      (districtController.alldistrictList.value.data?.districts
                          as List?) ??
                      <dynamic>[];

                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    alignment: box.read("language").toString() != "Fa"
                        ? Alignment.centerLeft
                        : Alignment.centerRight,

                    // selected value is districtID (String)
                    value: addSubResellerController.districtID.value.isEmpty
                        ? null
                        : addSubResellerController.districtID.value,

                    items: districts.map<DropdownMenuItem<String>>((d) {
                      final String idStr = ((d?.id) ?? '').toString();
                      final String nameStr = ((d?.districtName) ?? '')
                          .toString();

                      return DropdownMenuItem<String>(
                        value: idStr,
                        child: Text(
                          nameStr,
                          style: TextStyle(
                            fontFamily: box.read("language").toString() == "Fa"
                                ? Get.find<FontController>().currentFont
                                : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      if (value == null) return;

                      // find picked district
                      dynamic picked;
                      for (final d in districts) {
                        if (((d?.id) ?? '').toString() == value) {
                          picked = d;
                          break;
                        }
                      }
                      picked ??= districts.isNotEmpty ? districts.first : null;

                      // update controller + label
                      addSubResellerController.districtID.value = value;
                      selected_district = ((picked?.districtName) ?? '')
                          .toString();
                    },

                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),

                    icon: const Icon(
                      FontAwesomeIcons.chevronDown,
                      color: Colors.grey,
                      size: 20,
                    ),

                    // show current selection like before
                    hint: Text(
                      selected_district.isEmpty ? '' : selected_district,
                      style: TextStyle(
                        fontSize: screenHeight * 0.020,
                        color: Colors.grey.shade600,
                        fontFamily: box.read("language").toString() == "Fa"
                            ? Get.find<FontController>().currentFont
                            : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
              ),

              SizedBox(height: 12),
              Text(
                languagesController.tr("DESIRED_CURRENCY"),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenHeight * 0.020,
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                ),
              ),
              SizedBox(height: 7),
              Container(
                height: 45,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          box.read("currencyName") +
                              " (${box.read("currency_code")})",
                          style: TextStyle(
                            fontSize: screenHeight * 0.020,
                            color: Colors.grey.shade600,
                            fontFamily: box.read("language").toString() == "Fa"
                                ? Get.find<FontController>().currentFont
                                : null,
                          ),
                        ),
                      ),
                      // Icon(
                      //   FontAwesomeIcons.chevronDown,
                      //   size: screenHeight * 0.018,
                      //   color: Colors.grey,
                      // ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // -------------------- Identity Attachment (Optional) --------------------
              Row(
                children: [
                  KText(
                    text: languagesController.tr("IDENTITY_ATTACHMENT"),
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "(${languagesController.tr("OPTIONAL")})",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.015,
                      fontFamily: box.read("language").toString() == "Fa"
                          ? Get.find<FontController>().currentFont
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Obx(() {
                final hasImage = addSubResellerController
                    .selectedIdentityPath
                    .value
                    .isNotEmpty;
                return GestureDetector(
                  onTap: () async {
                    await addSubResellerController.uploadIdentityAttachment();
                    setState(() {});
                  },
                  child: DottedBorder(
                    color: Colors.grey.shade300,
                    strokeWidth: 2,
                    dashPattern: const [6, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: hasImage
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(
                                      addSubResellerController
                                          .selectedIdentityPath
                                          .value,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      addSubResellerController
                                              .selectedIdentityPath
                                              .value =
                                          '';
                                      setState(() {});
                                    },
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.black54,
                                      child: Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/upload_image.png",
                                    height: 28,
                                  ),
                                  const SizedBox(height: 6),
                                  KText(
                                    text: languagesController.tr(
                                      "TAP_TO_UPLOAD_IDENTITY_IMAGE",
                                    ),
                                    color: Colors.grey.shade600,
                                    fontSize: screenHeight * 0.015,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                );
              }),
              SizedBox(height: 12),

              // -------------------- Extra Optional Proof (Optional) --------------------
              Row(
                children: [
                  KText(
                    text: languagesController.tr("EXTRA_PROOF"),
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "(${languagesController.tr("OPTIONAL")})",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.015,
                      fontFamily: box.read("language").toString() == "Fa"
                          ? Get.find<FontController>().currentFont
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Obx(() {
                final hasImage = addSubResellerController
                    .selectedExtraProofPath
                    .value
                    .isNotEmpty;
                return GestureDetector(
                  onTap: () async {
                    await addSubResellerController.uploadExtraOptionalProof();
                    setState(() {});
                  },
                  child: DottedBorder(
                    color: Colors.grey.shade300,
                    strokeWidth: 2,
                    dashPattern: const [6, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: hasImage
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(
                                      addSubResellerController
                                          .selectedExtraProofPath
                                          .value,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      addSubResellerController
                                              .selectedExtraProofPath
                                              .value =
                                          '';
                                      setState(() {});
                                    },
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.black54,
                                      child: Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/upload_image.png",
                                    height: 28,
                                  ),
                                  const SizedBox(height: 6),
                                  KText(
                                    text: languagesController.tr(
                                      "TAP_TO_UPLOAD_EXTRA_PROOF",
                                    ),
                                    color: Colors.grey.shade600,
                                    fontSize: screenHeight * 0.015,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                );
              }),

              SizedBox(height: 10),

              Obx(
                () => DefaultButton(
                  buttonName: addSubResellerController.isLoading.value == false
                      ? languagesController.tr("ADD_NOW")
                      : languagesController.tr("PLEASE_WAIT"),
                  mycolor: Colors.green,
                  onpressed: () {
                    if (addSubResellerController
                            .resellerNameController
                            .text
                            .isEmpty ||
                        addSubResellerController
                            .contactNameController
                            .text
                            .isEmpty ||
                        addSubResellerController.phoneController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: languagesController.tr("FILL_DATA_CORRECTLY"),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else {
                      addSubResellerController.addNow();
                      print("ok");
                    }
                  },
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
