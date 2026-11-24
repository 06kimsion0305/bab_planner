String formatYmd(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year$month$day';
}

enum AppDisplayMode {
  light,
  dark,
  rainbow;

  AppDisplayMode get next {
    switch (this) {
      case AppDisplayMode.light:
        return AppDisplayMode.dark;
      case AppDisplayMode.dark:
        return AppDisplayMode.rainbow;
      case AppDisplayMode.rainbow:
        return AppDisplayMode.light;
    }
  }

  String get label {
    switch (this) {
      case AppDisplayMode.light:
        return '라이트 모드';
      case AppDisplayMode.dark:
        return '다크 모드';
      case AppDisplayMode.rainbow:
        return '무지개 모드';
    }
  }

  String get shortLabel {
    switch (this) {
      case AppDisplayMode.light:
        return '라이트';
      case AppDisplayMode.dark:
        return '다크';
      case AppDisplayMode.rainbow:
        return '무지개';
    }
  }
}

class MealDish {
  final String name;
  final List<int> allergyCodes;

  const MealDish({required this.name, this.allergyCodes = const []});

  static const Map<int, String> allergyMap = {
    1: '난류',
    2: '우유',
    3: '메밀',
    4: '땅콩',
    5: '대두',
    6: '밀',
    7: '고등어',
    8: '게',
    9: '새우',
    10: '돼지고기',
    11: '복숭아',
    12: '토마토',
    13: '아황산류',
    14: '호두',
    15: '닭고기',
    16: '쇠고기',
    17: '오징어',
    18: '조개류',
    19: '잣',
  };

  List<String> get allergyNames =>
      allergyCodes.map((c) => allergyMap[c] ?? '$c번').toList();

  factory MealDish.parse(String rawLine) {
    final cleaned = rawLine.trim();
    final regex = RegExp(r'\(([0-9.]+)\)\s*$');
    final match = regex.firstMatch(cleaned);
    if (match != null) {
      final dishName = cleaned.substring(0, match.start).trim();
      final codesStr = match.group(1) ?? '';
      final codes = codesStr
          .split('.')
          .map((s) => int.tryParse(s.trim()))
          .whereType<int>()
          .toList();
      return MealDish(name: dishName, allergyCodes: codes);
    }
    return MealDish(name: cleaned);
  }
}

class SchoolMeal {
  final String dateYmd;
  final String mealType;
  final String calories;
  final List<MealDish> dishes;
  final String nutritionInfo;
  final String originInfo;

  const SchoolMeal({
    required this.dateYmd,
    required this.mealType,
    required this.calories,
    required this.dishes,
    this.nutritionInfo = '',
    this.originInfo = '',
  });

  DateTime? get dateTime {
    if (dateYmd.length != 8) return null;
    final y = int.tryParse(dateYmd.substring(0, 4));
    final m = int.tryParse(dateYmd.substring(4, 6));
    final d = int.tryParse(dateYmd.substring(6, 8));
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }
}

class SchoolScheduleItem {
  final String dateYmd;
  final String eventName;
  final String eventContent;
  final String dayType;
  final bool grade1;
  final bool grade2;
  final bool grade3;

  /// 여러 날 이어지는 일정(방학, 시험 기간 등)의 마지막 날. 하루 일정이면 null.
  final String? endDateYmd;

  const SchoolScheduleItem({
    required this.dateYmd,
    required this.eventName,
    this.eventContent = '',
    this.dayType = '해당없음',
    this.grade1 = true,
    this.grade2 = true,
    this.grade3 = true,
    this.endDateYmd,
  });

  String get endYmd => endDateYmd ?? dateYmd;

  bool get isMultiDay => endYmd != dateYmd;

  DateTime get endDateTime => _parseYmd(endYmd);

  bool overlaps(String fromYmd, String toYmd) =>
      endYmd.compareTo(fromYmd) >= 0 && dateYmd.compareTo(toYmd) <= 0;

  SchoolScheduleItem extendedTo(String newEndYmd) => SchoolScheduleItem(
        dateYmd: dateYmd,
        eventName: eventName,
        eventContent: eventContent,
        dayType: dayType,
        grade1: grade1,
        grade2: grade2,
        grade3: grade3,
        endDateYmd: newEndYmd,
      );

  /// 같은 일정이 연속된 날은 하나의 기간으로 합친다.
  static List<SchoolScheduleItem> mergeConsecutiveDays(
    List<SchoolScheduleItem> items,
  ) {
    final sorted = [...items]..sort((a, b) => a.dateYmd.compareTo(b.dateYmd));
    final merged = <SchoolScheduleItem>[];
    final openByKey = <String, int>{};

    for (final item in sorted) {
      final key =
          '${item.eventName}|${item.dayType}|${item.grade1}${item.grade2}${item.grade3}';
      final openIndex = openByKey[key];
      if (openIndex != null) {
        final open = merged[openIndex];
        final nextDay = open.endDateTime.add(const Duration(days: 1));
        if (!item.dateTime.isAfter(nextDay)) {
          if (item.endYmd.compareTo(open.endYmd) > 0) {
            merged[openIndex] = open.extendedTo(item.endYmd);
          }
          continue;
        }
      }
      openByKey[key] = merged.length;
      merged.add(item);
    }
    return merged;
  }

  DateTime get dateTime => _parseYmd(dateYmd);

  static DateTime _parseYmd(String ymd) {
    final y = ymd.length == 8 ? int.tryParse(ymd.substring(0, 4)) : null;
    final m = ymd.length == 8 ? int.tryParse(ymd.substring(4, 6)) : null;
    final d = ymd.length == 8 ? int.tryParse(ymd.substring(6, 8)) : null;
    if (y == null || m == null || d == null) return DateTime(1970);
    return DateTime(y, m, d);
  }

  bool get isHoliday => dayType == '공휴일' || dayType == '휴업일';

  bool get isSaturdayClosure => eventName == '토요휴업일';

  String get targetGradesLabel {
    if (grade1 && grade2 && grade3) return '전학년';
    final grades = <String>[];
    if (grade1) grades.add('1');
    if (grade2) grades.add('2');
    if (grade3) grades.add('3');
    if (grades.isEmpty) return '학교일정';
    return '${grades.join('·')}학년';
  }

  String dDayLabel(DateTime referenceDate) {
    final ref = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );
    final diff = dateTime.difference(ref).inDays;
    if (diff == 0) return 'D-Day';
    if (diff > 0) return 'D-$diff';
    if (!endDateTime.isBefore(ref)) return '진행 중';
    final endDiff = ref.difference(endDateTime).inDays;
    return '$endDiff일 전';
  }
}
