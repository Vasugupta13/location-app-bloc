class UserData {
  final String name;
  final int age;
  final DateTime time;
  final String note;

  UserData({
    required this.name,
    required this.age,
    required this.time,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'time': time.toIso8601String(),
      'note': note,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      age: map['age'],
      time: DateTime.parse(map['time']),
      note: map['note'],
    );
  }
}