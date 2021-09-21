// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auth_using_sanctum/services/auth.dart';
import 'package:device_info_plus/device_info_plus.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // Device info
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? _deviceName;

  @override
  void initState() {
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
                    decoration: InputDecoration(hintText: 'name'),
                    keyboardType: TextInputType.emailAddress,
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'name field can\'t be empty';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(hintText: 'email'),
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(hintText: 'password'),
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password field can\'t be empty';
                      } else if (value.length <= 5) {
                        return 'Too short';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration:
                        InputDecoration(hintText: 'password_confirmation'),
                    keyboardType: TextInputType.text,
                    controller: _passwordConfirmationController,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Password does not match';
                      } else {
                        return null;
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Map registerData = {
                        'name': _nameController.text,
                        'email': _emailController.text,
                        'password': _passwordController.text,
                        'password_confirmation':
                            _passwordConfirmationController.text,
                      };
                      Map data = {
                        'email': _emailController.text,
                        'password': _passwordController.text,
                        'device_name': _deviceName ?? 'unknown',
                      };
                      if (_formKey.currentState!.validate()) {
                        Provider.of<Auth>(context, listen: false).register(
                          registerData: registerData,
                          data: data,
                        );
                        Navigator.of(context).pushNamed('homeScreen');
                      } else {
                        print('failed');
                      }
                    },
                    child: Text('Register'),
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
