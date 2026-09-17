class DateFormatter {
  DateFormatter._();

  static const List<String> _monthsShort = [
    'янв.', 'фев.', 'мар.', 'апр.', 'мая', 'июн.',
    'июл.', 'авг.', 'сен.', 'окт.', 'ноя.', 'дек.',
  ];

  static String formatHour(String? isoDateTime) {
    if (isoDateTime == null) return '-';
    final date = DateTime.tryParse(isoDateTime);
    if (date == null) return isoDateTime;
    final hh = date.hour.toString().padLeft(2, '0');
    final mm = date.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  static String formatDay(String? isoDate, {required int index}) {
    if (isoDate == null) return '-';
    if (index == 0) return 'Завтра';

    final date = DateTime.tryParse(isoDate);
    if (date == null) return isoDate;

    return '${date.day} ${_monthsShort[date.month - 1]}';
  }
}