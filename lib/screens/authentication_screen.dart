import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:lottie/lottie.dart";
import "package:overlay_support/overlay_support.dart";
import "package:provider/provider.dart";
import "package:self_tags/controller/authenticationController.dart";
import "package:self_tags/models/user.dart";
import "package:self_tags/screens/home_screen.dart";


class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>{

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool _shouldShowPassword = false;
  bool _authToggle = true;
  bool isRegistering = false;
  bool isLogining = false;

  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  final authenticationController = AuthenticationController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade600,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  bubbles(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  Text("Self Tags", style: GoogleFonts.acme(textStyle: const TextStyle(fontSize: 50, color: Colors.white)),),
                                  const SizedBox(height: 10,),
                                  const Text("`Think it, Confirm it, Tag it`", style: TextStyle(fontSize: 15, color: Colors.white, fontStyle: FontStyle.italic),)
                                ],
                              )
                            ),
                          
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    child: (_authToggle) ? const Text("Register", key: ValueKey(true), textAlign: TextAlign.right, style: TextStyle(fontSize: 30, color: Colors.white),) : const Text("Login", key: ValueKey(false),textAlign: TextAlign.right, style: TextStyle(fontSize: 30, color: Colors.white),)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 5,
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(100))
                  ),
                  height: MediaQuery.of(context).size.height / 1.6,
                  width: MediaQuery.of(context).size.width,
                  child: (_authToggle) ? registerForm() : loginForm(),
                ),
              ),
            )
          ]
        ),
      ),
    );
  }

  Form loginForm() {
    return Form(
      key: _loginKey,
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [   
              const SizedBox(height: 40,),            
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextFormField(
                  controller: _userNameController,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please enter username";
                    }
        
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter username"
                  ),
                ),
              ),
        
              const SizedBox(height: 40,),
                   
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _shouldShowPassword,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please enter password";
                    }
        
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _shouldShowPassword = !_shouldShowPassword;
                        });
                      }, 
                      icon: (_shouldShowPassword) ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)
                    ),
                    hintText: "Enter password"
                  ),
                ),
              ),

              const SizedBox(height: 40,),
                          
              (isLogining) ? Lottie.asset("assets/button_loader.json", width: 200, height: 100) : SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
        
                    if (!_loginKey.currentState!.validate()) {
                      return;
                    }
        
                    setState(() {
                      isLogining = !isLogining;
                    });
        
                    Map<String,String> data = {
                      "username": _userNameController.text,
                      "password": _passwordController.text
                    };
        
                    Map<String,dynamic>? user = await authenticationController.loginUser(data);
        
                    setState(() {
                      isLogining = !isLogining;
                    });
        
                    if (user != null) {
                      Provider.of<User>(context, listen: false).updateData(user);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
                    } else {
                      toast("Incorrect credentials");
                    }
                    
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                  ),
                  child: const Text("Login")
                ),
              ),

              const SizedBox(height: 20,),
                          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an Account?"),
                  const SizedBox(width: 10,),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(10)
                    ),
                    onPressed: () {
                      setState(() {
                        _authToggle = !_authToggle;
                      });
                    }, 
                    child: const Text("Register",)
                  )
                ],
              )
            ],
          ),
      )
      
    );
  }

  Form registerForm() {
    return Form(
        key: _registerKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 30,),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextFormField(
                  controller: _firstNameController,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please enter first name";
                    }
          
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter first name"
                  ),
                ),
              ),

              const SizedBox(height: 30,),
                          
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextFormField(
                  controller: _lastNameController,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please enter last name";
                    }
          
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter last name"
                  ),
                ),
              ),

              const SizedBox(height: 30,),
                                
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextFormField(
                  controller: _userNameController,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please enter username";
                    }
          
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter username"
                  ),
                ),
              ),

              const SizedBox(height: 30,),
                                         
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _shouldShowPassword,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please enter password";
                    } else if (value.length < 4) {
                      return "Password must be 4 or more characters";
                    }
          
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _shouldShowPassword = !_shouldShowPassword;
                        });
                      }, 
                      icon: (_shouldShowPassword) ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)
                    ),
                    hintText: "Enter password"
                  ),
                ),
              ),

              const SizedBox(height: 30,),
                          
              (isRegistering) ? Lottie.asset("assets/button_loader.json", width: 200, height: 100) : SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
          
                    if (!_registerKey.currentState!.validate()) {
                      return;
                    }
          
                    setState(() {
                      isRegistering = !isRegistering;
                    });
          
                    Map<String,dynamic> data = {
                      "firstName": _firstNameController.text,
                      "lastName": _lastNameController.text,
                      "username": _userNameController.text,
                      "password": _passwordController.text,
                      "userID": ""
                    };
          
                    bool isSuccess = await authenticationController.saveUser(data);
          
                    setState(() {
                      isRegistering = !isRegistering;
                    });
          
                    if (isSuccess) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
                    } else {
                      toast("Server error");
                    }
                    
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                  ),
                  child: const Text("Register")
                ),
              ),

              const SizedBox(height: 20,),
                          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an Account? "),
                  const SizedBox(width: 10,),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(5)
                    ),
                    onPressed: () {
                      setState(() {
                        _authToggle = !_authToggle;
                      });
                    }, 
                    child: const Text("Login",)
                  )
                ],
              )
            ],
          ),
        )
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