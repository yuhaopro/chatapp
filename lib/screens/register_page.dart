import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/services/sp_helper.dart';
import 'package:chatapp/widgets/widgets.dart';
import '../theme/theme.dart';
import 'routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final DatabaseService databaseService = DatabaseService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _errorUser = false;
  bool _errorEmail = false;
  bool _errorPassword = false;
  bool _errorConfirmPassword = false;

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
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
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
                              fontSize: 40,
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
                          TextFormField(
                            obscureText: false,
                            controller: _usernameController,
                            focusNode: _usernameFocusNode,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle: TextStyle(
                                color: AppTheme.textFormFieldColor(
                                    focusNode: _usernameFocusNode,
                                    error: _errorUser),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppTheme.textFormFieldColor(
                                      focusNode: _usernameFocusNode,
                                      error: _errorUser),
                                ),
                              ),
                              prefixIcon: const Icon(Icons.person),
                              errorText: _errorUser ? "Username exists" : null,
                              prefixIconColor: AppTheme.textFormFieldColor(
                                  focusNode: _usernameFocusNode,
                                  error: _errorUser),
                            ),
                            onChanged: null,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter a username";
                              } else {
                                if (val.length > 10) {
                                  return "Username must be 10 characters or less";
                                }
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          TextFormField(
                            obscureText: false,
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: AppTheme.textFormFieldColor(focusNode: _emailFocusNode, error: _errorEmail),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppTheme.textFormFieldColor(focusNode: _emailFocusNode, error: _errorEmail),
                                ),
                              ),
                              prefixIcon: const Icon(Icons.email),
                              errorText: _errorEmail
                                  ? "Email exists"
                                  : null,
                              prefixIconColor: AppTheme.textFormFieldColor(focusNode: _emailFocusNode, error: _errorEmail),
                            ),
                            onChanged: null,
                            validator: (val) {
                              setState(() {
                                _errorEmail = true;
                              });
                              bool emailValidate = EmailValidator.validate(val!);
                              if (!emailValidate) {
                                return "Invalid email";
                              }
                              setState(() {
                                _errorEmail = false;
                              });
                              return null;
                            },
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          TextFormField(
                            obscureText: true,
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: AppTheme.textFormFieldColor(focusNode: _passwordFocusNode, error: _errorPassword),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppTheme.textFormFieldColor(focusNode: _passwordFocusNode, error: _errorPassword),
                                ),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              prefixIconColor: AppTheme.textFormFieldColor(focusNode: _passwordFocusNode, error: _errorPassword),
                            ),
                            onChanged: null,
                            validator: (val) {
                              return val!.length >= 8
                                  ? null
                                  : "Password must be at least 8 characters";
                            },
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          TextFormField(
                            obscureText: true,
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocusNode,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              labelStyle: TextStyle(
                                color: AppTheme.textFormFieldColor(focusNode: _confirmPasswordFocusNode, error: _errorConfirmPassword),
                              ),
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock),
                              prefixIconColor: AppTheme.textFormFieldColor(focusNode: _emailFocusNode, error: _errorConfirmPassword),
                            ),
                            onChanged: null,
                            validator: (val) {
                              setState(() {
                                _errorConfirmPassword = true;
                              });
                              if (val!.length < 8) {
                                // val function will override errorText
                                return "Password must be at least 8 characters";
                              }
                              else if (_confirmPasswordController.text !=
                                  _passwordController.text) {
                                return "Password does not match";
                              }
                              setState(() {
                                _errorConfirmPassword = false;
                              });
                              return null;
                            },
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () {
                                register();
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
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
                                          context, Routes.login);
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

  void register() async {
    if (_formKey.currentState!.validate()) {
      bool usernameExist =
          await databaseService.checkDocumentExists(databaseService.usernameCollection , _usernameController.text);
      debugPrint("usernameExist: $_usernameController");
      if (usernameExist) {
        setState(() {
          _errorUser = true;
        });
        return;
      } else {
        setState(() {
          _errorUser = false;
        });
      }

      setState(() {
        _isLoading = true;
      });
      await authService
          .registerEmailandPassword(_usernameController.text,
              _emailController.text, _passwordController.text)
          .then((value) {
        if (value == true) {

          // saving the shared preference state
          SPHelper.saveUserLoggedInStatus(value);
          SPHelper.saveEmail(_emailController.text);
          SPHelper.saveUsername(_usernameController.text);
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, Routes.home);
          }
        } else {
          setState(() {
            _isLoading = false;
            debugPrint("FirebaseAuthException: $value");
            if (value == "email-already-in-use" || value == "invalid-email") {
              _errorEmail = true;
            }
          });
        }
      });
    }
  }
}
