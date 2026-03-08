extension PersianDigitExtension on String {
  String toPersianDigit() {
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    var result = this;
    for (int i = 0; i < en.length; i++) {
      result = result.replaceAll(en[i], fa[i]);
    }
    return result;
  }
}
