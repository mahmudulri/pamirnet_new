import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PriceTextView extends StatelessWidget {
  final String? price;
  final TextStyle? textStyle;

  const PriceTextView({super.key, this.price, this.textStyle});

  @override
  Widget build(BuildContext context) {
    final double priceDouble = double.tryParse(price ?? '0') ?? 0;

    return Text(
      NumberFormat.currency(
        locale: 'en_US',
        symbol: '',
        decimalDigits: 0,
      ).format(priceDouble),
      style: textStyle,
    );
  }
}
