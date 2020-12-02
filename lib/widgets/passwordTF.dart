import 'package:flutter/material.dart';

class PasswordTF extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  PasswordTF(this.controller, {this.hintText});

  @override
  _PasswordTFState createState() => _PasswordTFState(controller, hintText: hintText);
}

class _PasswordTFState extends State<PasswordTF> {
  TextEditingController controller;
  bool isObscure = false;
  String hintText;
  _PasswordTFState(this.controller, {this.hintText});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.black,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              isObscure = (!isObscure);
            });
          },
        ),
        hintText: hintText!=null?hintText:'Password',
      ),
      obscureText: isObscure,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}
