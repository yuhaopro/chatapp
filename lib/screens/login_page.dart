import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../services/sp_helper.dart';
import '../theme/theme.dart';
import 'routes.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _emailError = false;
  bool _passwordError = false;

  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _isLoading ? const CircularProgressIndicator() : SingleChildScrollView(
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
                      Constants.title,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                    ),
                    const Icon(
                      Icons.chat_outlined,
                      size: 100,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025),
                    TextFormField(
                      obscureText: false,
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: AppTheme.textFormFieldColor(focusNode: _emailFocusNode, error: _emailError),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.textFormFieldColor(focusNode: _emailFocusNode, error: _emailError),
                          ),
                        ),
                        prefixIcon: const Icon(Icons.email),
                        errorText: _emailError ? "The email you entered is invalid or does not exist" : null,
                        prefixIconColor: AppTheme.textFormFieldColor(focusNode: _emailFocusNode, error: _emailError),
                      ),
                      onChanged: null,
                      validator: (val) {
                        bool emailValid = EmailValidator.validate(val!);
                        if (!emailValid) {
                          setState(() {
                            _emailError = true;
                          });
                        }
                        else {
                          _emailError = false;
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: AppTheme.textFormFieldColor(focusNode: _passwordFocusNode, error: _passwordError),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.textFormFieldColor(focusNode: _passwordFocusNode, error: _passwordError),
                          ),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        errorText: _passwordError ? "Wrong password" : null,
                        prefixIconColor: AppTheme.textFormFieldColor(focusNode: _passwordFocusNode, error: _passwordError),
                      ),
                      onChanged: null,
                      validator: (val) {
                        if (val!.isEmpty || val.length < 8) {
                          setState(() {
                            _passwordError = true;
                          });
                        }
                        return null;
                      },
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
                                login();
                              },
                          child: const Text(
                            "Login",
                            style: TextStyle(
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
                                    context, Routes.register);
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
  void login() async {
    if (_formKey.currentState!.validate())
      {
        setState(() {
          _isLoading = true;
          _emailError = false;
          _passwordError = false;
        });

        await authService.loginEmailandPassword(_emailController.text, _passwordController.text).then((value) async{
          // authenticated successfully
          if (value == true) {
            // Document object
            QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserDataThroughEmail(_emailController.text);
            // saving the shared preference state
            SPHelper.saveUserLoggedInStatus(value);
            SPHelper.saveEmail(_emailController.text);
            SPHelper.saveUsername(snapshot.docs[0]["username"]);
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, Routes.home);
            }
          } else {
            setState(() {
              _isLoading = false;
              debugPrint("FirebaseAuthException: $value");
              if (value == "wrong-password") {
                _passwordError = true;
              }
              if (value == "invalid-email" || value == "user-not-found") {
                _emailError = true;
              }
            });
          }
        });

      }
  }
}

