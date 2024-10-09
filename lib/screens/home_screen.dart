import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:glassmorphism_ui/glassmorphism_ui.dart";
import "package:google_fonts/google_fonts.dart";
import "package:lottie/lottie.dart";
import "package:provider/provider.dart";
import "package:self_tags/controller/notesController.dart";
import "package:self_tags/models/bubble.dart";
import "package:self_tags/models/note.dart";
import "package:self_tags/models/notes.dart";
import "package:self_tags/models/user.dart";
import "package:self_tags/screens/authentication_screen.dart";
import "package:self_tags/screens/edit_screen.dart";
import "package:self_tags/screens/newNote.dart";
import "package:self_tags/screens/profile_screen.dart";
import "package:shared_preferences/shared_preferences.dart";


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  NotesController notesController = NotesController();

  final Shader textGradient = const LinearGradient(
      colors: [Colors.purple, Colors.blue],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 250.0, 60.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade600,
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu, color: Colors.white,),
            );
          }
        ),
        title: Text("Self tags", style: GoogleFonts.acme(textStyle: const TextStyle(color: Colors.white)),),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NewNoteScreen()));
            }, 
            icon: const Icon(Icons.add, size: 30, color: Colors.white,))
        ],
      ),
      drawer: SafeArea(
        child: Drawer(
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          child: Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        maxRadius: 40,
                        backgroundColor: Colors.indigoAccent,
                        child: Text("${Provider.of<User>(context,listen: false).firstName.substring(0,1)}${Provider.of<User>(context,listen: false).lastName.substring(0,1)}", style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                      const SizedBox(height: 10,),

                      Text("${Provider.of<User>(context, listen: false).firstName} ${Provider.of<User>(context, listen: false).lastName}", style: GoogleFonts.acme(textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, foreground: Paint()..shader = textGradient)),)
                    ],
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text("Profile"),
                      leading: const Icon(Icons.person),
                      trailing: const Icon(Icons.arrow_forward_ios_outlined),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
                      },
                    ),

                    const SizedBox(height: 20,),

                    ListTile(
                      title: const Text("Logout"),
                      leading: const Icon(Icons.logout_outlined),
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();

                        await prefs.clear();

                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AuthenticationScreen()));

                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          if (Provider.of<Bubble>(context).shouldShowBubbles)
            bubbles(),

          Center(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  
                });
                return;
              },
              child: FutureBuilder(
                future: notesController.getAllNotes(Provider.of<User>(context, listen: false).userID),
                builder: (context, snapshot) {
                  
                  if (snapshot.connectionState == ConnectionState.done) {
              
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return ListView(children: [ Align(alignment: Alignment.center,child: Text("No Tags", style: GoogleFonts.pacifico(textStyle: const TextStyle(fontSize: 50, color: Colors.amber)),))]);
                    }
              
                    Provider.of<Notes>(context).updateNotes(snapshot.data!);
                    
                    return ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(height: 20,),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Note note = snapshot.data![index];
              
                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: _noteCard(note, index),
                        );
                      },
                    );
              
                  } else {
                    return Lottie.asset("assets/load_icon.json");
                  }
                },
              ),
            )
          )
        ],
      )
    );
  }

  Widget _noteCard(Note note, int index) {

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditScreen(note: note, index: index,)));
      },
      child: GlassContainer(
        height: 300,
        width: 300,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Created ${note.createdDate}", style: const TextStyle(color: Colors.white),),
                ],
              ),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(note.title, style: GoogleFonts.acme(textStyle: const TextStyle(fontSize: 24, color: Colors.white)),)
                ],
              ),
              const SizedBox(height: 15,),
              Align(alignment: Alignment.centerLeft,child: Text(note.body, textAlign: TextAlign.left, maxLines: 7, overflow: TextOverflow.fade, style: const TextStyle(fontSize: 18, color: Colors.white,),))
          
            ],
          ),
        )
      ),
    );
  }


  Widget bubbles() {
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
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 60, top: 120),
              height: 130,
              width: 130,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Colors.purple, Colors.blue])
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(right: 10, bottom: 10),
              height: 100,
              width: 100,
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
          ),
      ],
    );
  }
}