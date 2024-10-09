import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:self_tags/models/note.dart';

class NotesController {

  final db = FirebaseFirestore.instance;

  Future<bool> addNote(String docID, List<Note> notes) async{

    List<dynamic> updatedList = notes.map((e) {
      return e.toMap();
    }).toList();

    await db.collection("notes").doc(docID).set({"notes": updatedList});

    return true;
  }

  Future<List<Note>> getAllNotes(String docID) async {
    DocumentSnapshot snapshot = await db.collection("notes").doc(docID).get();
    List<dynamic> retrievedNotes = snapshot["notes"];
    List<Note> notes = [];

    for (var note in retrievedNotes) {
      notes.add(Note.fromJson(note));
    }

    return notes;
  }

  
  Future<bool> updateNote(String docID, List<Note> notes) async {
    List<dynamic> updatedList = notes.map((e) {
      return e.toMap();
    }).toList();

    await db.collection("notes").doc(docID).set({"notes": updatedList});

    return true;
  }

  Future<bool> deleteNote(String docID, List<Note> notes) async {

     List<dynamic> updatedList = notes.map((e) {
      return e.toMap();
    }).toList();

    await db.collection("notes").doc(docID).set({"notes": updatedList});

    return true;

  }

  Future<bool> deleteAllNotes(String docID) async {
    await db.collection("notes").doc(docID).delete();

    return true;
  }
  
}