// Minimal Surah metadata (index, arabic name, english name, start page, end page)
// The page ranges here are placeholders for wiring; update with accurate data later if needed.

class SajdaInfo {
  final int index; // 1..15
  final String verseKey;
  final String sajdahType;
  final int page; // 1-604
  const SajdaInfo(this.index, this.verseKey, this.sajdahType, this.page);
}

List<SajdaInfo> quranSajdahData = [
  SajdaInfo(1, "7:206", "اختيارية", 176),
  SajdaInfo(2, "13:15", "اختيارية", 251),
  SajdaInfo(3, "16:50", "اختيارية", 272),
  SajdaInfo(4, "17:109", "اختيارية", 293),
  SajdaInfo(5, "19:58", "اختيارية", 309),
  SajdaInfo(6, "22:18", "اختيارية", 334),
  SajdaInfo(7, "22:77", "اختيارية", 341),
  SajdaInfo(8, "25:60", "اختيارية", 365),
  SajdaInfo(9, "27:26", "اختيارية", 379),
  SajdaInfo(10, "32:15", "إجبارية", 416),
  SajdaInfo(11, "38:24", "اختيارية", 454),
  SajdaInfo(12, "41:38", "إجبارية", 480),
  SajdaInfo(13, "53:62", "إجبارية", 528),
  SajdaInfo(14, "84:21", "اختيارية", 589),
  SajdaInfo(15, "96:19", "إجبارية", 597),
];

// const Map<String, Map<String, dynamic>> quranSajdaData = {
//   "1": {
//     "sajdah_number": 1,
//     "verse_key": "7:206",
//     "page": 176,
//     "sajdah_type": "اختيارية",
//   },
//   "2": {
//     "sajdah_number": 2,
//     "verse_key": "13:15",
//     "page": 251,
//     "sajdah_type": "اختيارية",
//   },
//   "3": {
//     "sajdah_number": 3,
//     "verse_key": "16:50",
//     "page": 272,
//     "sajdah_type": "اختيارية",
//   },
//   "4": {
//     "sajdah_number": 4,
//     "verse_key": "17:109",
//     "page": 293,
//     "sajdah_type": "اختيارية",
//   },
//   "5": {
//     "sajdah_number": 5,
//     "verse_key": "19:58",
//     "page": 309,
//     "sajdah_type": "اختيارية",
//   },
//   "6": {
//     "sajdah_number": 6,
//     "verse_key": "22:18",
//     "page": 334,
//     "sajdah_type": "اختيارية",
//   },
//   "7": {
//     "sajdah_number": 7,
//     "verse_key": "22:77",
//     "page": 341,
//     "sajdah_type": "اختيارية",
//   },
//   "8": {
//     "sajdah_number": 8,
//     "verse_key": "25:60",
//     "page": 365,
//     "sajdah_type": "اختيارية",
//   },
//   "9": {
//     "sajdah_number": 9,
//     "verse_key": "27:26",
//     "page": 379,
//     "sajdah_type": "اختيارية",
//   },
//   "10": {
//     "sajdah_number": 10,
//     "verse_key": "32:15",
//     "page": 416,
//     "sajdah_type": "إجبارية",
//   },
//   "11": {
//     "sajdah_number": 11,
//     "verse_key": "38:24",
//     "page": 454,
//     "sajdah_type": "اختيارية",
//   },
//   "12": {
//     "sajdah_number": 12,
//     "verse_key": "41:38",
//     "page": 480,
//     "sajdah_type": "إجبارية",
//   },
//   "13": {
//     "sajdah_number": 13,
//     "verse_key": "53:62",
//     "page": 528,
//     "sajdah_type": "إجبارية",
//   },
//   "14": {
//     "sajdah_number": 14,
//     "verse_key": "84:21",
//     "page": 589,
//     "sajdah_type": "اختيارية",
//   },
//   "15": {
//     "sajdah_number": 15,
//     "verse_key": "96:19",
//     "page": 597,
//     "sajdah_type": "إجبارية",
//   },
// };
