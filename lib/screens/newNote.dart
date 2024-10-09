import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:lottie/lottie.dart";
import "package:overlay_support/overlay_support.dart";
import "package:provider/provider.dart";
import "package:self_tags/controller/notesController.dart";
import "package:self_tags/models/bubble.dart";
import "package:self_tags/models/note.dart";
import "package:self_tags/models/notes.dart";
import "package:self_tags/models/user.dart";


class NewNoteScreen extends StatefulWidget {
  const NewNoteScreen({super.key});

  @override
  State<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {

  TextEditingController noteTitleController = TextEditingController();
  TextEditingController noteBodyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  NotesController notesController = NotesController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade600,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              icon: const Icon(Icons.arrow_back, color: Colors.white,)
            );
          },
        ),
        title: const Text("New Note", style: TextStyle(color: Colors.white),),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [

            if (Provider.of<Bubble>(context, listen: false).shouldShowBubbles)
              bubbles(),

            Align(
              alignment: Alignment.center,
              child: Container(
                height: 400,
                width: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                          TextFormField(
                            controller: noteTitleController,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "Please enter a title";
                              }
                    
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter title",
                              label: Text("Title", style: TextStyle(fontSize: 18)),
                            ),
                          ),
                          const SizedBox(height: 20,),
                    
                          TextFormField(
                            controller: noteBodyController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 10,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "Please enter note";
                              }
                    
                              return null;
                            },
                            decoration: const InputDecoration(
                              
                              hintText: "Enter note",
                              label: Text("Note", style: TextStyle(fontSize: 18),)
                            ),
                          ),
                    
                          const SizedBox(height: 20,),
                    
                          (isLoading) ? Lottie.asset("assets/button_loader.json", width: 200, height: 100) : SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                    
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                setState(() {
                                  isLoading = !isLoading;
                                });

                                String createdDate = DateFormat.yMd().format(DateTime.now());

                                Provider.of<Notes>(context, listen: false).addNote(Note(title: noteTitleController.text, body: noteBodyController.text, createdDate: createdDate));
                                
                                bool isSaved = await notesController.addNote(Provider.of<User>(context, listen: false).userID, Provider.of<Notes>(context, listen: false).getNotes);

                                if (isSaved) {
                                  toast("Tagged");
                                } else {
                                  toast("Not tagged");
                                }

                                noteTitleController.text = "";
                                noteBodyController.text = "";

                                setState(() {
                                  isLoading = !isLoading;
                                });
                                
                              }, 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white
                              ),
                              child: const Text("Tag it")
                            ),
                          ),
                      ],
                    ),
                  )
                ),
              ),
            )

          ],
        )
      ),
    );
  }

  Stack bubbles() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            height: 150,
            width: 150,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Colors.purple, Colors.blue])
            ),
          ),
        ),

        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.only(left: 0, top: 0),
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Colors.purple, Colors.blue])
            ),
          ),
        ),

        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10, right: 30),
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Colors.purple, Colors.blue])
            ),
          ),
        ),

        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: const EdgeInsets.only(left: 10, bottom: 80),
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Colors.purple, Colors.blue])
            ),
          ),
        )
      ],
    );
  }
}