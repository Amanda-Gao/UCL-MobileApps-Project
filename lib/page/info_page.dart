import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_path/value/color_app.dart';

class InfoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage>{
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.5));

    return Scaffold(
      backgroundColor: Color(0xFF323232),
      appBar: AppBar(
        title: Text("Sobre", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF323232),
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.white
        )
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Text(
                "Aplicativo que permite a visualização e postagem de informações relevantes sobre animais, como por exemplo animais perdidos e encontrados, juntamente com sua localidade e condição.",
                textAlign: TextAlign.center,
                style: style,
              ),
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Amanda Gomes Alvarenga", style: style),
                    Text("André de Almeida Lopes de Souza", style: style),
                    Text("Edney de Oliveira Silva Filho Filho", style: style),
                    Text("Helder William Jager", style: style)
                  ],
                ),
              ),
                Text("UCL 2021/1", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      )
    );
  }
}