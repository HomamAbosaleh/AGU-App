class Meal {
  final String day;
  final String mainDish;
  final String sideDish;
  final String soup;
  final String appetiser;
  final int mainCal;
  final int sideCal;
  final int soupCal;
  final int appetiserCal;

  Meal(
      {required this.day,
      required this.mainDish,
      required this.sideDish,
      required this.soup,
      required this.appetiser,
      required this.mainCal,
      required this.sideCal,
      required this.soupCal,
      required this.appetiserCal});
}
