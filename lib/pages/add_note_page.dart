import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:notesapp/models/notesmodel.dart';
import 'package:notesapp/provider/notes_provider.dart';

// ignore: must_be_immutable
class AddNotePage extends StatefulWidget {
  late bool isUpdate;
  Note? note;
  AddNotePage({
    Key? key,
    required this.isUpdate,
    this.note,
  }) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  FocusNode nodefocus = FocusNode();
  TextEditingController titlectrl = TextEditingController();
  TextEditingController notesctrl = TextEditingController();
  String userid = "nikhilrawal";
  void addNotes() async {
    Provider.of<NotesProvider>(context, listen: false).addNote(Note(
        id: Uuid().v1(),
        userid: userid,
        title: titlectrl.text,
        content: notesctrl.text,
        dateadded: DateTime.now()));
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isUpdate) {
      titlectrl.text = widget.note!.title!;
      notesctrl.text = widget.note!.content!;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titlectrl.dispose();
    notesctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (widget.isUpdate) {
                updateNotes();
              } else {
                addNotes();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: titlectrl,
              onSubmitted: (value) {
                if (value != "") {
                  nodefocus.requestFocus();
                }
              },
              autofocus: widget.isUpdate ? false : true,
              style: TextStyle(fontSize: 30),
              decoration:
                  InputDecoration(hintText: 'Title', border: InputBorder.none),
            ),
            Expanded(
              child: TextField(
                controller: notesctrl,
                focusNode: nodefocus,
                style: TextStyle(fontSize: 20),
                maxLines: null,
                decoration: InputDecoration(
                    hintText: 'Enter Note Here', border: InputBorder.none),
              ),
            )
          ],
        ),
      )),
    );
  }

  void updateNotes() {
    widget.note!.title = titlectrl.text;
    widget.note!.content = notesctrl.text;
    widget.note!.dateadded = DateTime.now();

    Provider.of<NotesProvider>(context, listen: false).updateNote(widget.note!);
    Navigator.of(context).pop();
  }
}
