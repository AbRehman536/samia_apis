import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samia_apis/views/update_task.dart';

import '../models/taskListing.dart';
import '../provider/user_token.dart';
import '../services/task.dart';
import 'create_Task.dart';

class GetInCompletedTask extends StatelessWidget {
  const GetInCompletedTask({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get InCompleted Task"),
      ),

      body: FutureProvider.value(
        value: TaskServices().getInCompletedTask(userProvider.getToken().toString()),
        initialData: [TaskListingModel()],
        builder: (context, child){
          TaskListingModel taskListingModel = context.watch<TaskListingModel>();
          return ListView.builder(
            itemCount: taskListingModel.tasks!.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  leading: Icon(Icons.task),
                  title: Text(taskListingModel.tasks![index].description.toString()),
                  trailing: Row(
                      children: [
                        Checkbox(
                            value: taskListingModel.tasks![index].complete ?? false,
                            onChanged: taskListingModel.tasks![index].complete == true ? null
                                :(value)async{
                              try{
                                await TaskServices().markTaskAsCompleted(
                                    token: userProvider.getToken().toString(),
                                    taskID: taskListingModel.tasks![index].id.toString());
                              }catch(e){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(e.toString())));
                              }

                            }),
                        IconButton(onPressed: ()async{
                          try{
                            await TaskServices().deleteTask(
                                token: userProvider.getToken().toString(),
                                taskID: taskListingModel.tasks![index].id.toString())
                                .then((value){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text("Task Deleted Successfully")));
                            });
                          }catch(e){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        }, icon: Icon(Icons.delete)),
                        IconButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateTask(model: taskListingModel.tasks![index])));
                        }, icon: Icon(Icons.edit))
                      ]
                  )
              );
            },);
        },
      ),
    );
  }
}
