// import 'dart:io';

import 'package:fkc1/constant.dart';
import 'package:fkc1/models/api_response.dart';
import 'package:fkc1/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:fkc1/screens/login.dart';
import 'package:fkc1/screens/home.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void _loadUserInfo(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));

    String? token = await getToken();
    if (token == '') {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
        );
      }
    } else {
      ApiResponse response = await getUserDetail();
      if (response.error == null) {
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()),
            (route) => false,
          );
        }
      } else if (response.error == unauthorized) {
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.error.toString()),
              // duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  @override
  void initState() {
    _loadUserInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
