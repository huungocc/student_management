import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../managers/manager.dart';
import '../services/service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();

  Future<void> _signOut() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SpinKitThreeBounce(
            color: Colors.black,
            size: 30.0,
          ),
        );
      },
    );

    await _authService.signOut(context);
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('home'),
          ElevatedButton(onPressed: _signOut, child: Text('Signout'))
        ],
      ),
    );
  }
}
