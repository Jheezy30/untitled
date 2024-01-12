

class Model {
  String? title;
  int id;
  int userId;
  bool? completed;

  Model({
    this.id = 1,
    required this.title,
    this.completed = false,
    required this.userId,
  });

  Model.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        title = json['title'] as String,
        completed = json['completed'] ?? false,
        userId = json['userId'] as int;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'userId': userId,
    };
  }
}