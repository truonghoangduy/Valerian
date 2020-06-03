import 'package:Valerian/regconiction/regconiction.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class Detection extends StatefulWidget {
  @override
  _DetectionState createState() => _DetectionState();
}

class _DetectionState extends State<Detection> {
  Stream name;
  // Image;

  _DetectionState() {}
  @override
  Widget build(BuildContext context) {
    String path = 
    "";

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: FutureBuilder<List<dynamic>>(
                  future: Recognition.objectDection_V1(path),
                  builder: (BuildContext context, snap) {
                    if (snap.data != null) {
                      print(snap.data);
                      return Column(
                        children: <Widget>[
                          // Image.network(path),
                          Image.memory(Recognition.temper),

                          Container(
                            width: 200,
                            height: 200,
                            child: Text(
                              snap.data[0]['detectedClass'] +
                                  ": " +
                                  snap.data[0]['confidenceInClass'].toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                        // color:Colors.blueAccent
                      );
                    } else {
                      return Container(color: Colors.black);
                    }
                  }),
            ),
            FloatingActionButton(
              onPressed: () => {setState(() {})},
              child: Icon(Icons.camera),
            ),
          ],
        ),
      ),
    );
  }
}
