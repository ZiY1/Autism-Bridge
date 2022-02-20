import 'package:flutter/material.dart';

class PasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool showHelper;
  final bool inSignInPage;
  const PasswordFieldWidget({
    Key? key,
    required this.controller,
    required this.showHelper,
    required this.inSignInPage,
  }) : super(key: key);

  @override
  _PasswordFieldWidgetState createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  //
  // Show/Hide password
  bool _obscureText = true;

  void changeVisibilityOfPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show helper text?
    bool _showHelper = widget.showHelper;
    bool _inSignInPage = widget.inSignInPage;
    //
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: (value) {
        if (value.toString().length < 6) {
          return _inSignInPage
              ? "Password is too short. Try at least 6 characters"
              : 'Please create a password with 6 or more characters';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          color: Colors.blue.shade900,
        ),
        labelText: "Password",
        helperText: _showHelper ? "6 or more characters" : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        suffixIcon: IconButton(
          icon: _obscureText
              ? Icon(
                  Icons.visibility,
                  color: Colors.blueGrey,
                )
              : Icon(
                  Icons.visibility_off,
                  color: Colors.blueGrey,
                ),
          onPressed: () {
            // Show and hide password action
            changeVisibilityOfPassword();
          },
        ),
      ),
    );
  }
}
