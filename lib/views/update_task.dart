import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samia_apis/models/task.dart';

import '../provider/user_token.dart';
import '../services/task.dart';

class UpdateTask extends StatefulWidget {
  final Task model;
  const UpdateTask({super.key, required this.model});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  @override
  void initState(){
    super.initState();
    descriptionController = TextEditingController(
      text: widget.model.description.toString()
    );
  }
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Task"),
      ),
      body: Column(children: [
        TextField(controller: descriptionController,),
        isLoading ? Center(child: CircularProgressIndicator(),)
            :ElevatedButton(onPressed: ()async{
          try{
            await TaskServices().updateTask(
              taskID: widget.model.id.toString(),
                token: userProvider.getToken().toString(),
                description: descriptionController.text)
                .then((value){
              isLoading = false;
              setState(() {});
              showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                  content: Text("Create Successfully"),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }, child: Text("Okay"))
                  ],
                );
              },);
            });
          }catch(e){
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));

          }
        }, child: Text("Create Task"))
      ],),
    );
  }
}
