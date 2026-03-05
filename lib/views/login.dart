import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samia_apis/views/register.dart';

import '../provider/user_token.dart';
import '../services/auth.dart';
import 'get_all_task.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
    appBar: AppBar(
      title: Text("Login"),
    ),
    body: Column(children: [
      TextField(controller: emailController,),
      TextField(controller: passwordController,),
      isLoading ? Center(child: CircularProgressIndicator(),)
          :ElevatedButton(onPressed: ()async{
            try{
              await AuthService().loginUser(
                  email: emailController.text,
                  password: passwordController.text)
                  .then((val)async{
                    userProvider.setToken(val.token.toString());
                    await AuthService().getProfile(
                        token: userProvider.getToken().toString())
                    .then((value){
                      isLoading = false;
                      setState(() {});
                      showDialog(context: context, builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("Register Successfully"),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> GetAllTask()));
                            }, child: Text("Okay"))
                          ],
                        );
                      },);
                    });
              });
            }catch(e){
              isLoading = false;
              setState(() {});
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(e.toString())));

            }
      }, child: Text("Login")),
      ElevatedButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
      }, child: Text("Register"))
    ],),
    );
  }
}
