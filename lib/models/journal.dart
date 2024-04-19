import '../crud/const.dart';

class Journal {
  final int id;
  final String title;
  final String subtitle;
  final String date;
  final String mood;
  final String day;

  const Journal({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.mood,
    required this.day,
  });

  Journal.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        title = map[titleColumn] as String,
        subtitle = map[subtitleColumn] as String,
        date = map[dateColumn] as String,
        mood = map[moodColumn] as String,
        day = map[dayColumn] as String;

  @override
  String toString() =>
      'ID = $id, title = $title, subtitle = $subtitle, time = $date, mood = $mood, day = $day';

  @override
  bool operator ==(covariant Journal other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
