import 'dart:ui';

import 'package:flutter/material.dart';
import 'firstpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Farm',
      routes:{
        '/login':(context)=>MyHomePage(),
        '/firstpage':(context)=>FirstPage()
      } ,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}
final GoogleSignIn googleSignIn=new GoogleSignIn();

void signOut(BuildContext context) async{
  await FirebaseAuth.instance.signOut();
  googleSignIn.signOut();
 Navigator.popAndPushNamed(context, 'login');
}


class MyHomePage extends StatefulWidget {
 @override
  _MyHomePageState createState() => _MyHomePageState();
}
FirebaseUser currentUser;
class _MyHomePageState extends State<MyHomePage> {

SharedPreferences prefs;

bool isLoggedIn=false;
bool isLoading=false;

void initState(){
  super.initState();
  isSignedIn();
}

void isSignedIn() async{

  this.setState((){
      isLoading=true;
  });

  prefs=await SharedPreferences.getInstance();
  isLoggedIn=await googleSignIn.isSignedIn();
  if(isLoggedIn){
    Navigator.pushReplacementNamed(context, '/firstpage');
  }

  this.setState((){
      isLoading=false;
  });
}
  
Future<FirebaseUser> signIn() async{
final FirebaseAuth fireBaseAuth=FirebaseAuth.instance;

this.setState((){
  isLoading=true;
});

GoogleSignInAccount googleUser=await googleSignIn.signIn();
GoogleSignInAuthentication googleAuth=await googleUser.authentication;
prefs=await SharedPreferences.getInstance();

FirebaseUser firebaseUser=await fireBaseAuth.signInWithGoogle(
accessToken: googleAuth.accessToken,
idToken:googleAuth.idToken
);

if(firebaseUser!=null){
  //Check if the user is in the database
  
  final QuerySnapshot result=
          await Firestore.instance.collection('users').where('id',isEqualTo:firebaseUser.uid).getDocuments();
  final List<DocumentSnapshot> documents =result.documents;

  if(documents.length==0){
    Firestore.instance.collection('users').document(firebaseUser.uid).setData({
      'nickname':firebaseUser.displayName, 'photourl':firebaseUser.photoUrl, 'id':firebaseUser.uid
    });

   currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
    
  }else{
    currentUser=firebaseUser;
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photourl']);
  }
  this.setState((){
    isLoading=false;
  });
}
Navigator.pushReplacementNamed(context, '/firstpage'); 
}






  @override
  Widget build(BuildContext context){
  return new Scaffold(
    body: login(),
  );
  }

  Widget login(){
    return Stack(
      children: [
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: AssetImage('images/IMG-20190119-WA0004.jpg'),
              fit:BoxFit.cover
            )
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX:10.0, sigmaY:10.0),
            child: new Container(

            ),
          ),
        ),
        Center(
          child: RaisedButton(
            child: new Text('Sign In with Google', style: TextStyle(color: Colors.white)),
            onPressed: (){
              signIn();
            },
            color: Colors.green,
          ),
        ),
        Positioned(
          child: isLoading?Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ):Container(),
        )
        ]
    );
  }
  }
