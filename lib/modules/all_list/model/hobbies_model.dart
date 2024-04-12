class AllHobbiesModel {
  final String hobbyName;
  final List<HobbyList> hobbyList;

  AllHobbiesModel({
    required this.hobbyName,
    required this.hobbyList,
  });

  AllHobbiesModel.fromJson(Map<String, dynamic> json)
      : hobbyName = json['hobbyName'],
        hobbyList = List<HobbyList>.from(json['hobbyList'].map((x) => HobbyList.fromJson(x)));
}

class HobbyList {
  final String hobby;
  final String url;

  HobbyList({
    required this.hobby,
    required this.url,
  });

  HobbyList.fromJson(Map<String, dynamic> json)
      : hobby = json['hobby'],
        url = json['image'];
}
