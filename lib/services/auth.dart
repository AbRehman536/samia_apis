import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:samia_apis/models/login.dart';
import 'package:samia_apis/models/register.dart';
import 'package:samia_apis/models/user.dart';

class AuthService{

  String baseURL = "https://todo-nu-plum-19.vercel.app";

  ///Register User
  Future<RegisterModel> registerUser({
    required String name,
    required String email,
    required String password,
})async{
    try{
      http.Response response = await http.post(
        Uri.parse("$baseURL/users/register"),
          headers : {'Content-Type': 'application/json'},
        body: json.encode({
          "name": name,
          "email": email,
          "password": password
        }),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return RegisterModel.fromJson(json.decode(response.body));
      }
      else{
        throw response.reasonPhrase.toString();
      }
    }catch(e){
      throw e.toString();}
  }
  ///Login User
  Future<LoginModel> loginUser({
    required String email,
    required String password,
  })async{
    try{
      http.Response response = await http.post(
        Uri.parse("$baseURL/users/login"),
        headers : {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,
          "password": password
        }),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return LoginModel.fromJson(json.decode(response.body));
      }
      else{
        throw response.reasonPhrase.toString();
      }
    }catch(e){
      throw e.toString();}
  }
  ///Get Profile
  Future<UserModel> getProfile({
    required String token,
  })async{
    try{
      http.Response response = await http.get(
        Uri.parse("$baseURL/users/profile"),
        headers : {'Authorization': token},
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return UserModel.fromJson(json.decode(response.body));
      }
      else{
        throw response.reasonPhrase.toString();
      }
    }catch(e){
      throw e.toString();}
  }
  ///Update Profile
  Future<bool> updateProfile({
    required String token,
    required String name,
  })async{
    try{
      http.Response response = await http.put(
        Uri.parse("$baseURL/users/profile"),
        headers : {'Content-Type': 'application/json',
          'Authorization': token},
        body: json.encode({
          "name": name,
        }),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return true;
      }
      else{
        throw response.reasonPhrase.toString();
      }
    }catch(e){
      throw e.toString();}
  }
}