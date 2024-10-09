import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:self_tags/controller/notesController.dart';
import 'package:self_tags/models/bubble.dart';
import 'package:self_tags/models/notes.dart';
import 'package:self_tags/models/user.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  NotesController notesController = NotesController();

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
        title: const Text("Profile", style: TextStyle(color: Colors.white),),

      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer(
          builder: (context, value, child) {
            return Stack(
              children: [
                if (Provider.of<Bubble>(context, listen: true).shouldShowBubbles)
                  bubbles(),
                  Align(
                    alignment: Alignment.center,
                    child: _profileCard(context),
                  )
                ],
            );
          },
          
        ),
      )
    );
  }

  Widget _profileCard(BuildContext context) {

    return Consumer(
      builder: (context, value, child) {
          return GlassContainer(
            height: 500,
            width: MediaQuery.of(context).size.width / 0.3,
            blur: 4,
            color: Colors.black.withOpacity(0.7),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.3),
                ],
              ),
            shadowStrength: 5,
            borderRadius: BorderRadius.circular(16),
            shadowColor: Colors.white.withOpacity(0.24),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(DateFormat.yMMMMEEEEd().format(DateTime.now()), style: const TextStyle(color: Colors.white, fontSize: 18),),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("${Provider.of<User>(context,listen: false).firstName} ${Provider.of<User>(context,listen: false).lastName}", style: GoogleFonts.acme(textStyle: const TextStyle(fontSize: 30, color: Colors.white)),),
                      Text("@${Provider.of<User>(context,listen: false).username}", style: const TextStyle(fontSize: 18, color: Colors.white),)
                    ],
                  ),
                  const SizedBox(height: 30,),
                  Text("Total Tags: ${Provider.of<Notes>(context, listen: false).numberOfNotes}", style: const TextStyle(fontSize: 20, color: Colors.white),),
                  const SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Show bubbles: ", style: TextStyle(fontSize: 20, color: Colors.white)),
                      Switch(
                        value: Provider.of<Bubble>(context, listen: true).shouldShowBubbles, 
                        activeColor: Colors.amber,
                        onChanged: (status) async {
                          await Provider.of<Bubble>(context, listen: false).updateStatus(status);
                        }
                      ),
                    ],
                  ),

                  const SizedBox(height: 40,),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        Provider.of<Notes>(context, listen: false).clearNotes();
                        bool isDeleted = await notesController.deleteAllNotes(Provider.of<User>(context, listen: false).userID);

                        if (isDeleted) {
                          toast("Deleted");
                        } else {
                          toast("Error");
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 163, 50, 42),
                        foregroundColor: Colors.white
                      ),
                      child: const Text("Delete all notes"),
                    ),
                  )
                ],
              ),
            )
          );
      }
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