import '../models/school_models.dart';

class SeoulFinanceSchoolData {
  static const String officeCode = 'B10';
  static const String officeName = '서울특별시교육청';
  static const String schoolCode = '7010964';
  static const String schoolName = '서울금융고등학교';
  static const String englishName = 'Seoul Finance High School';
  static const String schoolAddress = '서울특별시 양천구 가로공원로61길 19 (신월동)';
  static const String schoolPhone = '02-2694-3710';
  static const String schoolHomepage = 'http://seoulfc.sen.hs.kr';

  static const String defaultNutrition =
      '탄수화물(g) : 109.5 · 단백질(g) : 31.9 · 지방(g) : 18.4 · 칼슘(mg) : 702.6 · 철분(mg) : 11.0';
  static const String defaultOrigin =
      '쌀 : 국내산, 배추 : 국내산, 고춧가루 : 국내산, 쇠고기 : 국내산(육우), 돼지고기 : 국내산, 닭고기 : 국내산';

  static final Map<String, SchoolMeal> mealsByYmd = {
    '20261102': SchoolMeal(
      dateYmd: '20261102',
      mealType: '중식',
      calories: '989.3 Kcal',
      dishes: [
        MealDish.parse('압맥밥'),
        MealDish.parse('몽글이순두부찌개 (5.6.9.18)'),
        MealDish.parse('세발나물무생채 (5.6.13)'),
        MealDish.parse('닭목살채소구이 (15)'),
        MealDish.parse('참치마요&구이김 (1.5.13)'),
        MealDish.parse('배추김치 (9.13)'),
      ],
      nutritionInfo: defaultNutrition,
      originInfo: defaultOrigin,
    ),
    '20261103': SchoolMeal(
      dateYmd: '20261103',
      mealType: '중식',
      calories: '741.7 Kcal',
      dishes: [
        MealDish.parse('발아현미밥'),
        MealDish.parse('쇠고기무국 (5.6.16)'),
        MealDish.parse('꽁치김치조림 (5.6.9.13)'),
        MealDish.parse('감자채베이컨볶음 (1.10)'),
        MealDish.parse('오이김치 (9)'),
        MealDish.parse('사과 (13)'),
      ],
      nutritionInfo:
          '탄수화물(g) : 109.5 · 단백질(g) : 31.9 · 지방(g) : 18.4 · 비타민C(mg) : 19.2 · 칼슘(mg) : 702.6 · 철분(mg) : 11.0',
      originInfo: defaultOrigin,
    ),
    '20261104': SchoolMeal(
      dateYmd: '20261104',
      mealType: '중식',
      calories: '1045.3 Kcal',
      dishes: [
        MealDish.parse('추가밥'),
        MealDish.parse('해물크림짬뽕 (2.5.6.9.13.16.17.18)'),
        MealDish.parse('짜사이무침 (13)'),
        MealDish.parse('탕수육 (1.5.6.10)'),
        MealDish.parse('탕수육소스(기본) (5.6.13.18)'),
        MealDish.parse('배추김치 (9)'),
        MealDish.parse('오렌지자몽주스 (13)'),
      ],
      nutritionInfo: defaultNutrition,
      originInfo: defaultOrigin,
    ),
    '20261105': SchoolMeal(
      dateYmd: '20261105',
      mealType: '중식',
      calories: '943.9 Kcal',
      dishes: [
        MealDish.parse('차조밥'),
        MealDish.parse('콩가루열무국 (5.6)'),
        MealDish.parse('콩나물무침 (5.13)'),
        MealDish.parse('돈육주꾸미볶음(떡) (2.5.6.10.12.13.16.17.18)'),
        MealDish.parse('계란동그랑땡&케첩 (1.2.5.6.10.12.15.16)'),
        MealDish.parse('배추김치 (9.13)'),
      ],
      nutritionInfo: defaultNutrition,
      originInfo: defaultOrigin,
    ),
    '20261106': SchoolMeal(
      dateYmd: '20261106',
      mealType: '중식',
      calories: '1642.0 Kcal',
      dishes: [
        MealDish.parse('장조림버터볶음밥 (1.2.5.6.10.13.18)'),
        MealDish.parse('계란실파국 (1.5.6.9)'),
        MealDish.parse('라자냐 (1.2.5.6.10.12.13.16.18)'),
        MealDish.parse('오리엔탈드레싱샐러드 (2.5.6.12.13)'),
        MealDish.parse('깍두기 (9)'),
        MealDish.parse('바나나'),
      ],
      nutritionInfo: defaultNutrition,
      originInfo: defaultOrigin,
    ),
    '20261109': SchoolMeal(
      dateYmd: '20261109',
      mealType: '중식',
      calories: '808.9 Kcal',
      dishes: [
        MealDish.parse('차수수밥'),
        MealDish.parse('아욱된장국 (5.6)'),
        MealDish.parse('어묵고추장볶음 (1.5.6.8.13)'),
        MealDish.parse('돈육직화볶음 (5.6.10.13.18)'),
        MealDish.parse('배추김치 (9.13)'),
        MealDish.parse('청포도'),
      ],
      nutritionInfo: defaultNutrition,
      originInfo: defaultOrigin,
    ),
    '20261110': SchoolMeal(
      dateYmd: '20261110',
      mealType: '중식',
      calories: '1166.0 Kcal',
      dishes: [
        MealDish.parse('귀리밥'),
        MealDish.parse('새우살미역국 (5.6.9.13)'),
        MealDish.parse('계란볶이 (1.5.6.13)'),
        MealDish.parse('훈제오리채소찜 (1.2.5.6.13.16.18)'),
        MealDish.parse('참치김치볶음 (5.9.13)'),
        MealDish.parse('골드키위'),
      ],
      nutritionInfo: defaultNutrition,
      originInfo: defaultOrigin,
    ),
    '20261111': SchoolMeal(
      dateYmd: '20261111',
      mealType: '중식',
      calories: '1132.0 Kcal',
      dishes: [
        MealDish.parse('곤드레나물밥(양념간장 별도) (5.6)'),
        MealDish.parse('유부팽이미소국 (5.6)'),
        MealDish.parse('연근튀김&시즈닝 (2.5.6.13)'),
        MealDish.parse('돈육고추장구이 (5.6.10.13)'),
        MealDish.parse('배추김치 (9)'),
        MealDish.parse('초코떡빼로 (2.5.6)'),
      ],
      nutritionInfo: defaultNutrition,
      originInfo: defaultOrigin,
    ),
    '20261112': SchoolMeal(
      dateYmd: '20261112',
      mealType: '중식',
      calories: '1006.4 Kcal',
      dishes: [
        MealDish.parse('현미밥'),
        MealDish.parse('돈육감자고추장찌개 (5.6.9.10)'),
        MealDish.parse('로제닭볶음(분모자) (2.5.6.13.15)'),
        MealDish.parse('근대된장무침 (5.6.13)'),
        MealDish.parse('메밀전병(김치) (2.3.5.6.16.18)'),
        MealDish.parse('알타리김치 (9)'),
      ],
      nutritionInfo: defaultNutrition,
      originInfo: defaultOrigin,
    ),
    '20261113': SchoolMeal(
      dateYmd: '20261113',
      mealType: '중식',
      calories: '1039.4 Kcal',
      dishes: [
        MealDish.parse('카레라이스(크림) (2.5.6.10.12.13.16.18)'),
        MealDish.parse('불고기퀘사디아(또띠아) (1.2.5.6.8.10.12.13.16)'),
        MealDish.parse('만다린샐러드 (2.5.6.13)'),
        MealDish.parse('깍두기 (9)'),
        MealDish.parse('요구르트(엔요) (2)'),
      ],
      nutritionInfo: defaultNutrition,
      originInfo: defaultOrigin,
    ),
    '20261116': SchoolMeal(
      dateYmd: '20261116',
      mealType: '중식',
      calories: '981.8 Kcal',
      dishes: [
        MealDish.parse('할맥밥'),
        MealDish.parse('조랭이떡국 (1.5.6.16)'),
        MealDish.parse('오징어메추리알무조림 (1.5.6.13.17.18)'),
        MealDish.parse('청경채양배추겉절이 (5.6.13)'),
        MealDish.parse('돈육케첩조림 (2.5.6.10.12.13.16.18)'),
        MealDish.parse('배추김치 (9.13)'),
      ],
      nutritionInfo: defaultNutrition,
      originInfo: defaultOrigin,
    ),
    '20261117': SchoolMeal(
      dateYmd: '20261117',
      mealType: '중식',
      calories: '971.4 Kcal',
      dishes: [
        MealDish.parse('발아현미밥'),
        MealDish.parse('뼈없는감자탕 (5.6.9.10.16)'),
        MealDish.parse('비름나물무침 (13)'),
        MealDish.parse('삼치맛쵸킹소스 (5.6.12.13)'),
        MealDish.parse('마카로니샐러드 (1.5.6.13)'),
        MealDish.parse('배추김치 (9.13)'),
      ],
      nutritionInfo: defaultNutrition,
      originInfo: defaultOrigin,
    ),
    '20261118': SchoolMeal(
      dateYmd: '20261118',
      mealType: '중식',
      calories: '1417.6 Kcal',
      dishes: [
        MealDish.parse('햄마요덮밥 (1.2.5.6.10.12.13.15.16.18)'),
        MealDish.parse('호박두부된장국 (5.6)'),
        MealDish.parse('치커리겉절이 (5.6.13)'),
        MealDish.parse('닭봉구이(칠리소스) (2.5.6.8.12.13.15)'),
        MealDish.parse('깍두기 (9)'),
        MealDish.parse('딸기찰떡(찹쌀떡) (2.5.6)'),
      ],
      nutritionInfo: defaultNutrition,
      originInfo: defaultOrigin,
    ),
    '20261120': SchoolMeal(
      dateYmd: '20261120',
      mealType: '중식',
      calories: '918.4 Kcal',
      dishes: [
        MealDish.parse('나물비빔밥 & 약고추장 (5.6.13.16)'),
        MealDish.parse('들깨무채국 (5.6)'),
        MealDish.parse('청포묵김무침 (5.6.13)'),
        MealDish.parse('돈육전&파채 (1.2.5.6.10.13.15.18)'),
        MealDish.parse('백김치 (9.13.19)'),
        MealDish.parse('귤'),
      ],
      nutritionInfo: defaultNutrition,
      originInfo: defaultOrigin,
    ),
  };

  static const List<SchoolScheduleItem> schedules = [
    SchoolScheduleItem(
      dateYmd: '20260904',
      eventName: '자치 적응 활동',
      dayType: '해당없음',
    ),
    SchoolScheduleItem(
      dateYmd: '20260918',
      eventName: '자치 적응 활동',
      dayType: '해당없음',
    ),
    SchoolScheduleItem(
      dateYmd: '20261002',
      eventName: '자치 적응 활동',
      dayType: '해당없음',
    ),
    SchoolScheduleItem(
      dateYmd: '20261003',
      eventName: '개천절',
      dayType: '공휴일',
    ),
    SchoolScheduleItem(
      dateYmd: '20261005',
      eventName: '개천절 대체공휴일',
      dayType: '공휴일',
    ),
    SchoolScheduleItem(
      dateYmd: '20261009',
      eventName: '한글날',
      dayType: '공휴일',
    ),
    SchoolScheduleItem(
      dateYmd: '20261014',
      eventName: '2학기 중간고사 (1일차)',
      dayType: '해당없음',
      grade1: true,
      grade2: true,
      grade3: false,
    ),
    SchoolScheduleItem(
      dateYmd: '20261014',
      eventName: '3학년 졸업고사 (1일차)',
      dayType: '해당없음',
      grade1: false,
      grade2: false,
      grade3: true,
    ),
    SchoolScheduleItem(
      dateYmd: '20261015',
      eventName: '2학기 중간고사 (2일차)',
      dayType: '해당없음',
      grade1: true,
      grade2: true,
      grade3: false,
    ),
    SchoolScheduleItem(
      dateYmd: '20261015',
      eventName: '3학년 졸업고사 (2일차)',
      dayType: '해당없음',
      grade1: false,
      grade2: false,
      grade3: true,
    ),
    SchoolScheduleItem(
      dateYmd: '20261016',
      eventName: '2학기 중간고사 (3일차)',
      dayType: '해당없음',
      grade1: true,
      grade2: true,
      grade3: false,
    ),
    SchoolScheduleItem(
      dateYmd: '20261023',
      eventName: '자치 적응 활동',
      dayType: '해당없음',
    ),
    SchoolScheduleItem(
      dateYmd: '20261030',
      eventName: '자치 적응 활동',
      dayType: '해당없음',
    ),
    SchoolScheduleItem(
      dateYmd: '20261107',
      eventName: '토요휴업일',
      dayType: '휴업일',
    ),
    SchoolScheduleItem(
      dateYmd: '20261114',
      eventName: '토요휴업일',
      dayType: '휴업일',
    ),
    SchoolScheduleItem(
      dateYmd: '20261116',
      eventName: '목요대체수업',
      eventContent: '목요일 시간표로 수업 운영',
      dayType: '해당없음',
    ),
    SchoolScheduleItem(
      dateYmd: '20261119',
      eventName: '대학수학능력시험 (재량휴업일)',
      eventContent: '2027학년도 대학수학능력시험 시행일',
      dayType: '휴업일',
    ),
    SchoolScheduleItem(
      dateYmd: '20261121',
      eventName: '토요휴업일',
      dayType: '휴업일',
    ),
    SchoolScheduleItem(
      dateYmd: '20261128',
      eventName: '토요휴업일',
      dayType: '휴업일',
    ),
    SchoolScheduleItem(
      dateYmd: '20261204',
      eventName: '자치 적응 활동',
      dayType: '해당없음',
    ),
    SchoolScheduleItem(
      dateYmd: '20261211',
      eventName: '자치 적응 활동',
      dayType: '해당없음',
    ),
    SchoolScheduleItem(
      dateYmd: '20261215',
      eventName: '기말고사(1,2학년) 1일차',
      dayType: '해당없음',
      grade1: true,
      grade2: true,
      grade3: false,
    ),
    SchoolScheduleItem(
      dateYmd: '20261216',
      eventName: '기말고사(1,2학년) 2일차',
      dayType: '해당없음',
      grade1: true,
      grade2: true,
      grade3: false,
    ),
    SchoolScheduleItem(
      dateYmd: '20261217',
      eventName: '기말고사(1,2학년) 3일차',
      dayType: '해당없음',
      grade1: true,
      grade2: true,
      grade3: false,
    ),
    SchoolScheduleItem(
      dateYmd: '20261218',
      eventName: '기말고사(1,2학년) 4일차',
      dayType: '해당없음',
      grade1: true,
      grade2: true,
      grade3: false,
    ),
    SchoolScheduleItem(
      dateYmd: '20261225',
      eventName: '성탄절',
      dayType: '공휴일',
    ),
    SchoolScheduleItem(
      dateYmd: '20261230',
      eventName: '겨울방학식 · 금요대체수업',
      dayType: '해당없음',
    ),
    SchoolScheduleItem(
      dateYmd: '20261231',
      eventName: '겨울방학 시작',
      dayType: '휴업일',
    ),
  ];
}