import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/models/notesmodel.dart';
import 'package:notesapp/pages/add_note_page.dart';
import 'package:notesapp/provider/notes_provider.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    String searchQuery = "";
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes App"),
      ),
      body: notesProvider.isLoading
          ? SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(hintText: 'Search'),
                    ),
                  ),
                  GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount:
                          notesProvider.getfilteredNotes(searchQuery).length,
                      itemBuilder: (context, index) {
                        Note currnote =
                            notesProvider.getfilteredNotes(searchQuery)[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AddNotePage(
                                      isUpdate: true, note: currnote))),
                          onLongPress: () =>
                              {notesProvider.deleteNote(currnote)},
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.yellow[100],
                              border: Border.all(
                                color: Colors.orange,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currnote.title!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  currnote.content!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AddNotePage(
                        isUpdate: false,
                      )));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
