// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:auth_using_sanctum/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();
  @override
  void initState() {
    readToken();
    super.initState();
  }

  void readToken() async {
    var token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token);
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterLaravel Auth'),
      ),
      drawer: Drawer(
        // use the consumer to check if user login or not
        // to change the widget or swetch between them.
        child: Consumer<Auth>(builder: (context, auth, child) {
          if (!auth.authenticated) {
            return ListView(
              children: [
                ListTile(
                  title: Text('login'),
                  leading: Icon(Icons.login),
                  onTap: () {
                    Navigator.of(context).pushNamed('loginScreen');
                  },
                )
              ],
            );
          } else {
            return ListView(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(auth.user.avatar),
                  ),
                  accountName: Text(auth.user.name),
                  accountEmail: Text(auth.user.email),
                ),
                ListTile(
                  title: Text('logout'),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                )
              ],
            );
          }
        }),
      ),
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
