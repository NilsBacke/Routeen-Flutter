class Task {
  String name;
  int isCompleted; // 0 if false, 1 if true
  int id;

  Task(this.name, this.isCompleted);

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
    this.name = map["name"];
    this.isCompleted = map["isCompleted"];
    this.id = map["id"];
  }
}
