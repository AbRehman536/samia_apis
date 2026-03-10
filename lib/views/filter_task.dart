import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:samia_apis/models/taskListing.dart';
import 'package:samia_apis/services/task.dart';

import '../provider/user_token.dart';

class FilterTask extends StatefulWidget {
  const FilterTask({super.key});

  @override
  State<FilterTask> createState() => _FilterTaskState();
}

class _FilterTaskState extends State<FilterTask> {
  TaskListingModel? taskListingModel;
  bool isLoading = false;
  DateTime? startDate;
  DateTime? endDate;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar:AppBar(
        title: Text("Filter Task"),
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            showDatePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now())
                .then((val){
                  setState(() {
                    startDate = val;
                  });
            });
          }, child: Text("Select Start Date")),
          if(startDate != null)
          Text(DateFormat.yMMMMEEEEd().format(startDate!)),
          ElevatedButton(onPressed: (){
            showDatePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now())
                .then((val){
                  setState(() {
                    endDate = val;
                  });
            });
          }, child: Text("Select End Date")),
          if(endDate != null)
          Text(DateFormat.yMMMMEEEEd().format(startDate!)),
          ElevatedButton(onPressed: ()async{
            try{
              isLoading = true;
              taskListingModel = null;
              setState(() {});

              final start = startDate!.toUtc().toIso8601String();
              final end = endDate!.toUtc().toIso8601String();
              TaskListingModel filteredTasks =
              await TaskServices().filterTask(
                  token: userProvider.getToken().toString(),
                  startDate: start,
                  endDate: end);

              isLoading = true;
              taskListingModel = filteredTasks;
              setState(() {});
            }catch(e){
              isLoading = false;
              setState(() {});
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(e.toString())));
            }
          }, child: Text("Filter Task")),
          if(isLoading == true)
            Center(child: CircularProgressIndicator(),),
          if(taskListingModel == null)
            Center(child: Text("No Data Found"),)
          else
            Expanded(
              child: ListView.builder(
                itemCount: taskListingModel!.tasks!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(Icons.task),
                    title: Text(taskListingModel!.tasks![index].description.toString()),
                  );
                },),
            )
        ],
      ),
    );
  }
}
