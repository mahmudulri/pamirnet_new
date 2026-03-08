import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class PersianDateHelper {
  // 🔧 GLOBAL CONFIG
  // comment this line if you DON'T want seconds
  static const bool _showSeconds = true;

  /// 📅 تاریخ شمسی
  static String formatJalali(Jalali date) {
    final text =
        '${date.formatter.wN} '
        '${date.year}/${_twoDigits(date.month)}/${_twoDigits(date.day)}';

    return '\u200F${_toPersianNumber(text)}';
  }

  /// 📅 DateTime → تاریخ شمسی
  static String formatFromDateTime(DateTime dateTime) {
    final jalali = Jalali.fromDateTime(dateTime);
    return formatJalali(jalali);
  }

  /// ⏰ ساعت فعلی
  /// example:
  /// with seconds    → ۱۴:۳۵:۴۲
  /// without seconds → ۱۴:۳۵
  static String currentTime() {
    final now = DateTime.now();

    final time = _showSeconds
        ? '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}'
        : '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}';

    return '\u200F${_toPersianNumber(time)}';
  }

  // ───────────────── helpers ─────────────────

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');

  static String _toPersianNumber(String input) {
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    var result = input;
    for (int i = 0; i < en.length; i++) {
      result = result.replaceAll(en[i], fa[i]);
    }
    return result;
  }
}
