import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:socialoo/layouts/user/login.dart';
import 'package:socialoo/layouts/widgets/bezier_container.dart';
import 'package:socialoo/layouts/widgets/bezier_containernew.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  // void navigationPage() {
  //   Navigator.of(context).pushReplacementNamed(APP_SCREEN);
  // }

  void navigationPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 4));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();

    // new Timer(new Duration(milliseconds: 3000), () {
    //   checkFirstSeen();
    // });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Missing Person Helpline',
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1e3c72),
        ),
      ),
    );
  }

  Widget _logoWidget() {
    return Column(
      children: <Widget>[
        Container(
          child: Center(
            child: Stack(children: <Widget>[
              Image.asset(
                'assets/images/appicon.png',
                width: 100.0,
                height: 100.0,
              ),
            ]),
          ),
          width: double.infinity,
          margin: const EdgeInsets.all(20.0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer(),
            ),
            Positioned(
              bottom: -MediaQuery.of(context).size.height * .15,
              left: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainernew(),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _title(),
                    _logoWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    // Username(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Container(
      //   color: Colors.black,
      //   height: SizeConfig.screenHeight,
      //   width: SizeConfig.screenWidth,
      //   child: Stack(
      //     alignment: Alignment.center,
      //     children: <Widget>[
      //       Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Image.asset(
      //             'assets/images/socialooIcon.png',
      //             height: 100,
      //             width: 100,
      //           ),
      //           SizedBox(
      //             height: 10,
      //           ),
      //           Text('Missing Person Helpline',
      //               style: TextStyle(
      //                   color: Colors.white,
      //                   fontFamily: 'BrushScript',
      //                   fontSize: SizeConfig.blockSizeHorizontal * 12.5)),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
