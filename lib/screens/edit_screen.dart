import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:overlay_support/overlay_support.dart";
import "package:provider/provider.dart";
import "package:self_tags/controller/notesController.dart";
import "package:self_tags/models/bubble.dart";
import "package:self_tags/models/note.dart";
import "package:self_tags/models/notes.dart";
import "package:self_tags/models/user.dart";

class EditScreen extends StatefulWidget {
  final Note note;
  final int index;

  const EditScreen({super.key, required this.note, required this.index});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  NotesController notesController = NotesController();

  bool isUpdating = false;
  bool isDeleting = false;

  @override
  void initState() {
    _titleController.text = widget.note.title;
    _bodyController.text = widget.note.body;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white,),
            );
          }
        ),
        backgroundColor: Colors.blue,
        title: const Row(children: [
          Text("Edit", style: TextStyle(color: Colors.white),),
          SizedBox(width: 10,),
          Icon(Icons.edit, color: Colors.white,)
          ],
        )
      ),
      body: Stack(
        children: [
          if (Provider.of<Bubble>(context).shouldShowBubbles)
            bubbles(),
          formContainer()


        ],
      ),
    );
  }

  Align formContainer() {
    return Align(
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
                            controller: _titleController,
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
                            controller: _bodyController,
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
                    
                          (isUpdating) ? Lottie.asset("assets/button_loader.json", width: 200, height: 100) : SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async{
                    
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                setState(() {
                                  isUpdating = !isUpdating;
                                });
                                
                                Provider.of<Notes>(context, listen: false).updateNote(widget.index, Note(title: _titleController.text, body: _bodyController.text, createdDate: widget.note.createdDate));

                                bool isUpdated = await notesController.updateNote(Provider.of<User>(context, listen: false).userID, Provider.of<Notes>(context, listen: false).getNotes);

                                if (isUpdated) {
                                  toast("Updated");
                                } else {
                                  toast("Error");
                                }

                                setState(() {
                                  isUpdating = !isUpdating;
                                });

                              }, 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white
                              ),
                              child: const Text("Update")
                            ),
                          ),
                          const SizedBox(height: 20,),

                          (isDeleting) ? Lottie.asset("assets/button_loader.json", width: 200, height: 100) : SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isDeleting = !isDeleting;
                                });

                                Provider.of<Notes>(context, listen: false).removeNote(widget.index);

                                bool isDeleted = await notesController.deleteNote(Provider.of<User>(context, listen: false).userID, Provider.of<Notes>(context, listen: false).getNotes);
                              
                                if (isDeleted) {
                                  toast("Deleted");
                                  Navigator.of(context).pop();
                                } else {
                                  toast("Not deleted");
                                }

                                setState(() {
                                  isDeleting = !isDeleting;
                                });
                              }, 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white
                              ),
                              child: const Text("Delete")
                            ),
                          ),
                      ],
                    ),
                  )
                ),
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
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Colors.purple, Colors.blue])
            ),
          ),
        ),


        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(left: 0, top: 0),
            height: 130,
            width: 130,
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
            height: 60,
            width: 60,
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
            margin: const EdgeInsets.only(left: 10, bottom: 150),
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