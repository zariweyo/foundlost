import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  String uid = "";
  Future<void> init();
}


class AuthServiceImpl extends  AuthService{
  @override
  Future<void> init() async {
    if(FirebaseAuth.instance.currentUser == null){
      await FirebaseAuth.instance.signInAnonymously();
    }

    uid = FirebaseAuth.instance.currentUser!.uid;
  }
  
}