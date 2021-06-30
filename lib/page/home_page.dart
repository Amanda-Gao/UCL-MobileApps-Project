import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pet_path/page/info_page.dart';
import 'package:pet_path/value/color_app.dart';
import 'package:pet_path/value/img_app.dart';
import 'package:pet_path/widget/item.dart';
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
  List<Item> posts;
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
    getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
        key: scaffoldState,
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorApp.primary,
        body:
        Container(
          padding: EdgeInsets.only(top: statusBarHeight),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Color(0xFF323232),
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Image.asset(ImgApp.logo, height: 40),
                    SizedBox(width: 10),
                    Expanded(child: Text("Pet Path", style: TextStyle(color: Colors.white, fontSize: 16))),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: new CircleBorder(),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.info, color: Colors.white),
                        ),
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => InfoPage()),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: getPosts,
                  child: posts != null ? GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    padding: EdgeInsets.zero,
                    children: List.generate(posts.length > 0 ? posts.length : 1, (index) {
                      return posts.length > 0 ? posts[index] : Container(
                        padding: EdgeInsets.only(top: 20),
                          child: Text(
                              "Nenhum animal encontrado!",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, color: ColorApp.black[26])
                          )
                      );
                    }),
                  ) : Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator())),
                )
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

  Future getPosts() async {
    var url = Uri.parse('${AppConfig.url}feed');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});

    List body = json.decode(response.body);
    posts = [];
    setState(() {
      for(var post in body){
        posts.add(new Item(id: post["id"], img: Image.memory(base64Decode(post["image"]), fit: BoxFit.cover), user: post["user"], check: post["checked"] == 1 ? true : false, animalName: post['animal_name'], description: post['description'], location: post['location']));
      }
    });
  }

  Future postImage(base64) async {
    var url = Uri.parse('${AppConfig.url}post');
    var response = await http.post(url, headers: {"Content-Type": "application/json"}, body:  json.encode({'user': AppConfig.user, 'image': base64, 'animal_name': c1.text, 'description': c2.text, 'location': c3.text, 'timestamp': DateTime.now().millisecondsSinceEpoch}));
    var body = json.decode(response.body);

    await getPosts();
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

  void _uploadImage(context, base64){
    final width = MediaQuery.of(context).size.width * 0.3;

    sad = false;
    happy = true;
    _controller = scaffoldState.currentState.showBottomSheet(
        BottomSheet(
          elevation: 12,
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
                            if(!isUploading){
                              _controller.setState(() {
                                isUploading = true;
                              });
                              postImage(base64).then((_){
                                _controller.setState(() {
                                  isUploading = false;
                                });
                                _controller.close();
                              });
                            }
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
