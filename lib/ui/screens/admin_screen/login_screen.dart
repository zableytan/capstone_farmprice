import 'package:flutter/material.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/ui/widgets/custom_button.dart';
import 'package:myapp/ui/widgets/custom_icon.dart';
import 'package:myapp/ui/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // CONTROLLER
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // FOCUS NODE
  final _usernameNode = FocusNode();
  final _passwordNode = FocusNode();

  // FORM KEY
  final _formKey = GlobalKey<FormState>();

  // DISPOSE
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }


  // FUNCTION TO AUTHENTICATE LOGIN
  Future<void> _login() async {
    // CONTROLLER
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // AUTHENTICATE ADMIN ACCOUNT
    await AuthService().signIn(
      context: context,
      username: username,
      password: password,
      userType: 'admin',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ADMIN ICON
              const CustomIcon(
                imagePath: 'lib/ui/assets/admin_icon.png',
                size: 120,
              ),

              // SPACING
              const SizedBox(height: 15),

              // ADMIN TEXT
              const Text(
                "Login to Admin Dashboard",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF133c0b),
                ),
              ),

              // SIZED BOX
              const SizedBox(height: 20),

              Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // USERNAME
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1),
                      child: CustomTextField(
                        controller: _usernameController,
                        currentFocusNode: _usernameNode,
                        nextFocusNode: _passwordNode,
                        inputFormatters: null,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Username is required";
                          }
                          return null;
                        },
                        isPassword: false,
                        hintText: "Username",
                        minLines: 1,
                        maxLines: 1,
                        prefixIcon: const Icon(Icons.email_rounded),
                      ),
                    ),

                    // SPACING
                    const SizedBox(height: 10),


                    // PASSWORD
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1),
                      child: CustomTextField(
                        controller: _passwordController,
                        currentFocusNode: _passwordNode,
                        nextFocusNode: null,
                        inputFormatters: null,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                        isPassword: true,
                        hintText: "Password",
                        minLines: 1,
                        maxLines: 1,
                        prefixIcon: const Icon(Icons.lock_rounded),
                      ),
                    ),

                    // SPACING
                    const SizedBox(height: 15),

                    // LOGIN BUTTON
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1),
                      child: CustomButton(
                        buttonLabel: "Login",
                        onPressed: _login,
                        buttonColor: const Color(0xFF133c0b),
                        buttonHeight: 50,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        fontColor: Colors.white,
                        borderRadius: 10,
                      ),
                    ),

                    // SPACING
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
