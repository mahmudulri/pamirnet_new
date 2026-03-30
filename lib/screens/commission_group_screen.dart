import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pamirnet/widgets/button_one.dart';

import '../controllers/add_commsion_group_controller.dart';
import '../controllers/commission_group_controller.dart';
import '../controllers/delete_comissiongroup_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../utils/colors.dart';
import '../widgets/authtextfield.dart';

class CommissionGroupScreen extends StatefulWidget {
  CommissionGroupScreen({super.key});

  @override
  State<CommissionGroupScreen> createState() => _CommissionGroupScreenState();
}

class _CommissionGroupScreenState extends State<CommissionGroupScreen> {
  final box = GetStorage();

  LanguagesController languagesController = Get.put(LanguagesController());

  final commissionlistController = Get.find<CommissionGroupController>();

  AddCommsionGroupController addCommsionGroupController = Get.put(
    AddCommsionGroupController(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commissionlistController.fetchGrouplist();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
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
                  Text(
                    languagesController.tr("COMMISSION_GROUP"),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * 0.022,
                      fontFamily: box.read("language").toString() == "Fa"
                          ? Get.find<FontController>().currentFont
                          : null,
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
              SizedBox(height: 10),
              Container(
                height: 50,
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: languagesController.tr("SEARCH"),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: screenHeight * 0.020,
                                fontFamily:
                                    box.read("language").toString() == "Fa"
                                    ? Get.find<FontController>().currentFont
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                content: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: CreateGroupBox(),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              languagesController.tr("CREATE_NEW"),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily:
                                    box.read("language").toString() == "Fa"
                                    ? Get.find<FontController>().currentFont
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Obx(
                  () => commissionlistController.isLoading.value == false
                      ? ListView.separated(
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 5);
                          },
                          itemCount: commissionlistController
                              .allgrouplist
                              .value
                              .data!
                              .groups!
                              .length,
                          itemBuilder: (context, index) {
                            final data = commissionlistController
                                .allgrouplist
                                .value
                                .data!
                                .groups![index];
                            return Container(
                              height: 100,
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languagesController.tr(
                                                  "GROUP_NAME",
                                                ),
                                                style: TextStyle(
                                                  fontFamily:
                                                      box
                                                              .read("language")
                                                              .toString() ==
                                                          "Fa"
                                                      ? Get.find<
                                                              FontController
                                                            >()
                                                            .currentFont
                                                      : null,
                                                ),
                                              ),
                                              Text(data.groupName.toString()),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languagesController.tr(
                                                  "AMOUNT",
                                                ),
                                                style: TextStyle(
                                                  fontFamily:
                                                      box
                                                              .read("language")
                                                              .toString() ==
                                                          "Fa"
                                                      ? Get.find<
                                                              FontController
                                                            >()
                                                            .currentFont
                                                      : null,
                                                ),
                                              ),
                                              Text(
                                                data.amount.toString(),
                                                style: TextStyle(
                                                  fontFamily:
                                                      box
                                                              .read("language")
                                                              .toString() ==
                                                          "Fa"
                                                      ? Get.find<
                                                              FontController
                                                            >()
                                                            .currentFont
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languagesController.tr(
                                                  "COMMISSION_TYPE",
                                                ),
                                                style: TextStyle(
                                                  fontFamily:
                                                      box
                                                              .read("language")
                                                              .toString() ==
                                                          "Fa"
                                                      ? Get.find<
                                                              FontController
                                                            >()
                                                            .currentFont
                                                      : null,
                                                ),
                                              ),
                                              Text(
                                                data.commissionType
                                                            .toString() ==
                                                        "percentage"
                                                    ? languagesController.tr(
                                                        "PERCENTAGE",
                                                      )
                                                    : "",
                                                style: TextStyle(
                                                  fontFamily:
                                                      box
                                                              .read("language")
                                                              .toString() ==
                                                          "Fa"
                                                      ? Get.find<
                                                              FontController
                                                            >()
                                                            .currentFont
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            addCommsionGroupController
                                                .amountController
                                                .text = data.amount
                                                .toString();
                                            addCommsionGroupController
                                                .nameController
                                                .text = data.groupName
                                                .toString();
                                            addCommsionGroupController
                                                .commissiontype
                                                .value = data.commissionType
                                                .toString();
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  contentPadding:
                                                      EdgeInsets.all(0.0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  backgroundColor: Colors.white,
                                                  content: UpdateGroupBox(
                                                    groupID: data.id.toString(),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 15,

                                            child: Icon(Icons.edit, size: 18),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: DeleteDialog(
                                                    groupID: data.id.toString(),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateGroupBox extends StatefulWidget {
  CreateGroupBox({super.key});

  @override
  State<CreateGroupBox> createState() => _CreateGroupBoxState();
}

class _CreateGroupBoxState extends State<CreateGroupBox> {
  final box = GetStorage();

  final AddCommsionGroupController addCommsionGroupController = Get.put(
    AddCommsionGroupController(),
  );

  List commissiontype = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    commissiontype = [
      {"name": languagesController.tr("PERCENTAGE"), "value": "percentage"},
    ];
  }

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 450,
      width: screenWidth,
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                Text(
                  languagesController.tr("COMMISSION_GROUP"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenHeight * 0.022,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
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
                  languagesController.tr("GROUP_NAME"),
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
              hinttext: languagesController.tr("ENTER_GROUP_NAME"),
              controller: addCommsionGroupController.nameController,
            ),
            SizedBox(height: 5),
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
            Obx(() {
              final List<Map<String, dynamic>> types = (commissiontype as List)
                  .cast<Map<String, dynamic>>();

              return Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  alignment: box.read("language").toString() != "Fa"
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  value: addCommsionGroupController.commissiontype.value.isEmpty
                      ? null
                      : addCommsionGroupController.commissiontype.value,
                  items: types.map<DropdownMenuItem<String>>((t) {
                    final String v = (t["value"] ?? "").toString();
                    final String n = (t["name"] ?? "").toString();
                    return DropdownMenuItem<String>(value: v, child: Text(n));
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    addCommsionGroupController.commissiontype.value = value;

                    String pickedName = '';
                    for (final t in types) {
                      if ((t["value"] ?? "").toString() == value) {
                        pickedName = (t["name"] ?? "").toString();
                        break;
                      }
                    }
                    addCommsionGroupController.commitype.value = pickedName;
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  icon: Icon(
                    FontAwesomeIcons.chevronDown,
                    size: screenHeight * 0.018,
                    color: Colors.grey,
                  ),
                  hint: Text(
                    addCommsionGroupController.commitype.value.isEmpty
                        ? ''
                        : addCommsionGroupController.commitype.value,
                    style: TextStyle(
                      fontSize: screenHeight * 0.020,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: 5),
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
              hinttext: languagesController.tr("ENTER_AMOUNT_OR_VALUE"),
              controller: addCommsionGroupController.amountController,
            ),
            SizedBox(height: 15),
            Container(
              height: 50,
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        addCommsionGroupController.amountController.clear();
                        addCommsionGroupController.nameController.clear();
                        addCommsionGroupController.commissiontype.value = "";
                        addCommsionGroupController.commitype.value = "";
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            languagesController.tr("CANCEL"),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        if (addCommsionGroupController
                                .nameController
                                .text
                                .isNotEmpty &&
                            addCommsionGroupController
                                .amountController
                                .text
                                .isNotEmpty &&
                            addCommsionGroupController.commissiontype.value !=
                                "") {
                          addCommsionGroupController.createnow();
                          print(" filled");
                        } else {
                          print("No data filled");
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Obx(
                            () => Text(
                              addCommsionGroupController.isLoading.value ==
                                      false
                                  ? languagesController.tr("CREATE_NOW")
                                  : languagesController.tr("PLEASE_WAIT"),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  DeleteDialog({super.key, this.groupID});

  String? groupID;

  DeleteComissiongroupController controller = Get.put(
    DeleteComissiongroupController(),
  );

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 200,
      width: screenWidth,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            languagesController.tr("DO_YOU_WANT_TO_DELETE"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 25),
          Container(
            height: 50,
            width: screenWidth,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.deletenow(groupID.toString());
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Obx(
                        () => Text(
                          controller.isLoading.value == false
                              ? languagesController.tr("YES")
                              : languagesController.tr("PLEASE_WAIT"),
                          style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        languagesController.tr("NO"),
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateGroupBox extends StatefulWidget {
  UpdateGroupBox({super.key, this.groupID});

  String? groupID;

  @override
  State<UpdateGroupBox> createState() => _UpdateGroupBoxState();
}

class _UpdateGroupBoxState extends State<UpdateGroupBox> {
  final box = GetStorage();

  final AddCommsionGroupController updateController = Get.put(
    AddCommsionGroupController(),
  );

  List commissiontype = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    commissiontype = [
      {"name": languagesController.tr("PERCENTAGE"), "value": "percentage"},
    ];
  }

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 450,
      width: screenWidth,
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
                    print(updateController.commissiontype.toString());
                  },
                  child: Text(
                    languagesController.tr("UPDATE_GROUP"),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * 0.022,
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
                  languagesController.tr("GROUP_NAME"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Authtextfield(
              hinttext: languagesController.tr("ENTER_GROUP_NAME"),
              controller: updateController.nameController,
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  languagesController.tr("COMMISSION_TYPE"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => Text(updateController.commitype.value.toString()),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            content: Container(
                              height: 150,
                              width: screenWidth,
                              color: Colors.white,
                              child: ListView.builder(
                                itemCount: commissiontype.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      updateController.commitype.value =
                                          commissiontype[index]["name"];
                                      updateController.commissiontype.value =
                                          commissiontype[index]["value"];
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      height: 50,
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Text(
                                            commissiontype[index]["name"],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(
                        FontAwesomeIcons.chevronDown,
                        size: screenHeight * 0.018,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  languagesController.tr("AMOUNT"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Authtextfield(
              hinttext: languagesController.tr("ENTER_AMOUNT_OR_VALUE"),
              controller: updateController.amountController,
            ),
            SizedBox(height: 15),
            Container(
              height: 50,
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        updateController.amountController.clear();
                        updateController.nameController.clear();
                        updateController.commissiontype.value = "";
                        updateController.commitype.value = "";
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            languagesController.tr("CLOSE"),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        if (updateController.nameController.text.isNotEmpty &&
                            updateController.amountController.text.isNotEmpty &&
                            updateController.commissiontype.value != "") {
                          updateController.updatenowd(
                            widget.groupID.toString(),
                          );
                          print(" filled");
                        } else {
                          print("No data filled");
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Obx(
                            () => Text(
                              updateController.isLoading.value == false
                                  ? languagesController.tr("UPDATE_NOW")
                                  : languagesController.tr("PLEASE_WAIT"),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
