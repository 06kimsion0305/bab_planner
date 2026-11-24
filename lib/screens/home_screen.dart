import 'package:flutter/material.dart';

import '../data/seoul_finance_fallback_data.dart';
import '../models/school_models.dart';
import '../theme/app_mode_theme.dart';

class ScheduleFilter {
  final String id;
  final String label;
  final bool Function(SchoolScheduleItem item) matches;

  const ScheduleFilter({
    required this.id,
    required this.label,
    required this.matches,
  });

  /// 주요 · 이번 달 · 다음 달 · 다다음 달 · 지난 달 · 전체 순으로 기준일에 맞춰 생성.
  static List<ScheduleFilter> buildFor(DateTime today) {
    final recentFrom = formatYmd(
      DateTime(today.year, today.month, today.day - 7),
    );

    ScheduleFilter month(int offset) {
      final m = DateTime(today.year, today.month + offset);
      final prefix = formatYmd(m).substring(0, 6);
      final label =
          m.year == today.year ? '${m.month}월' : '${m.year % 100}.${m.month}월';
      return ScheduleFilter(
        id: 'month_$prefix',
        label: label,
        matches: (item) => item.overlaps('${prefix}01', '${prefix}31'),
      );
    }

    return [
      ScheduleFilter(
        id: 'highlights',
        label: '주요',
        matches: (item) =>
            !item.isSaturdayClosure && item.endYmd.compareTo(recentFrom) >= 0,
      ),
      month(0),
      month(1),
      month(2),
      month(-1),
      ScheduleFilter(id: 'all', label: '전체', matches: (_) => true),
    ];
  }
}

class FinanceSchoolHomeScreen extends StatefulWidget {
  final AppDisplayMode currentMode;
  final ValueChanged<AppDisplayMode> onModeChanged;
  final DateTime? initialDate;

  const FinanceSchoolHomeScreen({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
    this.initialDate,
  });

  @override
  State<FinanceSchoolHomeScreen> createState() =>
      _FinanceSchoolHomeScreenState();
}

class _FinanceSchoolHomeScreenState extends State<FinanceSchoolHomeScreen> {
  late DateTime _selectedDate;
  late DateTime _referenceToday;

  late final List<SchoolScheduleItem> _schedules;
  late final List<ScheduleFilter> _scheduleFilters;
  late ScheduleFilter _scheduleFilter;

  static const List<String> _weekdaysKor = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  void initState() {
    super.initState();
    final now = widget.initialDate ?? DateTime.now();
    _referenceToday = DateTime(now.year, now.month, now.day);
    _selectedDate = _referenceToday;
    _scheduleFilters = ScheduleFilter.buildFor(_referenceToday);
    _scheduleFilter = _scheduleFilters.first;

    final from = DateTime(_referenceToday.year, _referenceToday.month - 1, 1);
    final to = DateTime(_referenceToday.year, _referenceToday.month + 3, 0);
    final fromYmd = formatYmd(from);
    final toYmd = formatYmd(to);
    _schedules = SchoolScheduleItem.mergeConsecutiveDays(
      SeoulFinanceSchoolData.schedules,
    ).where((item) => item.overlaps(fromYmd, toYmd)).toList();
  }

  void _shiftSelectedDate(int days) {
    var nextDate = _selectedDate.add(Duration(days: days));
    // 주말인 경우 평일로 이동하여 급식 확인 편의성 향상
    if (nextDate.weekday == DateTime.saturday) {
      nextDate = nextDate.add(Duration(days: days >= 0 ? 2 : -1));
    } else if (nextDate.weekday == DateTime.sunday) {
      nextDate = nextDate.add(Duration(days: days >= 0 ? 1 : -2));
    }
    setState(() {
      _selectedDate = nextDate;
    });
  }

  String _formatKoreanDate(DateTime date) {
    final weekday = _weekdaysKor[date.weekday - 1];
    return '${date.month}월 ${date.day}일 ($weekday)';
  }

  String _formatShortDate(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final weekday = _weekdaysKor[date.weekday - 1];
    return '$m.$d ($weekday)';
  }

  List<SchoolScheduleItem> get _filteredSchedules =>
      _schedules.where(_scheduleFilter.matches).toList();

  void _showMealDetailModal(AppModeStyle style, SchoolMeal meal) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 412),
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
          decoration: BoxDecoration(
            color: style.mode == AppDisplayMode.dark
                ? const Color(0xFF1E222B)
                : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '서울금융고등학교 ${meal.mealType} 상세정보',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: style.primaryTextColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: style.accentColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        meal.calories,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: style.accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${_formatKoreanDate(_selectedDate)} · 행정표준코드 ${SeoulFinanceSchoolData.schoolCode}',
                  style: TextStyle(
                    fontSize: 13,
                    color: style.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '메뉴 및 알레르기 유발 식품 안내',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: style.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                ...meal.dishes.map(
                  (dish) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: style.accentColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            dish.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: style.primaryTextColor,
                            ),
                          ),
                        ),
                        if (dish.allergyNames.isNotEmpty)
                          Flexible(
                            child: Text(
                              dish.allergyNames.join(', '),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 12,
                                color: style.secondaryTextColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (meal.nutritionInfo.isNotEmpty) ...[
                  const Divider(height: 24),
                  Text(
                    '영양 정보',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: style.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    meal.nutritionInfo,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: style.secondaryTextColor,
                    ),
                  ),
                ],
                if (meal.originInfo.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    '원산지 정보',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: style.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    meal.originInfo,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: style.secondaryTextColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = AppModeStyle.of(widget.currentMode);

    return Scaffold(
      backgroundColor: style.mode == AppDisplayMode.dark
          ? const Color(0xFF0B0D11)
          : const Color(0xFFF2F4F7),
      body: SafeArea(
        child: Center(
          // 기반 코드(<RelativeLayout android:id="@+id/android_com" android:layout_width="412dp" android:layout_height="917dp" ... />) 규격 반영
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 412, maxHeight: 917),
            child: AnimatedContainer(
              key: const Key('android_com'),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              width: double.infinity,
              height: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: style.scaffoldBackground,
                gradient: style.scaffoldGradient,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTopHeaderBar(style),
                  _buildDataSourceBar(style),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMealSectionHeader(style),
                          const SizedBox(height: 10),
                          _buildMealCard(style),
                          const SizedBox(height: 24),
                          _buildScheduleSectionHeader(style),
                          const SizedBox(height: 10),
                          Expanded(child: _buildScheduleCard(style)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataSourceBar(AppModeStyle style) {
    return Padding(
      key: const Key('data_source_bar'),
      padding: const EdgeInsets.fromLTRB(20, 8, 16, 0),
      child: Text(
        '앱에 저장된 급식과 학사일정을 보여드려요.',
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: style.secondaryTextColor,
        ),
      ),
    );
  }

  /// 상단 헤더 영역: 시안의 '금융' 타이틀과 우측 원형 모드 전환 버튼
  Widget _buildTopHeaderBar(AppModeStyle style) {
    return Container(
      margin: const EdgeInsets.fromLTRB(6, 6, 6, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: style.headerBackground,
        gradient: style.headerGradient,
        border: Border.all(color: style.headerBorderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // 좌측 '금융' 타이틀 및 서울금융고등학교 서브 라벨
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '금융',
                  key: const Key('header_title_finance'),
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                    height: 1.05,
                    letterSpacing: -0.8,
                    color: style.headerTextColor,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    '서울금융고등학교',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: style.headerSubtitleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 모드 직접 선택 칩 (라이트 / 다크 / 무지개)
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.black.withValues(
                alpha: style.mode == AppDisplayMode.dark ? 0.28 : 0.08,
              ),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: AppDisplayMode.values.map((mode) {
                final isSelected = widget.currentMode == mode;
                return GestureDetector(
                  key: Key('mode_chip_${mode.name}'),
                  onTap: () => widget.onModeChanged(mode),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (style.mode == AppDisplayMode.dark
                              ? const Color(0xFF323947)
                              : Colors.white)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      mode.shortLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w500,
                        color: isSelected
                            ? style.primaryTextColor
                            : style.headerSubtitleColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 10),

          // 디자인 시안 우측의 붉은 갈색 원형 버튼 (탭 시 라이트 -> 다크 -> 무지개 순환)
          Tooltip(
            message:
                '현재: ${widget.currentMode.label} (탭하여 ${widget.currentMode.next.label}로 전환)',
            child: InkWell(
              key: const Key('theme_cycle_circle_button'),
              onTap: () => widget.onModeChanged(widget.currentMode.next),
              borderRadius: BorderRadius.circular(999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: style.modeCircleColor,
                  gradient: style.modeCircleGradient,
                  border: Border.all(
                    color: style.mode == AppDisplayMode.rainbow
                        ? Colors.white
                        : Colors.black.withValues(alpha: 0.15),
                    width: style.mode == AppDisplayMode.rainbow ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: style.modeCircleColor.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// '오늘의 급식표' 섹션 상단 라벨 및 날짜 이동 컨트롤
  Widget _buildMealSectionHeader(AppModeStyle style) {
    final isToday = DateUtils.isSameDay(_selectedDate, _referenceToday);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '오늘의 급식표',
              key: const Key('section_title_meal'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: style.sectionTitleColor,
              ),
            ),
          ),
          InkWell(
            key: const Key('meal_prev_day_button'),
            onTap: () => _shiftSelectedDate(-1),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(
                Icons.chevron_left_rounded,
                size: 20,
                color: style.primaryTextColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = _referenceToday;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: style.itemSurfaceColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                isToday
                    ? '${_formatShortDate(_selectedDate)} 오늘'
                    : _formatShortDate(_selectedDate),
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: style.primaryTextColor,
                ),
              ),
            ),
          ),
          InkWell(
            key: const Key('meal_next_day_button'),
            onTap: () => _shiftSelectedDate(1),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: style.primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 시안 상단의 라운드 박스: 서울금융고등학교 급식표 카드
  Widget _buildMealCard(AppModeStyle style) {
    final meal = SeoulFinanceSchoolData.mealsByYmd[formatYmd(_selectedDate)];

    return AnimatedContainer(
      key: const Key('meal_card_container'),
      duration: const Duration(milliseconds: 260),
      width: double.infinity,
      height: 215,
      margin: const EdgeInsets.only(left: 6, right: 24),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: style.cardBackground,
        gradient: style.cardGradient,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: style.cardBorderColor,
          width: style.mode == AppDisplayMode.light ? 0 : 1.2,
        ),
      ),
      child: meal == null
          ? _buildEmptyMealState(style)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: style.accentColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${meal.mealType} · ${meal.calories}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _formatKoreanDate(_selectedDate),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: style.secondaryTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      key: const Key('meal_detail_button'),
                      onTap: () => _showMealDetailModal(style, meal),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: style.itemSurfaceColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 12,
                              color: style.primaryTextColor,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '영양정보',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: style.primaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 42,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 7,
                    ),
                    itemCount: meal.dishes.length,
                    itemBuilder: (context, index) {
                      final dish = meal.dishes[index];
                      final dotColor = style.accentForIndex(index);

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: style.itemSurfaceColor,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: dotColor,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                dish.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: style.primaryTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyMealState(AppModeStyle style) {
    return _buildEmptyState(
      style,
      icon: Icons.no_meals_rounded,
      title: '저장된 급식 정보가 없어요.',
      subtitle: '다른 날짜를 선택해 보세요.',
    );
  }

  Widget _buildEmptyState(
    AppModeStyle style, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: style.secondaryTextColor),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: style.primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.5, color: style.secondaryTextColor),
          ),
        ],
      ),
    );
  }

  /// '최근 학사 일정' 섹션 상단 라벨 및 월별/주요 필터
  Widget _buildScheduleSectionHeader(AppModeStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Text(
            '최근 학사 일정',
            key: const Key('section_title_schedule'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: style.sectionTitleColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _scheduleFilters.map((filter) {
                  final selected = _scheduleFilter.id == filter.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: GestureDetector(
                      key: Key('schedule_filter_${filter.id}'),
                      onTap: () {
                        setState(() {
                          _scheduleFilter = filter;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? style.accentColor
                              : style.cardBackground,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          filter.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                selected ? FontWeight.w700 : FontWeight.w500,
                            color: selected
                                ? Colors.white
                                : style.secondaryTextColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 시안 하단의 대형 라운드 박스: 서울금융고등학교 최근 학사 일정 리스트
  Widget _buildScheduleCard(AppModeStyle style) {
    final items = _filteredSchedules;

    return AnimatedContainer(
      key: const Key('schedule_card_container'),
      duration: const Duration(milliseconds: 260),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: style.cardBackground,
        gradient: style.cardGradient,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: style.cardBorderColor,
          width: style.mode == AppDisplayMode.light ? 0 : 1.2,
        ),
      ),
      child: items.isEmpty
          ? _buildEmptyState(
              style,
              icon: Icons.event_available_rounded,
              title: '저장된 학사일정이 없어요.',
              subtitle: '다른 달을 선택하거나 전체 일정을 확인해 보세요.',
            )
          : ListView.separated(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 9),
              itemBuilder: (context, index) {
                final item = items[index];
                final itemDate = item.dateTime;
                final barColor = style.accentForIndex(index);
                final dDay = item.dDayLabel(_referenceToday);
                final isUpcoming = !item.endDateTime.isBefore(_referenceToday);

                return InkWell(
                  onTap: () {
                    // 학사 일정 날짜를 탭하면 해당 날짜의 급식표도 즉시 함께 조회
                    setState(() {
                      _selectedDate = itemDate;
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: style.itemSurfaceColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 38,
                          decoration: BoxDecoration(
                            color: item.isHoliday
                                ? style.holidayBadgeTextColor
                                : barColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 68,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatShortDate(itemDate),
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: item.isHoliday
                                      ? style.holidayBadgeTextColor
                                      : style.primaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dDay,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isUpcoming
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isUpcoming
                                      ? barColor
                                      : style.secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.eventName,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: style.primaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 1.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: barColor.withValues(alpha: 0.14),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item.targetGradesLabel,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: barColor,
                                      ),
                                    ),
                                  ),
                                  if (item.isHoliday) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 1.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: style.holidayBadgeColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item.dayType,
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          color: style.holidayBadgeTextColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (item.isMultiDay) ...[
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        '~ ${_formatShortDate(item.endDateTime)}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600,
                                          color: style.secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
