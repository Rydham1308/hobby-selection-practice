import 'package:practical/constants/lists.dart';
import 'package:practical/modules/all_list/model/hobbies_model.dart';

abstract class IAllHobbiesRepo {
  Future<List<AllHobbiesModel>?> getHobbies();
}

class GetHobbies extends IAllHobbiesRepo {
  @override
  Future<List<AllHobbiesModel>?> getHobbies() async {
    try {
      return List<AllHobbiesModel>.from(
          AllHobbiesList.allHobbies.map((e) => AllHobbiesModel.fromJson(e)));
    } catch (e) {
      throw Exception(e);
    }
  }
}
