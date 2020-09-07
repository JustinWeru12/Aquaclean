class User {
  final String userId;
  User({this.userId});
}

class UserData {
  final String userId;
  final String fullNames;
  final String email;
  final String phone;
  final String picture;
  final List<String> favorites;
  final bool admin;
  UserData(
      {this.userId,
      this.fullNames,
      this.email,
      this.phone,
      this.picture,
      this.favorites,
      this.admin,});

  Map<String, dynamic> getDataMap() {
    return {
      "userId": userId,
      "fullNames": fullNames,
      "email": email,
      "phone": phone,
      "favorites":favorites,
      "picture": picture,
      "admin": admin,
    };
  }
}
