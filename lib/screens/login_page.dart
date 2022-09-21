import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: 'Sign in failed');
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: 'Sign in cancelled');
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: 'Sign in successful');
        break;
      default:
        break;
    }

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 150,
              ),
              Text(
                'Welcome to Chat App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Login to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Image.asset('assets/images/chat_logo.png'),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  bool isSuccess = await authProvider.handleGoogleSignIn();
                  if (isSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  }
                },
                child: Image.asset('assets/images/google_signin.png'),
              ),
            ],
          ),
          Center(
            child: authProvider.status == Status.authenticating
                ? const CircularProgressIndicator()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
