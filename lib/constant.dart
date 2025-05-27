import 'package:flutter/material.dart';

//文字列
const baseURL = 'http://10.0.2.2:8000/api';
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const postsURL = '$baseURL/posts';
const commentsURL = '$baseURL/comments';

//エラー
const serverError = 'Server Error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong. Please try again!';

// --- input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    contentPadding: EdgeInsets.all(10),
    border: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.black),
    ),
  );
}

// button
TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    child: Text(label, style: TextStyle(color: Colors.white)),
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
      padding: MaterialStateProperty.resolveWith(
        (states) => EdgeInsets.symmetric(vertical: 10),
      ),
    ),
    onPressed: () => onPressed(),
  );
}

// likes and comment btn
Expanded kLikeAndComment(
  int value,
  IconData icon,
  Color color,
  Function onTap,
) {
  return Expanded(
    child: Material(
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              SizedBox(width: 4),
              Text('$value'),
            ],
          ),
        ),
      ),
    ),
  );
}
