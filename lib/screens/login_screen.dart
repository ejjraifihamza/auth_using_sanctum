// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:auth_using_sanctum/services/auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // Device info
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? _deviceName;

  @override
  void initState() {
    _emailController.text = 'user1@user1.com';
    _passwordController.text = '123456';
    getDeviceName();
    super.initState();
  }

  void getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        _deviceName = iosInfo.utsname.machine;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email field can\'t be empty';
                      } else if (!value.contains('@')) {
                        return 'Please enter right email';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password field can\'t be empty';
                      } else if (value.length <= 5) {
                        return 'Wrong Password';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text('Do not have account '),
                      InkWell(
                        child: Text(
                          'register',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onTap: () =>
                            Navigator.of(context).pushNamed('registerScreen'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Map data = {
                        'email': _emailController.text,
                        'password': _passwordController.text,
                        'device_name': _deviceName ?? 'unknown',
                      };
                      if (_formKey.currentState!.validate()) {
                        // print('$data');
                        Provider.of<Auth>(context, listen: false)
                            .login(data: data);
                        Navigator.of(context).pushNamed('homeScreen');
                      }
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
