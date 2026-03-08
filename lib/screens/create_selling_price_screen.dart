import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pamirnet/controllers/only_service_controller.dart';
import 'package:pamirnet/models/new_service_model.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:pamirnet/widgets/authtextfield.dart';
import 'package:pamirnet/widgets/button_one.dart';

import '../controllers/add_selling_price_controller.dart';
import '../controllers/categories_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';

class CreateSellingPriceScreen extends StatefulWidget {
  const CreateSellingPriceScreen({super.key});

  @override
  State<CreateSellingPriceScreen> createState() =>
      _CreateSellingPriceScreenState();
}

class _CreateSellingPriceScreenState extends State<CreateSellingPriceScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());

  final categorisListController = Get.find<CategorisListController>();
  List commissiontype = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    commissiontype = [
      {"name": languagesController.tr("PERCENTAGE"), "value": "percentage"},
      {"name": languagesController.tr("FIXED"), "value": "fixed"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    LanguagesController languagesController = Get.put(LanguagesController());
    final Mypagecontroller mypagecontroller = Get.find();

    AddSellingPriceController addSellingPriceController = Get.put(
      AddSellingPriceController(),
    );

    final OnlyServiceController serviceController = Get.put(
      OnlyServiceController(),
    );

    final box = GetStorage();

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: ListView(
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
                  GestureDetector(
                    onTap: () {
                      print(
                        addSellingPriceController.serviceName.value.toString(),
                      );
                    },
                    child: Text(
                      languagesController.tr("CREATE_SELLING_PRICE"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * 0.022,
                        fontFamily: box.read("language").toString() == "Fa"
                            ? Get.find<FontController>().currentFont
                            : null,
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
              Row(
                children: [
                  Text(
                    languagesController.tr("AMOUNT"),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.020,
                      fontFamily: box.read("language").toString() == "Fa"
                          ? Get.find<FontController>().currentFont
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Authtextfield(
                hinttext: "Enter amount",
                controller: addSellingPriceController.amountController,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    languagesController.tr("COMMISSION_TYPE"),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.020,
                      fontFamily: box.read("language").toString() == "Fa"
                          ? Get.find<FontController>().currentFont
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              // Replace your GestureDetector+Dialog with this block:
              Obx(() {
                // Safely cast your list of maps
                final List<Map<String, dynamic>> types =
                    (commissiontype as List).cast<Map<String, dynamic>>();

                return Container(
                  height: 50,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    alignment: box.read("language").toString() != "Fa"
                        ? Alignment.centerLeft
                        : Alignment.centerRight,

                    // selected value = underlying "value"
                    value:
                        addSellingPriceController.commissiontype.value.isEmpty
                        ? null
                        : addSellingPriceController.commissiontype.value,

                    items: types.map<DropdownMenuItem<String>>((t) {
                      final String v = (t["value"] ?? "").toString();
                      final String n = (t["name"] ?? "").toString();
                      return DropdownMenuItem<String>(value: v, child: Text(n));
                    }).toList(),

                    onChanged: (value) {
                      if (value == null) return;

                      // set selected "value"
                      addSellingPriceController.commissiontype.value = value;

                      // find and set display name
                      String pickedName = '';
                      for (final t in types) {
                        if ((t["value"] ?? "").toString() == value) {
                          pickedName = (t["name"] ?? "").toString();
                          break;
                        }
                      }
                      addSellingPriceController.commitype.value = pickedName;
                    },

                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),

                    // keep your icon style
                    icon: Icon(
                      FontAwesomeIcons.chevronDown,
                      size: 17,
                      color: Colors.grey,
                    ),

                    // show the selected name like before
                    hint: Text(
                      addSellingPriceController.commitype.value.isEmpty
                          ? ''
                          : addSellingPriceController.commitype.value,
                      style: TextStyle(
                        fontSize: screenHeight * 0.020,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                );
              }),

              SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    languagesController.tr("SERVICE"),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.020,
                      fontFamily: box.read("language").toString() == "Fa"
                          ? Get.find<FontController>().currentFont
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Container(
                    height: 120,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Obx(
                        () => addSellingPriceController.catName.value != ''
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    addSellingPriceController.logolink
                                        .toString(),
                                    height: 50,
                                  ),
                                  Text(
                                    addSellingPriceController.serviceName
                                        .toString(),
                                  ),
                                  Text(
                                    addSellingPriceController.catName
                                        .toString(),
                                  ),
                                ],
                              )
                            : SizedBox(child: Text("")),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            insetPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            child: ServiceBox(),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Center(
                        child: Icon(FontAwesomeIcons.chevronDown, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Obx(
                () => DefaultButton(
                  buttonName: addSellingPriceController.isLoading.value == false
                      ? languagesController.tr("CREATE_NOW")
                      : languagesController.tr("PLEASE_WAIT"),
                  mycolor: Colors.green,
                  onpressed: () {
                    if (addSellingPriceController
                            .amountController
                            .text
                            .isNotEmpty &&
                        addSellingPriceController.commissiontype.value != "" &&
                        addSellingPriceController
                            .serviceidcontroller
                            .text
                            .isNotEmpty) {
                      addSellingPriceController.createnow();
                    } else {
                      Fluttertoast.showToast(
                        msg: "Fill data",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceBox extends StatelessWidget {
  ServiceBox({super.key});

  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );

  final categorisListController = Get.find<CategorisListController>();
  AddSellingPriceController addSellingPriceController = Get.put(
    AddSellingPriceController(),
  );
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Container(
        height: 500,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => serviceController.isLoading.value == false
                ? GridView.builder(
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 4.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: serviceController
                        .allservices
                        .value
                        .data!
                        .services
                        .length,
                    itemBuilder: (context, index) {
                      final data = serviceController
                          .allservices
                          .value
                          .data!
                          .services[index];
                      return Padding(
                        padding: EdgeInsets.all(3.0),
                        child: GestureDetector(
                          onTap: () {
                            addSellingPriceController.serviceidcontroller.text =
                                data.id.toString();

                            addSellingPriceController.catName.value =
                                categorisListController
                                    .allcategorieslist
                                    .value
                                    .data!
                                    .servicecategories!
                                    .firstWhere(
                                      (cat) =>
                                          cat.id.toString() ==
                                          data.serviceCategoryId.toString(),
                                      orElse: () =>
                                          Servicecategory(categoryName: ''),
                                    )
                                    .categoryName
                                    .toString();

                            addSellingPriceController.logolink.value = data
                                .company!
                                .companyLogo
                                .toString();

                            addSellingPriceController.serviceName.value = data
                                .company!
                                .companyName
                                .toString();

                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          data.company!.companyLogo.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Column(
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        data.company!.companyName.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily:
                                              box.read("language").toString() ==
                                                  "Fa"
                                              ? Get.find<FontController>()
                                                    .currentFont
                                              : null,
                                        ),
                                      ),
                                      // Text(data.serviceCategoryId.toString()),
                                      Text(
                                        categorisListController
                                            .allcategorieslist
                                            .value
                                            .data!
                                            .servicecategories!
                                            .firstWhere(
                                              (cat) =>
                                                  cat.id.toString() ==
                                                  data.serviceCategoryId
                                                      .toString(),
                                              orElse: () => Servicecategory(
                                                categoryName: '',
                                              ),
                                            )
                                            .categoryName
                                            .toString(),
                                        style: TextStyle(
                                          fontFamily:
                                              box.read("language").toString() ==
                                                  "Fa"
                                              ? Get.find<FontController>()
                                                    .currentFont
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
