import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_path/value/color_app.dart';
import 'package:pet_path/value/img_app.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';

class HomePage extends StatefulWidget{

  final String userName;

  HomePage({
    this.userName = "userName"
  });

  @override
  State<StatefulWidget> createState() => _HomePageState(userName);
}

class _HomePageState extends State<HomePage>{

  File _image;
  String userName;
  final scaffoldState = GlobalKey<ScaffoldState>();
  var hideFloatting = false;
  var happy = false;
  var sad = false;
  PersistentBottomSheetController _controller;
  List<String> posts;
  var isUploading = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  final c1 = TextEditingController();
  final c2 = TextEditingController();
  final c3 = TextEditingController();

  _HomePageState(final String userName){
    this.userName = userName;
  }

  @override
  void initState() {
    //getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldState,
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorApp.primary,
        body:
        Container(
          padding: EdgeInsets.only(top: 24.0),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                color: Color(0xFF323232),
                height: 60,
                child: Row(
                  children: [
                    Image.asset(ImgApp.logo, height: 40),
                    Text("Pet Path", style: TextStyle(color: ColorApp.white[54], fontSize: 12))
                  ],
                ),
              ),
              Expanded(
                child: /*posts != null && posts.length > 0 ? RefreshIndicator(
                  onRefresh: () {},
                  child: */GridView.count(
                  // Cria um grid com duas colunas
                  crossAxisCount: 2,
                  // Gera 100 Widgets que exibem o seu índice
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  padding: EdgeInsets.zero,

                  children: List.generate(10, (index) {
                    return Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 10,
                      child: Center(
                        child: Image.asset(ImgApp.dog,),
                      ),
                    );
                  }),
                ) /*: Center(child: posts == null ? SizedBox(width: 50, height: 50, child: CircularProgressIndicator()) : Container(child: Text("Nenhuma postagem encontrada!", style: TextStyle(fontSize: 18, color: ColorApp.white[26])))),*/
              )
            ],
          ),
        ),
        floatingActionButton: hideFloatting ? Container() : FloatingActionButton(
          onPressed: () {
            setState(() {
              hideFloatting = true;
            });
            getImage();
          },
          child: const Icon(Icons.cloud_upload_rounded, color: Colors.white),
          backgroundColor: Color(0xFF323232),
        )
    );
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 10,
        maxHeight: 1080,
        maxWidth: 1080
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        if(_image != null) {
          final bytes = _image.readAsBytesSync();
          String img64 = base64Encode(bytes);

          //print(img64);

          _uploadImage(context, img64);
        }
      }
      else{
        hideFloatting = false;
      }
    });
  }

  /*Future postImage(base64, feeling) async {
    var url = Uri.parse('${AppConfig.url}post');
    var response = await http.post(url, headers: {"Content-Type": "application/json"}, body:  json.encode({'user': userName, 'image64': base64, 'feeling': feeling}));
    var body = json.decode(response.body);

    await getPosts();
  }*/

  /*Future getPosts() async {
    var url = Uri.parse('${AppConfig.url}feed');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});
    //print(response.body.toString());
    List body = json.decode(response.body);
    posts = [];
    setState(() {
      for(var post in body){
        var format = new DateTime.fromMillisecondsSinceEpoch(post['timestamp'], isUtc: true);
        posts.add(new FeedItem(
          postId: post['id'],
          userName: post["user"],
          dateTime: format.toIso8601String(),
          image64: base64Decode(post["image64"]),
          feeling: post["feeling"],
          majority: post["majority_feeling"],
        ));
      }
    });
  }*/

  void _uploadImage(context, base64){
    final width = MediaQuery.of(context).size.width * 0.3;

    sad = false;
    happy = true;
    _controller = scaffoldState.currentState.showBottomSheet(
        BottomSheet(
            onClosing: (){},
            builder: (BuildContext context){
              return Container(
                height: 500,
                color: Color(0xFF323232),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: ColorApp.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16)
                      ),
                      margin: EdgeInsets.symmetric(vertical: 15),
                      width: 150,
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          isUploading ? Container(margin: EdgeInsets.only(top: 50), child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator())) : Image.file(_image, height: 150, filterQuality: FilterQuality.none),
                          Container(
                            margin: EdgeInsets.only(top: 30, bottom: 0),
                            child: !isUploading ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              ],
                            ) : Container(),
                          )
                        ],
                      ),
                    ),
                    TextField(
                      controller: c1,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: ColorApp.black[26]),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Nome'
                      ),
                    ),
                    TextField(
                      controller: c2,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: ColorApp.black[26]),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Descrição'
                      ),
                    ),
                    TextField(
                      controller: c3,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: ColorApp.black[26]),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Localização'
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        !isUploading ?
                        FloatingActionButton(
                          onPressed: () {
                            /*if(!isUploading){
                              _controller.setState(() {
                                isUploading = true;
                              });
                              postImage(base64, happy ? 1 : 2).then((_){
                                _controller.setState(() {
                                  isUploading = false;
                                });
                                _controller.close();
                              });
                            }*/
                            _controller.close();
                          },
                          child: const Icon(Icons.send, color: Color(0xFF323232)),
                          backgroundColor: Colors.white,
                        ) : Container()
                      ],
                    )
                  ],
                ),
              );
            }
        ).builder
    );
    _controller.closed.whenComplete((){
      print("Modal fechou!");
      setState(() {
        hideFloatting = false;
      });
    });
  }
}
