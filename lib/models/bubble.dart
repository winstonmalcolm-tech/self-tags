import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bubble extends ChangeNotifier {
  bool status;

  Bubble({required this.status});

  factory Bubble.empty() {
    return Bubble(status: true);
  }

  factory Bubble.initialized(bool status) {

    return Bubble(status: status);
  }


  bool get shouldShowBubbles {
    return status;
  } 
  

  Future<void> updateStatus(bool status) async {

    this.status = status;
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    await pref.setBool("bubbleStatus", status);
  }
}