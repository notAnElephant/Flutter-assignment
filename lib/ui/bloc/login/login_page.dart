import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';
import 'package:validators/validators.dart';

class LoginPageBloc extends StatefulWidget {
  const LoginPageBloc({super.key});

  @override
  State<LoginPageBloc> createState() => _LoginPageBlocState();
}

class _LoginPageBlocState extends State<LoginPageBloc> {
  bool rememberMe = false;
  String? errorMessageEmail;
  String? errorMessagePassword;
  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Email",
                errorText: errorMessageEmail,
              ),
              onChanged: (value) {
                setState(() {
                  errorMessageEmail = null;
                  email = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                errorText: errorMessagePassword,
              ),
              onChanged: (value) {
                setState(() {
                  errorMessagePassword = null;
                  password = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                ),
                const Text("Remember me"),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              bool passwordValid = true, emailValid = true;
              if (!isLength(password, 6)) {
                setState(() {
                errorMessagePassword =
                      "Password must be at least 6 characters long";
                });
                passwordValid = false;
              }
              if (!isEmail(email)) {
                setState(() {
                errorMessageEmail = "Email is not valid";
                });
                emailValid = false;
              }
              if (passwordValid && emailValid) {
                BlocProvider.of<LoginBloc>(context).add(
                  LoginSubmitEvent(email, password, rememberMe),
                );
              }
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
