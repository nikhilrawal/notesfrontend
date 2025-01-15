import 'package:flutter/material.dart';
import 'package:notesapp/models/notesmodel.dart';
import 'package:notesapp/services/services.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notes = [];
  bool isLoading = true;
  NotesProvider() {
    fetchNotes('nikhilrawal');
  }
  void sortnotes() {
    notes.sort((a, b) {
      return b.dateadded!.compareTo(a.dateadded!);
    });
  }

  List<Note> getfilteredNotes(String query) {
    List<Note> reslist = notes
        .where((e) => e.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return reslist;
  }

  void addNote(Note note) {
    notes.add(note);
    sortnotes();
    notifyListeners();
    ApiService.addNote(note);
  }

  void updateNote(Note note) {
    int index = notes.indexWhere((element) => element.id == note.id);
    if (index != -1) {
      notes[index] = note;
      notifyListeners();
      ApiService.updateNote(note);
    }
  }

  void deleteNote(Note note) {
    int index = notes.indexWhere((element) => element.id == note.id);
    notes.removeAt(index);

    notifyListeners();
    ApiService.deleteNote(note.id!);
  }

  void fetchNotes(String userid) async {
    notes = await ApiService.getNotes(userid);
    isLoading = false;
    sortnotes();
    notifyListeners();
  }
}
