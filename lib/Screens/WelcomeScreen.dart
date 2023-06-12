import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Screens/HomeScreen.dart';
import 'package:todo_app/Screens/SignInScreen.dart';

import '../Services/FirebaseServices.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isLoading = false;

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    User? result = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.center,
              child: Text("Welcome to ToDo List Management",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.w600))),
          SizedBox(
            height: 15,
          ),
          Align(
              alignment: Alignment.center,
              child: Image.asset("assets/loginimage.jpg")),
          SizedBox(height: size.height * 0.1),
          SizedBox(
            width: size.width * 0.8,
            child: OutlinedButton(
              onPressed: () {
                result == null
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoogleSignIn(),
                        ),
                      )
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
              },
              child: Text("Get's start"),
              // style: ButtonStyle(
              //     // foregroundColor: MaterialStateProperty.all<Color>(
              //     //     Constants.kPrimaryColor
              //         ),
              //     backgroundColor: MaterialStateProperty.all<Color>(
              //         Constants.kBlackColor),
              //     side: MaterialStateProperty.all<BorderSide>(
              //         BorderSide.none)),
            ),
          ),
          SizedBox(
            width: size.width * 0.8,
            child: OutlinedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                FirebaseService service = new FirebaseService();
                try {
                  await service.signInwithGoogle();
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                } catch (e) {
                  if (e is FirebaseAuthException) {
                    showMessage(e.message!);
                  }
                }
                setState(() {
                  isLoading = false;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      height: 20,
                      width: 20,
                      // decoration: BoxDecoration(color: Colors.blue),
                      child: Container(
                          child: Image.network(
                              'http://pngimg.com/uploads/google/google_PNG19635.png',
                              fit: BoxFit.cover))),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text('Sign-in with Google')
                ],
              ),
              // style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all<Color>(
              //         Constants.kGreyColor),
              //     side: MaterialStateProperty.all<BorderSide>(
              //         BorderSide.none)),
            ),
          )
        ],
      ),
    );
  }
}
