import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController {

  final db = FirebaseFirestore.instance;
  
  Future<bool> saveUser(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DocumentReference ref = await db.collection("users").add(data);
    await db.collection("users").doc(ref.id).update({"userID": ref.id});

    await prefs.setStringList("userCache", [data["firstName"], data["lastName"], data["username"], data["password"], ref.id]);

    return true;
  }

  Future<Map<String,dynamic>?> loginUser(Map<String,String> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    QuerySnapshot snapshot = await db.collection("users").get();
    

    List<QueryDocumentSnapshot> docs = snapshot.docs;

    for (var doc in docs) {
      if (doc.get("username") == data["username"] && doc.get("password") == data["password"]) {
        
        await prefs.setStringList("userCache", [doc["firstName"], doc["lastName"], doc["username"], doc["password"], doc["userID"]]);
        
        return doc.data() as Map<String,dynamic>;
      }
    }

    return null;
  }

}