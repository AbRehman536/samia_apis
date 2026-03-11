import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samia_apis/views/update_profile.dart';

import '../provider/user_token.dart';

class GetProfile extends StatelessWidget {
  const GetProfile({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        children: [
          Text("Name : ${userProvider.getUser()?.user?.name.toString()}"),
          Text("Email : ${userProvider.getUser()?.user?.email.toString()}"),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateProfile()));
          }, child: Text("Update Profile"))
        ],
      ),
    );
  }
}
