import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_path/value/color_app.dart';
import 'package:pet_path/value/img_app.dart';
import 'package:pet_path/value/route_app.dart';

class SplashPage extends StatefulWidget{

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: ColorApp.primary,
        body: Center(
            child: SplashBanner(
              onAnimCompleted: (){
                Future.delayed(Duration(milliseconds: 300), (){
                  Navigator.of(context).pushReplacementNamed(RouteApp.login);
                });
              },
            )
        )
    );
  }
}

class SplashBanner extends StatefulWidget{

  final Function onAnimCompleted;

  SplashBanner({this.onAnimCompleted});

  @override
  _SplashBannerState createState() => _SplashBannerState();

}

class _SplashBannerState extends State<SplashBanner> with SingleTickerProviderStateMixin{

  AnimationController _controller;
  Animation<double> _widthAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    _widthAnim = Tween<double>(begin: 0.2, end: 1.0).animate(CurvedAnimation(curve: Curves.easeInOut, parent: _controller));
    _widthAnim.addStatusListener((AnimationStatus status){
      if(status == AnimationStatus.completed){
        if(widget.onAnimCompleted != null)
          widget.onAnimCompleted();
      }
    });

    _controller.addListener((){
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.3;
    final banner = Image.asset(ImgApp.logo, width: width * _widthAnim.value);

    return banner;
  }
}