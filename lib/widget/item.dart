import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_path/page/pet_page.dart';
import 'package:pet_path/value/img_app.dart';

class Item extends StatefulWidget{

  Item({this.img, this.check = false});

  final Image img;
  final bool check;

  @override
  State<StatefulWidget> createState() => _ItemState();
}

class _ItemState extends State<Item>{

  bool _check;

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
                  child: Icon(Icons.verified_user, color: Colors.white)
              ) : Container()
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PetPage(
            name: "Meu Pet",
            img: Image.asset(ImgApp.dog),
            check: true,
            description: "Meu animal",
            location: "Maringá",
          )),
        );
      },
      onDoubleTap: (){
        setState(() {
          _check = !_check;
        });
      }
    );
  }
}