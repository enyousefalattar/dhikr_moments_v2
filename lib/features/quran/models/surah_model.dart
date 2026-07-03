enum SurahType { meccan, medinan }

class Surah {
  final int id;
  final String nameArabic;
  final String nameEnglish;
  final int versesCount;
  final SurahType type;

  Surah({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.versesCount,
    required this.type,
  });
}
