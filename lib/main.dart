import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http.get('http://192.168.2.140/');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final String controle;
  final int temperatura;
  final int humidade;

  Album({this.controle, this.temperatura, this.humidade});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      controle: json['controle'],
      temperatura: json['temperatura'],
      humidade: json['humidade'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    //futureAlbum = fetchAlbum();
  }

  void didChangeDependencies() {
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 80.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.filter_drama,
                  color: Colors.black,
                  size: 130.0,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'T E M P E R A T U R A',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ), //temp text
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: FutureBuilder<Album>(
                    future: futureAlbum,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text.rich(
                          TextSpan(
                            text: snapshot.data.temperatura.toString(),
                            style: TextStyle(
                              fontSize: 70.0,
                              fontWeight: FontWeight.w300,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'º',
                                style: TextStyle(
                                  fontSize: 70.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        //return Text("${snapshot.error}");
                        return Column(
                          children: <Widget>[
                            Icon(
                              Icons.error_outline,
                              color: Colors.black,
                              size: 50.0,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text("Sem conexão com o servidor"),
                          ],
                        );
                      }

                      // By default, show a loading spinner.
                      return CircularProgressIndicator();
                    },
                  ),
                ), //temp
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'H U M I D A D E',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ), //hum text
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: FutureBuilder<Album>(
                    future: futureAlbum,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text.rich(
                          TextSpan(
                            text: snapshot.data.humidade.toString(),
                            style: TextStyle(
                              fontSize: 70.0,
                              fontWeight: FontWeight.w300,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' %',
                                style: TextStyle(
                                  fontSize: 70.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        //return Text("${snapshot.error}");
                        return Column(
                          children: <Widget>[
                            Icon(
                              Icons.error_outline,
                              color: Colors.black,
                              size: 50.0,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text("Sem conexão com o servidor"),
                          ],
                        );
                      }

                      // By default, show a loading spinner.
                      return CircularProgressIndicator();
                    },
                  ),
                ), //hum
                SizedBox(
                  height: 60.0,
                ),
                Container(
                  width: double.infinity,
                  child: OutlineButton(
                    onPressed: () {
                      setState(() {
                        http.get('http://192.168.2.140/controle');
                        futureAlbum = fetchAlbum();
                      });
                    },
                    padding: EdgeInsets.all(15.0),
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Colors.black,
                    child: Text(
                      'ACIONAR PORTÃO',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1.5,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ), //btn
              ],
            ),
          ),
        ),
      ),
    );
  }
}
