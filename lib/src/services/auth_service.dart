import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:precavidos_simulador/src/global/environment.dart';
import 'package:precavidos_simulador/src/models/infousuario_response.dart';
import 'package:precavidos_simulador/src/models/usuario.dart';

class AuthService with ChangeNotifier {

  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  // Almacena el usuario en una variable con get y set
  Usuario? _usuario;
  Usuario? get usuario => this._usuario;
  // *************************************************

  Usuario? _userFromFirebase(auth.User? usuario){
    if(usuario == null){
      this._usuario = null;
      return null;
    }
    this._usuario = Usuario(id: usuario.uid, displayName: usuario.displayName, email: usuario.email, photoUrl: usuario.photoURL);
    return Usuario(id: usuario.uid, displayName: usuario.displayName, email: usuario.email, photoUrl: usuario.photoURL);
  } 

  Stream<Usuario?>? get user {
    
    return _firebaseAuth.authStateChanges().map( _userFromFirebase );
  }

  Future<Usuario?> signInWithEmailAndPassword(
    String email,
    String password
  ) async{
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return _userFromFirebase(credential.user);
    } catch (e) {
      print(e);
      print("Ha ocurrido un error en la autenticación");
    }  
  }

  Future<Usuario?> createUserWithEmailAndPassword(  
    String email,
    String password
  ) async{
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      return _userFromFirebase(credential.user);
    } catch (e) {
      print(e);
      print("Ha ocurrido un error en la autenticación");
    }    
  }

  
  final googleSingIn = GoogleSignIn();

  Future <Usuario?>googleLogin() async {

    try {
      final googleUser = await googleSingIn.signIn();
      if( googleUser == null ) return null;

      final googleAuth = await googleUser.authentication;

      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      final credentialAuth = await _firebaseAuth.signInWithCredential(credential);

      return _userFromFirebase(credentialAuth.user);
    } catch (e) {
      print("Ha ocurrido un error en la autenticación");
      return null;
    }
  }

  Future<void> signOut() async {
    if (googleSingIn.currentUser != null)
      await GoogleSignIn().disconnect().catchError((e, stack) {
    });

    await _firebaseAuth.signOut();
    return;
  }

  Future <String> getTokenUser() async {
    try {
      final usuario2 = _firebaseAuth.currentUser;
      if (usuario2 == null){
        return "No hay Token";
      }
      final idToken = await usuario2.getIdToken(true);
      return idToken;
    } catch (e) {
      print("Ha ocurrido un error");
      print(e);
      return "No hay Token";
    }
  }

  Future <InfoUserResponse> getInfoUser() async {
    final usuario2 = _firebaseAuth.currentUser;
    final idToken = await usuario2!.getIdToken(true);
    try {
      final resp = await http.get(Uri.parse("${ Environment.apiURL }/infousuario/listasimuladorescompleto"),
        headers: {
          'Content-Type': 'application/json',
          'x-token': idToken
        }
      );

      final infoUsuarioResponse = infoUserResponseFromJson( resp.body );

      return infoUsuarioResponse;

    } catch (e) {
      print(e);
      return new InfoUserResponse(
        msg: "Datos llenados en error",
        ok: false,
        simuladores: null,
        simuladores2: null,
        simuladores3: null,
      );  
    }
  }

}