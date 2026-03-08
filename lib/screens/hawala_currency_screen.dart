import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/hawala_currency_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';

class HawalaCurrencyScreen extends StatefulWidget {
  HawalaCurrencyScreen({super.key});

  @override
  State<HawalaCurrencyScreen> createState() => _HawalaCurrencyScreenState();
}

class _HawalaCurrencyScreenState extends State<HawalaCurrencyScreen> {
  final box = GetStorage();

  final hawalacurrencycontroller = Get.find<HawalaCurrencyController>();
  LanguagesController languagesController = Get.put(LanguagesController());

  final Mypagecontroller mypagecontroller = Get.find();
  @override
  void initState() {
    super.initState();
    hawalacurrencycontroller.fetchcurrency();
  }

  final Color headerBg = AppColors.primaryColor;
  final Color headerText = Colors.white;
  final Color stripeLight = Colors.white;
  final Color stripeTint = AppColors.primaryColor.withOpacity(0.04);
  final Color hoverTint = AppColors.primaryColor.withOpacity(0.08);
  final Color selectTint = AppColors.primaryColor.withOpacity(0.15);
  final Color borderColor = AppColors.primaryColor;

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
                  Obx(
                    () => Text(
                      languagesController.tr("HAWALA_RATES"),
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
              SizedBox(height: 10),

              // Container(
              //   height: 40,
              //   width: screenWidth,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(13),
              //   ),
              //   child: Row(
              //     children: [
              //       Expanded(
              //           child: Container(
              //         color: Colors.red,
              //       )),
              //       Expanded(
              //           child: Container(
              //         color: Colors.yellow,
              //       )),
              //       Expanded(
              //           child: Container(
              //         color: Colors.red,
              //       )),
              //       Expanded(
              //         child: Container(
              //           color: Colors.cyan,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Expanded(
              //   child: Obx(
              //     () => hawalacurrencycontroller.isLoading.value == false
              //         ? ListView.builder(
              //             itemCount: hawalacurrencycontroller
              //                 .allcurrencylist.value.data!.rates!.length,
              //             itemBuilder: (context, index) {
              //               final data = hawalacurrencycontroller
              //                   .allcurrencylist.value.data!.rates![index];
              //               return Container(
              //                 margin: EdgeInsets.only(bottom: 5),
              //                 width: screenWidth,
              //                 decoration: BoxDecoration(
              //                   color: Colors.white,
              //                   borderRadius: BorderRadius.circular(6),
              //                 ),
              //                 child: Padding(
              //                   padding:  EdgeInsets.all(12.0),
              //                   child: Center(
              //                     child: Obx(
              //                       () => Text(
              //                         data.amount.toString() +
              //                             " " +
              //                             data.fromCurrency!.name.toString() +
              //                             " " +
              //                             languagesController.tr("TO") +
              //                             " " +
              //                             data.toCurrency!.name.toString() +
              //                             " " +
              //                             languagesController.tr("BUYING") +
              //                             " " +
              //                             data.buyRate.toString() +
              //                             " " +
              //                             data.toCurrency!.symbol.toString() +
              //                             " " +
              //                             languagesController.tr("SELLING") +
              //                             " " +
              //                             data.sellRate.toString() +
              //                             " " +
              //                             data.toCurrency!.symbol.toString(),
              //                         style: TextStyle(
              //                           color: Colors.black,
              //                           fontSize: screenHeight * 0.020,
              //                           fontFamily:
              //                               box.read("language").toString() ==
              //                                       "Fa"
              //                                   ? Get.find<FontController>()
              //                                       .currentFont
              //                                   : null,
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               );
              //             },
              //           )
              //         : Center(
              //             child: CircularProgressIndicator(),
              //           ),
              //   ),
              // ),
              Expanded(
                child: Obx(
                  () => hawalacurrencycontroller.isLoading.value == false
                      ? SingleChildScrollView(
                          // vertical scroll only, as you had
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: borderColor, width: 1),
                            ),
                            margin: EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: DataTableTheme(
                                data: DataTableThemeData(
                                  headingRowColor: MaterialStateProperty.all(
                                    headerBg,
                                  ),
                                  headingTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    letterSpacing: 0.3,
                                  ),
                                  dataTextStyle: TextStyle(
                                    fontSize: 12,
                                    height: 1.2,
                                  ),
                                  dividerThickness: 1,
                                  horizontalMargin: 12,
                                  columnSpacing: 12,
                                ),
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  headingRowHeight: 40,
                                  dataRowMinHeight: 36,
                                  dataRowMaxHeight: 44,
                                  border: TableBorder(
                                    horizontalInside: BorderSide(
                                      color: borderColor.withOpacity(0.25),
                                      width: 1,
                                    ),
                                    verticalInside: BorderSide(
                                      color: borderColor.withOpacity(0.15),
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                      color: borderColor,
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: borderColor,
                                      width: 1,
                                    ),
                                    left: BorderSide(
                                      color: borderColor,
                                      width: 1,
                                    ),
                                    right: BorderSide(
                                      color: borderColor,
                                      width: 1,
                                    ),
                                  ),
                                  columns: [
                                    DataColumn(
                                      label: Expanded(
                                        child: Center(
                                          child: Text(
                                            languagesController.tr("AMOUNT"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: headerText,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Center(
                                          child: Text(
                                            languagesController.tr("FROM"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: headerText,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Center(
                                          child: Text(
                                            languagesController.tr("TO"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: headerText,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Center(
                                          child: Text(
                                            languagesController.tr("BUY"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: headerText,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Center(
                                          child: Text(
                                            languagesController.tr("SELL"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: headerText,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: List<DataRow>.generate(
                                    hawalacurrencycontroller
                                            .allcurrencylist
                                            .value
                                            .data
                                            ?.rates
                                            ?.length ??
                                        0,
                                    (i) {
                                      final data = hawalacurrencycontroller
                                          .allcurrencylist
                                          .value
                                          .data!
                                          .rates![i];
                                      final isEven = i.isEven;

                                      return DataRow(
                                        color:
                                            MaterialStateProperty.resolveWith<
                                              Color?
                                            >((states) {
                                              if (states.contains(
                                                MaterialState.selected,
                                              )) {
                                                return selectTint;
                                              }
                                              if (states.contains(
                                                MaterialState.hovered,
                                              )) {
                                                return hoverTint;
                                              }
                                              return isEven
                                                  ? stripeLight
                                                  : stripeTint;
                                            }),
                                        // If you don't need row selection visuals, you can remove this line.
                                        onSelectChanged: (_) {},
                                        cells: [
                                          DataCell(
                                            Center(
                                              child: Text(
                                                data.amount.toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                data.fromCurrency?.name ?? "-",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                data.toCurrency?.name ?? "-",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                "${data.buyRate ?? '-'} ${data.toCurrency?.symbol ?? ''}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                "${data.sellRate ?? '-'} ${data.toCurrency?.symbol ?? ''}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
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
