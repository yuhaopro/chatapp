import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/theme/theme.dart';
import 'package:chatapp/widgets/text_form_field_themed.dart';
import 'screens_functions.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode usernameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _confirmpasswordFocusNode = FocusNode();

  String? _erroruser = null;
  String? _erroremail = null;
  String? _errorpassword = null;
  String? _errorconfirmpassword = null;

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
                      focusNode: usernameFocusNode,
                      labelText: "Username",
                      icon: Icon(Icons.person),
                      onChanged: null,

                      validator: (val) {
                        if (val!.isEmpty)
                          {
                            return "Please enter a username";
                          }
                        return null;
                      },
                      textEditingController: _usernameController,
                      error: _erroruser,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    TextFormFieldThemed(
                      focusNode: emailFocusNode,
                      labelText: "Email",
                      icon: Icon(Icons.email),
                      onChanged: (val) {

                      },
                      validator: (val) {
                        return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        // It's used to assert that the value of val is not null, and to force the code to continue execution even if it is null
                            .hasMatch(val!)
                            ? null
                            : "Please enter a valid email";
                      },
                      textEditingController: _emailController,
                      error: _erroremail,
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
                      error: _errorpassword,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    TextFormFieldThemed(
                      obscureText: true,
                        focusNode: _confirmpasswordFocusNode,
                        labelText: "Confirm Password",
                        icon: Icon(Icons.lock),
                        onChanged: null,
                        validator: (val) {
                          return val!.length < 8 ? "Password must be at least 8 characters" : (
                              _confirmpasswordController.text!.length == _passwordController.text!.length ? null : "Password does not match"
                          );
                        },
                        textEditingController: _confirmpasswordController,
                      error: _errorconfirmpassword,
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
                            ScreenFunctions.register(_formKey,_usernameController.text, _emailController.text, _passwordController.text, _confirmpasswordController.text);
                          },
                          child: Text(
                            "Register",
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
                          text: "Have an account? ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                            text: "sign in",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
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
