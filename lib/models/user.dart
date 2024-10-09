import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier{
  String firstName;
  String lastName;
  String username;
  String password;
  String userID;

  User({required this.firstName, required this.lastName, required this.username, required this.password, required this.userID});

  factory User.empty() {
    return User(firstName: "", lastName: "", username: "", password: "", userID: "");
  }

  factory User.fromJson(Map<String,dynamic> data) {
    return User(firstName: data["firstName"]!, lastName: data["lastName"]!, username: data["username"]!, password: data["password"]!, userID: data["userID"]!);
  }

  factory User.fromList(List<String> usercache) {
    return User(firstName: usercache[0], lastName: usercache[1], username:  usercache[2], password:  usercache[3], userID:  usercache[4]);
  }

  void updateData(Map<String, dynamic> data) {
    firstName = data["firstName"];
    lastName = data["lastName"];
    username = data["username"];
    password = data["password"];
    userID = data["userID"];
  }

}