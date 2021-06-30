import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PetPage extends StatefulWidget{

  PetPage({
    @required this.name,
    @required this.img,
    @required this.check,
    @required this.description,
    @required this.location
  });

  final String name;
  final Image img;
  final bool check;
  final String description;
  final String location;

  @override
  State<StatefulWidget> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage>{
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.5));

    return Scaffold(
        backgroundColor: Color(0xFF323232),
        appBar: AppBar(
            title: Text(widget.name, style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFF323232),
            brightness: Brightness.dark,
            iconTheme: IconThemeData(
                color: Colors.white
            )
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            margin: EdgeInsets.only(top: 5),
            child: Column(
              children: [
                widget.img,
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(widget.check ? "Verificado" : "Não verificado", style: TextStyle(color: Colors.white, fontSize: 16)),
                    SizedBox(width: 5),
                    Icon(Icons.verified_user, color: Colors.white)
                  ],
                ),
                SizedBox(height: 20),
                Text(widget.description),
                Text(widget.location)
              ],
            ),
          ),
        )
    );
  }
}