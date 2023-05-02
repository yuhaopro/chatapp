import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/theme/theme.dart';
import 'package:chatapp/widgets/text_form_field_themed.dart';
import 'screens_functions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
                vertical: MediaQuery.of(context).size.height * 0.1,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "SocraticMind",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Icon(
                      Icons.chat_outlined,
                      size: 100,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                    ),
                    TextFormFieldThemed(
                      focusNode: emailFocusNode,
                      labelText: "Email",
                      icon: Icon(Icons.email),
                      onChanged: null,
                      validator: (val) {
                        return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        // It's used to assert that the value of val is not null, and to force the code to continue execution even if it is null
                            .hasMatch(val!)
                            ? null
                            : "Please enter a valid email";
                      },
                      textEditingController: _emailController,
                      error: null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025),
                    TextFormFieldThemed(
                      obscureText: true,
                      focusNode: _passwordFocusNode,
                      labelText: "Password",
                      icon: Icon(Icons.lock),
                      onChanged: null,
                      validator: (val) {
                        return val!.length >= 8 ? null : "Password must be at least 8 characters";
                      },
                      textEditingController: _passwordController,
                      error: null,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          onPressed: () {
                                //TODO: Log in with the user and password information
                                ScreenFunctions.login(_formKey, _emailController.text, _passwordController.text);
                              },
                          child: Text(
                            "Login",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    Text.rich(TextSpan(
                      children: [
                        const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                            text: "sign up",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(
                                    context, '/register');
                              }),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
