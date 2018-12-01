import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'youtube_channel.dart';
import 'dart:convert';
import 'dart:async';


void main() => runApp(MyApp());

final color = const Color(0xFF302F2F);
final lightDarkGrey = const Color(0xFF4B4A4A);

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PewDiePie VS T-Series',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final oneSec = const Duration(seconds: 1);
  Channel channelP;
  Channel channelT;
  bool onGoingRequest=false;
  bool isDataAvailable=false;

  void fetchPost() async {
    onGoingRequest=true;
    final responseP = await http.get(
        'https://www.googleapis.com/youtube/v3/channels/?part=snippet%2CcontentDetails%2Cstatistics%20&forUsername=PewDiePie&key=<YOUR_API_KEY>');
    final responseT = await http.get('https://www.googleapis.com/youtube/v3/channels/?part=snippet%2CcontentDetails%2Cstatistics%20&forUsername=tseries&key=<YOUR_API_KEY>');
    if (responseP.statusCode == 200 && responseT.statusCode == 200) {
      setState(() {
        channelP = Channel.fromJSON(json.decode(responseP.body));
        channelT = Channel.fromJSON(json.decode(responseT.body));
        isDataAvailable=true;
        onGoingRequest=false;       
      }); 
    } else {
      throw Exception('Failed to load channel data.');
    }
  }

  @override
    void initState() {
      // TODO: implement initState
      fetchPost();
      Timer.periodic(oneSec, (Timer t){
        fetchPost();
      });
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightDarkGrey,
      appBar: AppBar(
        title: Text('PewDiePie VS T-Series'),
        backgroundColor: color,
      ),
      body: Center(
        child: isDataAvailable ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    child: Image.network(channelP.imgUrl,width: 100,height: 100,),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  Padding(
                    child: Text('${channelP.name}',style: TextStyle(color: Colors.white,fontFamily: 'GT',fontSize: 25.0)),
                    padding: EdgeInsets.only(top:20.0,bottom: 20.0),
                  ),
                  Text('Subscriber Count : ${channelP.subCount}',style: TextStyle(color: Colors.white,fontFamily: 'GT',fontSize: 20.0)),
                  Padding(
                    child: Text('VS',style: TextStyle(color: Colors.blue,fontFamily: 'GT',fontSize: 40.0)),
                    padding: EdgeInsets.all(30.0),
                  ),
                  ClipRRect(
                    child: Image.network(channelT.imgUrl,width: 100,height: 100,),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  Padding(
                    child: Text('${channelT.name}',style: TextStyle(color: Colors.white,fontFamily: 'GT',fontSize: 25.0)),
                    padding: EdgeInsets.only(top:20.0,bottom: 20.0),
                  ),
                  Text('Subscriber Count : ${channelT.subCount}',style: TextStyle(color: Colors.white,fontFamily: 'GT',fontSize: 20.0)),
                ],
              ) : CircularProgressIndicator(),
      ),
    );
  }
}
