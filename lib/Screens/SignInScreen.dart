import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Screens/HomeScreen.dart';
import 'package:todo_app/Services/FirebaseServices.dart';

class GoogleSignIn extends StatefulWidget {
  GoogleSignIn({Key? key}) : super(key: key);

  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
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
    return !isLoading
        ? Container(
            height: 60,
            child: SizedBox(
              width: size.width * 0.8,
              child: OutlinedButton.icon(
                icon: Icon(Icons.add),
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
                label: Row(
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
                //     backgroundColor:
                //         MaterialStateProperty.all<Color>(Constants.kGreyColor),
                //     side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
              ),
            ))
        : SizedBox(
            child: Center(child: CircularProgressIndicator()),
            height: 200.0,
            width: 200.0,
          );
  }
}
