import 'package:Valerian/regconiction/regconiction.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class Detection extends StatefulWidget {
  @override
  _DetectionState createState() => _DetectionState();
}

class _DetectionState extends State<Detection> {

  Stream name;
  

  _DetectionState(){
  }
  @override
  Widget build(BuildContext context) {
      String path ="https://bizweb.dktcdn.net/100/372/934/articles/213567.jpg?v=1578476938763";

    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: FutureBuilder<List<dynamic>>(
                future: Recognition.objectDection_V1(path),
                builder: (BuildContext context,snap){
                  var data = convert.jsonDecode('[{"confidenceInClass": 0.79296875, "detectedClass": "laptop", "rect": {"y": 0.14302775263786316, "w": 0.7633607387542725, "x": 0.06884881854057312, "h": 0.8004286289215088}}]');
                  if (snap.data != null) {
                    print(snap.data);
                    return Column(
                      children: <Widget>[
                        Image.network(path),
                        SingleChildScrollView(
                          child: Container(
                            width: 200,
                            height: 200,
                            child: Text(snap.data[0]['detectedClass'] +": " + snap.data[0]['confidenceInClass'].toString(), style: TextStyle(
                              fontSize: 18
                            ),),
                          ),
                        )
                      ],
                      // color:Colors.blueAccent
                    );
                  }else{
                    return Container(color:Colors.black);
                  }
                }),
            ),
            FloatingActionButton(onPressed: ()=>{


            },
            child: Icon(Icons.camera),)
          ],
        ),
      ),
    );
  }
}