import 'package:flutter/foundation.dart';
import 'package:self_tags/models/note.dart';

class Notes extends ChangeNotifier{
  List<Note> notes;

  Notes({required this.notes});

  factory Notes.empty() {
    return Notes(notes: []);
  }

  int get numberOfNotes => notes.length;

  void updateNotes(List<Note> notes) {
    this.notes = notes;
  }

  void addNote(Note note) {
    notes.add(note);
  }

  void removeNote(int index) {
    notes.removeAt(index);
  }

  void updateNote(int index, Note note) {
    notes[index] = note;
  }

  void clearNotes() {
    notes.clear();
  }

  List<Note> get getNotes => notes;
}