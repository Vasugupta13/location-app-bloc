import 'package:hive/hive.dart';
import 'package:parkin_assessment/src/data/models/user_data.dart';

///Database repo to save user data to hive
class SaveUserDataRepo {
  final Box _userDataBox = Hive.box('user_data');

  ///[saveUserData] saves single data to hive db
  Future<void> saveUserData(String name, int age, String note) async {
    final userData = UserData(
      name: name,
      age: age,
      time: DateTime.now(),
      note: note,
    );

    await _userDataBox.add(userData.toMap());
  }

  ///[fetchUserData] fetches the list of saved data from db
  List<UserData> fetchUserData() {
    return _userDataBox.values.map((data) {
      return UserData.fromMap(Map<String, dynamic>.from(data));
    }).toList();
  }

  ///[deleteUserDataByDate] deletes a single data by matching DateTime key
  Future<void> deleteUserDataByDate(DateTime date) async {
    final key = _userDataBox.keys.firstWhere(
          (k) => DateTime.parse(_userDataBox.get(k)['time']).isAtSameMomentAs(date),
    );
    if (key != null) {
      await _userDataBox.delete(key);
    }
  }
}