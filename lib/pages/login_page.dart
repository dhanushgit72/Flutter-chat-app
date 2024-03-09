import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode myFocusNode=FocusNode();

  final void Function()? onTap;
  LoginPage({super.key,required this.onTap});

  void login(BuildContext context) async{
    //auth service
    final authService=AuthService();
    try{
      await authService.signInwithEmailPassword(emailController.text, passwordController.text);

    }catch(e){
      showDialog(context: context, builder: (context)=>AlertDialog(
        title: Text(e.toString()),
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 50.0,
            ),
            //Welcome
            Text(
              "Welcome Back , you've been missed",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 16),
            ),
            const SizedBox(
              height: 25.0,
            ),
            //email
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: emailController,
              focusNode: myFocusNode,
            ),
            const SizedBox(
              height: 10.0,
            ),
            //password
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: passwordController,
              focusNode: myFocusNode,
            ),
            //login button
            MyButton(
              text: "Login",
              onTap: ()=>login(context),
            ),
            const SizedBox(
              height: 10.0,
            ),
            //register now
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Not a Member ?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  )),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Register Now",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
              )
            ])
          ],
        ),
      ),
    );
    ;
  }
}
