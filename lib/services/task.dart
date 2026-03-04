import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:samia_apis/models/taskListing.dart';

class TaskServices{
  String baseURL = "https://todo-nu-plum-19.vercel.app/";
  ///Create Task
  ///Get All Task
  ///Get Completed Task
  ///Get InCompleted Task
  ///Update Task
  ///Delete Task
  ///Mark As Completed
  ///Filter Task
  Future<TaskListingModel> filterTask({
    required String token,
    required String startDate,
    required String endDate,
  })async{
    try{
      http.Response response = await http.get(
        Uri.parse("$baseURL/todos/filter?startDate=$startDate&endDate=$endDate&="),
        headers : {'Authorization':  token},
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return TaskListingModel.fromJson(json.decode(response.body));
      }
      else{
        throw response.reasonPhrase.toString();
      }
    }catch(e){
      throw e.toString();}
  }
  ///Search Task
  Future<TaskListingModel> searchTask({
    required String token,
    required String keyword,
  })async{
    try{
      http.Response response = await http.get(
        Uri.parse("$baseURL/todos/search?keywords=$keyword"),
        headers : {'Authorization':  token},
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return TaskListingModel.fromJson(json.decode(response.body));
      }
      else{
        throw response.reasonPhrase.toString();
      }
    }catch(e){
      throw e.toString();}
  }
}