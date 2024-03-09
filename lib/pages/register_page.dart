
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth/auth_service.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpwController = TextEditingController();
  final void Function()? onTap;
  final FocusNode myFocusNode=FocusNode();
  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context) async {
    final authService = AuthService();
    if (passwordController.text == confirmpwController.text) {
      try {
        await authService.signUpwithEmailPassword(
            emailController.text, passwordController.text);
      } catch (e) {
        showDialog(context: context, builder: (context) =>
            AlertDialog(
              title: Text(e.toString()),
            ));
      }
    }
  else{
  showDialog(context: context, builder: (context) =>
  AlertDialog(
  title: Text("Password dont match"),
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

            //Welcome
            Text(
              "Let's Create an account for you!",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 16),
            ),

            //email
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: emailController,
              focusNode: myFocusNode,
            ),


            //password
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: passwordController,
              focusNode: myFocusNode,
            ),
            //confirm password

            //password
            MyTextField(
              hintText: "Confirm Password",
              obscureText: true,
              controller: confirmpwController,
              focusNode: myFocusNode,
            ),

            //login button
            MyButton(
              text: "Register",
              onTap: ()=>register(context),
            ),
            const SizedBox(
              height: 10.0,
            ),
            //register now
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Already have an account ?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  )),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Login Now",
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
