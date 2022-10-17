///
/// Storage container for a problem.
///
class Problem {
  final String id;
  final int number;
  final int points;
  final String title;
  final String shortDesc;
  final String description;
  final String startCode;

  const Problem(
      {required this.id,
      required this.title,
      required this.description,
      required this.points,
      required this.number,
      required this.shortDesc,
      required this.startCode});

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      id: json['_id'],
      number: json['number'],
      points: json['points'],
      title: json['title'],
      shortDesc: json["short_desc"],
      description: json['description'],
      startCode: json['start_code'],
    );
  }
}
