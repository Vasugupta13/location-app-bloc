import 'package:hive/hive.dart';
import 'package:parkin_assessment/src/data/models/user_data.dart';

class SaveUserDataRepo {
  final Box _userDataBox = Hive.box('user_data');

  Future<void> saveUserData(String name, int age, String note) async {
    final userData = UserData(
      name: name,
      age: age,
      time: DateTime.now(),
      note: note,
    );

    await _userDataBox.add(userData.toMap());
  }

  List<UserData> fetchUserData() {
    return _userDataBox.values.map((data) {
      return UserData.fromMap(Map<String, dynamic>.from(data));
    }).toList();
  }

  Future<void> deleteUserDataByDate(DateTime date) async {
    final key = _userDataBox.keys.firstWhere(
          (k) => DateTime.parse(_userDataBox.get(k)['time']).isAtSameMomentAs(date),
    );
    if (key != null) {
      await _userDataBox.delete(key);
    }
  }
}