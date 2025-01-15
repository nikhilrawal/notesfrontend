import 'dart:convert';
import 'package:notesapp/models/notesmodel.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String baserurl = "https://notesapi-n0ty.onrender.com/notes/";

  static Future<void> addNote(Note note) async {
    var uri = Uri.parse(baserurl + 'create');
    var res = await http.post(uri, body: note.toMap());
    var jsondecoded = jsonDecode(res.body);
    print(jsondecoded.toString());
  }

  static Future<void> updateNote(Note note) async {
    var uri = Uri.parse(baserurl + 'update');
    var res = await http.post(uri, body: note.toMap());
    var jsondecoded = jsonDecode(res.body);
    print(jsondecoded.toString());
  }

  static Future<void> deleteNote(String noteid) async {
    var uri = Uri.parse(baserurl + 'delete');
    var res = await http.post(uri, body: {"id": noteid});
    var jsondecoded = jsonDecode(res.body);
    print(jsondecoded.toString());
  }

  static Future<List<Note>> getNotes(String userid) async {
    var uri = Uri.parse(baserurl + 'list');
    var res = await http.post(uri, body: {"userid": userid});

    if (res.statusCode == 200) {
      var jsondecoded = jsonDecode(res.body);
      if (jsondecoded is List) {
        List<Note> reslist = jsondecoded.map((e) => Note.fromMap(e)).toList();
        print(jsondecoded);
        return reslist;
      } else {
        throw Exception("Unexpected response format: ${res.body}");
      }
    } else {
      throw Exception("Failed to fetch notes: ${res.statusCode}");
    }
  }
}
