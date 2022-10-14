import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';
import 'package:fortloom/presentation/widgets/sideBar/navigationBloc.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/core/framework/colors.dart';

import '../chat/chat.dart';

class HomeScreen extends StatefulWidget with NavigationStates {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Container(
          alignment: Alignment.center,
          child: Image.asset('assets/imgs/logo.png',
              height: ScreenWH(context).height * 0.1,
              width: ScreenWH(context).width * 0.25),
        ),
        backgroundColor: background1,
      ),
      body: Center(
          child: Text('Welcome to Fortlom')
      ),
      floatingActionButton:FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Chat())
          );
        },
        child: const Icon(
          Icons.adb,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
