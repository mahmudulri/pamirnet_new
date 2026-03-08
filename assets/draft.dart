// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class HawalaRatesTable extends StatelessWidget {
//   const HawalaRatesTable({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     // Header + accent colors (tweak to taste)
//     const headerColor = Color(0xFF0EA5E9); // sky-500 vibe
//     final zebraA = theme.colorScheme.surface;
//     final zebraB = theme.colorScheme.surface.withOpacity(0.6);

//     return Expanded(
//       child: Obx(
//         () => hawalacurrencycontroller.isLoading.value
//             ? const Center(child: CircularProgressIndicator())
//             : Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Card(
//                   elevation: 6,
//                   shadowColor: Colors.black12,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(16),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: headerColor.withOpacity(0.25), width: 1),
//                       ),
//                       child: Column(
//                         children: [
//                           // Nice colored header bar
//                           Container(
//                             height: 48,
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             alignment: Alignment.centerLeft,
//                             decoration: const BoxDecoration(
//                               color: headerColor,
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(Icons.currency_exchange, color: Colors.white.withOpacity(0.95)),
//                                 const SizedBox(width: 10),
//                                 Text(
//                                   languagesController.tr("Hawala Rates"),
//                                   style: theme.textTheme.titleMedium?.copyWith(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           // Table
//                           Expanded(
//                             child: Scrollbar(
//                               thumbVisibility: true,
//                               child: SingleChildScrollView(
//                                 scrollDirection: Axis.vertical,
//                                 child: SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   child: DataTableTheme(
//                                     data: DataTableThemeData(
//                                       headingRowHeight: 44,
//                                       dataRowMinHeight: 40,
//                                       dataRowMaxHeight: 46,
//                                       headingTextStyle: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w700,
//                                         fontSize: 13,
//                                         letterSpacing: 0.2,
//                                       ),
//                                       headingRowColor: WidgetStateProperty.all(headerColor),
//                                       dataTextStyle: const TextStyle(
//                                         fontSize: 12,
//                                         height: 1.2,
//                                       ),
//                                       dividerThickness: 0.4,
//                                     ),
//                                     child: DataTable(
//                                       showCheckboxColumn: false,
//                                       columnSpacing: 20,
//                                       border: TableBorder.symmetric(
//                                         inside: BorderSide(color: headerColor.withOpacity(0.15), width: 0.8),
//                                         outside: BorderSide(color: headerColor.withOpacity(0.20), width: 1),
//                                       ),
//                                       columns: [
//                                         DataColumn(
//                                           label: Text(languagesController.tr("AMOUNT")),
//                                         ),
//                                         DataColumn(
//                                           label: Center(
//                                             child: Text(languagesController.tr("FROM")),
//                                           ),
//                                         ),
//                                         DataColumn(
//                                           label: Center(
//                                             child: Text(languagesController.tr("TO")),
//                                           ),
//                                         ),
//                                         DataColumn(
//                                           label: Center(
//                                             child: Text(languagesController.tr("BUY")),
//                                           ),
//                                         ),
//                                         DataColumn(
//                                           label: Center(
//                                             child: Text(languagesController.tr("SELL")),
//                                           ),
//                                         ),
//                                       ],
//                                       rows: List.generate(
//                                         hawalacurrencycontroller
//                                                 .allcurrencylist.value.data?.rates?.length ??
//                                             0,
//                                         (i) {
//                                           final data = hawalacurrencycontroller
//                                               .allcurrencylist.value.data!.rates![i];

//                                           final rowBg = i.isEven ? zebraA : zebraB;

//                                           return DataRow(
//                                             // Hover & zebra colors
//                                             color: WidgetStateProperty.resolveWith<Color?>(
//                                               (states) {
//                                                 if (states.contains(WidgetState.hovered)) {
//                                                   return headerColor.withOpacity(0.08);
//                                                 }
//                                                 return rowBg;
//                                               },
//                                             ),
//                                             cells: [
//                                               DataCell(
//                                                 Center(
//                                                   child: Text(
//                                                     data.amount.toString(),
//                                                     textAlign: TextAlign.center,
//                                                   ),
//                                                 ),
//                                               ),
//                                               DataCell(
//                                                 Center(
//                                                   child: _pill(
//                                                     label: data.fromCurrency?.name ?? "-",
//                                                     icon: Icons.flag_circle,
//                                                     foreground: headerColor,
//                                                   ),
//                                                 ),
//                                               ),
//                                               DataCell(
//                                                 Center(
//                                                   child: _pill(
//                                                     label: data.toCurrency?.name ?? "-",
//                                                     icon: Icons.flag,
//                                                     foreground: Colors.teal,
//                                                   ),
//                                                 ),
//                                               ),
//                                               DataCell(
//                                                 Center(
//                                                   child: _badge(
//                                                     text:
//                                                         "${data.buyRate ?? '-'} ${data.toCurrency?.symbol ?? ''}",
//                                                     bg: Colors.green.withOpacity(0.12),
//                                                     fg: Colors.green.shade800,
//                                                   ),
//                                                 ),
//                                               ),
//                                               DataCell(
//                                                 Center(
//                                                   child: _badge(
//                                                     text:
//                                                         "${data.sellRate ?? '-'} ${data.toCurrency?.symbol ?? ''}",
//                                                     bg: Colors.red.withOpacity(0.12),
//                                                     fg: Colors.red.shade700,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }

//   // small rounded label with icon
//   Widget _pill({required String label, required IconData icon, required Color foreground}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: foreground.withOpacity(0.10),
//         borderRadius: BorderRadius.circular(999),
//         border: Border.all(color: foreground.withOpacity(0.25)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: foreground),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               color: foreground.withOpacity(0.95),
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // colored number chip
//   Widget _badge({required String text, required Color bg, required Color fg}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: fg.withOpacity(0.2)),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: fg,
//           fontWeight: FontWeight.w700,
//           fontSize: 12,
//         ),
//       ),
//     );
//   }
// }
