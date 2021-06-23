import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:pet_path/app_config.dart';
import 'package:pet_path/value/color_app.dart';
import 'package:pet_path/value/img_app.dart';

import 'home_page.dart';

class LoginRegisterPage extends StatefulWidget{

  final bool isRegister;

  LoginRegisterPage({
    this.isRegister = false
  });

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState(isRegister);
}

class _LoginRegisterPageState extends State<LoginRegisterPage>{

  final loginEc = TextEditingController();
  final passwordEc = TextEditingController();
  bool isRegister;
  var isLoading = false;

  _LoginRegisterPageState(bool isRegister){
    this.isRegister = isRegister;
  }

  Future<void> _showMyDialog(String title, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorApp.primary,
        body: Center(
          child: Container(
            padding: EdgeInsets.only(top: 70.0, left: 20.0, right: 20.0),
            child: Column(
              children: [
              Image.asset(ImgApp.logo, width: MediaQuery.of(context).size.width * 0.18),
               !isLoading ? Container(
                 padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
                 child: Column(
                   children: [
                     Container(
                       margin: EdgeInsets.only(bottom: 20.0),
                       child: TextField(
                         controller: loginEc,
                         style: TextStyle(
                             color: Colors.black,
                         ),
                         decoration: InputDecoration(
                           hintStyle: TextStyle(color: ColorApp.black[26]),
                           enabledBorder: UnderlineInputBorder(
                             borderSide: BorderSide(color: ColorApp.black[26]),
                           ),
                           border: UnderlineInputBorder(),
                           hintText: 'Login',
                         ),
                       ),
                     ),
                     TextField(
                       controller: passwordEc,
                       style: TextStyle(
                         color: Colors.black,
                       ),
                       obscureText: true,
                       decoration: InputDecoration(
                           hintStyle: TextStyle(color: ColorApp.black[26]),
                           enabledBorder: UnderlineInputBorder(
                             borderSide: BorderSide(color: ColorApp.black[26]),
                           ),
                           border: UnderlineInputBorder(),
                           hintText: 'Senha'
                       ),
                     )
                   ],
                 ),
               ): Container(margin: EdgeInsets.only(top: 50), child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator())),
                !isLoading ? Container(
                  width: 200,
                  margin: EdgeInsets.only(top: 20.0),
                  child:             TextButton(
                    onPressed: (){
                      setState(() {
                        isLoading = true;
                      });
                      if(loginEc.text.trim().isEmpty || passwordEc.text.trim().isEmpty) {
                        _showMyDialog("Aviso", "Alguns dados estão em brancos");
                      }
                      else {
                        if(isRegister){
                          register();
                        }
                        else{
                          login();
                        }
                        //Navigator.pushReplacementNamed(context, RouteApp.home);
                      }
                    }, child: Text(isRegister ? "REGISTRAR" : "ENTRAR"),
                    style: TextButton.styleFrom(
                        primary: ColorApp.white,
                        backgroundColor: ColorApp.blue
                    ),
                  ),
                ) : Container(),
                !isLoading ? InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: (){
                    setState(() {
                      isRegister = !isRegister;
                    });
                  },
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Text(
                        isRegister ? "Entrar" : "Registrar",
                        style: TextStyle(
                          color: ColorApp.black[54],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                ) : Container()
            ],
            ),
          ),
        )
    );
  }

  login() async {
    final login = loginEc.text;
    final password = passwordEc.text;
    var url = Uri.parse('${AppConfig.url}login');
    var response = await http.post(url, headers: {"Content-Type": "application/json"}, body:  json.encode({'user': login, 'password': password}));
    var body = json.decode(response.body);

    setState(() {
      isLoading = false;
    });

    if(body['status'] == true){
      //AppConfig.userNameLogged = login;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userName: login)),
      );
    }
    else{
      _showMyDialog("Login", body['message']);
    }
  }

  register() async {
    final login = loginEc.text;
    final password = passwordEc.text;
    var url = Uri.parse('${AppConfig.url}register');
    var response = await http.post(url, headers: {"Content-Type": "application/json"}, body:  json.encode({'user': login, 'password': password}));
    var body = json.decode(response.body);

    setState(() {
      isLoading = false;
    });

    if(body['status'] == true){
      _showMyDialog("Registro", "Usuário registrado com sucesso!");
      setState(() {
        isRegister = false;
      });
    }
    else{
      _showMyDialog("Registro", body['message']);
    }
  }
}