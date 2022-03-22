import 'package:flutter/material.dart';

import 'package:email_validator/email_validator.dart';

class EmailFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const EmailFieldWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  _EmailFieldWidgetState createState() => _EmailFieldWidgetState();
}

class _EmailFieldWidgetState extends State<EmailFieldWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onListen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onListen);
    super.dispose();
  }

  void onListen() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        icon: Icon(
          Icons.email_outlined,
          color: Colors.blue.shade900,
        ),
        labelText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        suffixIcon: IconButton(
          icon: widget.controller.text.isEmpty
              ? Container(
                  width: 0,
                )
              : Icon(Icons.close),
          onPressed: () => widget.controller.clear(),
        ),
      ),
      autofillHints: [AutofillHints.email],
      validator: (email) => email != null && !EmailValidator.validate(email)
          ? "Please enter a valid email address"
          : null,
    );
  }
}
