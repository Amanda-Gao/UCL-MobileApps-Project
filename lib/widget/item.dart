import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_path/app_config.dart';
import 'package:pet_path/page/pet_page.dart';
import 'package:http/http.dart' as http;

class Item extends StatefulWidget{

  Item({this.id, this.img, this.user, this.check, this.animalName, this.description, this.location});

  final int id;
  final Image img;
  final String user;
  final bool check;
  final String animalName;
  final String description;
  final String location;

  @override
  State<StatefulWidget> createState() => _ItemState();
}

class _ItemState extends State<Item>{

  bool _check;
  bool _isLoading = false;

  @override
  void initState() {
    _check = widget.check;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: 10,
        child: Center(
          child: Stack(
            children: [
              widget.img,
              _check ? Positioned(
                  bottom: 15,
                  right: 15,
                  child: _isLoading ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator()) : Icon(Icons.verified_user, color: Colors.white)
              ) : Container()
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PetPage(
            name: widget.animalName,
            img: widget.img,
            check: _check,
            description: widget.description,
            location: widget.location,
          )),
        );
      },
      onDoubleTap: (){
        _setCheck();
      }
    );
  }

  _setCheck(){
    print("user: ${AppConfig.user} | ${widget.user}");
    if(AppConfig.user == widget.user) {
      _isLoading = true;
      _postCheck(!_check);
    }
  }

  _postCheck(bool check) async {
    var url = Uri.parse('${AppConfig.url}check');
    print(json.encode({'id': widget.id, 'checked': check ? 1 : 0}));
    var response = await http.post(url, headers: {"Content-Type": "application/json"}, body:  json.encode({'id': widget.id, 'checked': check ? 1 : 0}));
    var body = json.decode(response.body);

    print(body);

    if(body['status'] == true){
      setState(() {
        _check = check;
      });
    }
    else{
      _showMyDialog("Falha", "Ao verificar animal");
    }

    _isLoading = false;
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
}