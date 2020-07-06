import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class TestByte extends StatefulWidget {
  @override
  _TestByteState createState() => _TestByteState();
}

class _TestByteState extends State<TestByte> {
String data;
List<String> dataInString;
Uint8List bytes;
bool gotImage = false;
Image picturing;
@override
void initState() {
    super.initState();
    this.getData();

}
dynamic picture;
  void getData()async{
      data = await  rootBundle.loadString("assets/images/data.txt");
  dataInString = data.split(" ");
  bytes = new Uint8List.fromList(dataInString.map((e) => int.parse(e)).toList());
  print("Done");
  setState(() {
    gotImage = true;
    picturing = Image.memory(bytes);
  });
  }
  @override
  Widget build(BuildContext context) {
    bool valueZZ;
        return Scaffold(
          body: Column(children: <Widget>[
            gotImage?picturing:Container(),
            Text("Hello World"),
            FloatingActionButton(onPressed: ()=>{
              print("${this.picturing.height} , ${this.picturing.width} ${this.picturing.toString()}"),
              valueZZ = img.JpegDecoder().isValidFile(this.bytes),
              if (valueZZ) {
                picture = img.JpegDecoder().decodeImage(this.bytes),
                print("OK JPEG")
              },
          // this.picture = img.decodeJpg(this.bytes),
          print("OK")
        })

      ],),
    );
  }
}