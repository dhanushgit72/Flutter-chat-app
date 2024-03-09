import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  //instance of auth
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User?getCurrentUser(){
    return _auth.currentUser;
  }
  //sign in
Future <UserCredential> signInwithEmailPassword(String email,password) async{
  try{
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

    _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          "uid":userCredential.user!.uid,
          "email":email,
        }
    );

    return userCredential;
  }on FirebaseException catch(e){
    throw Exception(e.code);
  }
}

  //signup
  Future <UserCredential> signUpwithEmailPassword(String email,password) async{
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          "uid":userCredential.user!.uid,
          "email":email,
        }
      );

      return userCredential;
    }on FirebaseException catch(e){
      throw Exception(e.code);
    }
  }
  //signout
Future<void>signOut()async{
  return await _auth.signOut();
}
  //errors
}