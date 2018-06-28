class Task {
  String name;
  bool isCompleted;
  int id;

  Task(this.name);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["isCompleted"] = isCompleted;

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Task.fromMap(Map<String, dynamic> map) {
    this.name = map["username"];
    this.isCompleted = map["password"];
    this.id = map["id"];
  }
}
