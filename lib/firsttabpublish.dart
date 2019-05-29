import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'main.dart';

class FirstTabPublish extends StatefulWidget {
  _FirstTabPublishState createState() => _FirstTabPublishState();
}

class _FirstTabPublishState extends State<FirstTabPublish> {
  //////////////
  ///
  ///MQTT functions
  ///
  //////////
  ///
  MqttClient client;
  String key = '00d81e41b14145bb98463f14ae3e580b';
  String broker = 'io.adafruit.com';

  bool _watervalue = false;
  var jsonResponse;
  bool _error = false;

  Future _post(String value) async {
    var object = {
      "datum": {"value": value}
    };

    http.Response response = await http.post(
        'https://io.adafruit.com/api/v2/fawkes/feeds/pump/data?X-aio-key=00d81e41b14145bb98463f14ae3e580b',
        body: json.encode(object),
        headers: {"Content-type": "application/json"});
    if (response.statusCode == 200) {
      print('Success');
    } else {
      print(response.statusCode);
    }
  }

  Future _getData() async {
    try {
      http.Response response = await http
          .get('https://io.adafruit.com/api/v2/fawkes/feeds/pumpstatus');
      if (response.statusCode == 200) {
        setState(() {
          jsonResponse = json.decode(response.body);
          print(jsonResponse["last_value"]);
          if (jsonResponse["last_value"] == '0') {
            _watervalue = false;
          } else {
            _watervalue = true;
          }
          _error = false;
        });
      }
    } on Exception {
      setState(() {
        jsonResponse = json.encode({});
        _error = true;
      });
    }
    print('Error var: $_error');
    print(jsonResponse);
  }

  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'Switches',
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                signOut(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            )
          ],
        ),
        body: jsonResponse == null
            ? new Container(
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new ExactAssetImage(
                            'images/IMG-20190119-WA0004.jpg'),
                        fit: BoxFit.cover)),
                child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: new Container(
                        decoration: new BoxDecoration(
                            color: Colors.white.withOpacity(0.0)),
                        child: new Center(
                          child: _error
                              ? new Text("Error Occured. Retry")
                              : new CircularProgressIndicator(),
                        ))))
            : new Container(
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new ExactAssetImage(
                            'images/IMG-20190119-WA0004.jpg'),
                        fit: BoxFit.cover)),
                child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: new Container(
                        decoration: new BoxDecoration(
                            color: Colors.white.withOpacity(0.0)),
                        child: new Center(
                          child: _error
                              ? new Text('Retry')
                              : new ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    Text(
                                      'Water Pump Switch',
                                      style: new TextStyle(
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(24.0),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        padding: EdgeInsets.all(24.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            color: _watervalue == true
                                                ? Colors.red
                                                : Colors.green),
                                        child: Center(
                                          child: new Icon(
                                            Icons.power_settings_new,
                                            size: 50.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _watervalue == true
                                              ? _post('0')
                                              : _post('1');
                                          _watervalue == true
                                              ? _watervalue = false
                                              : _watervalue = true;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                        )))));
  }
}

class Item {
  final String value;

  Item(this.value);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json['last_value']);
  }
}

class FutureBuild extends StatefulWidget {
  _FutureBuildState createState() => _FutureBuildState();
}

class _FutureBuildState extends State<FutureBuild> {
  bool _watervalue = false;
  var jsonResponse;
  bool _error = false;

  Future _post(String value) async {
    var object = {
      "datum": {"value": value}
    };

    http.Response response = await http.post(
        'https://io.adafruit.com/api/v2/fawkes/feeds/pump/data?X-aio-key=00d81e41b14145bb98463f14ae3e580b',
        body: json.encode(object),
        headers: {"Content-type": "application/json"});
    if (response.statusCode == 200) {
      print('Success');
    } else {
      print(response.statusCode);
    }
  }

  Future<Item> _getData() async {
    http.Response response = await http
        .get('https://io.adafruit.com/api/v2/fawkes/feeds/pumpstatus');
    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = json.decode(response.body);
        print(jsonResponse["last_value"]);
        if (jsonResponse["last_value"] == '0') {
          _watervalue = false;
        } else {
          _watervalue = true;
        }
        _error = false;
      });
    }
    print('Error var: $_error');
    print(jsonResponse);
    return Item.fromJson(jsonResponse);
  }

  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Water Pump Switch"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                signOut(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            )
          ],
        ),
        body: Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image:
                        new ExactAssetImage('images/IMG-20190119-WA0004.jpg'),
                    fit: BoxFit.cover)),
            child: new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: new Container(
                  decoration:
                      new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  child: Center(
                      child: jsonResponse == null
                          ? Center(child: CircularProgressIndicator())
                          : new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  new Text(
                                    'Water Pump Switch',
                                    style: TextStyle(
                                        fontSize: 28.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  new SizedBox(
                                    height: 8.0,
                                  ),
                                  new Container(
                                    child: Center(
                                      child: GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.all(24.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              color: _watervalue == true
                                                  ? Colors.red
                                                  : Colors.green),
                                          child: Center(
                                            child: new Icon(
                                              Icons.power_settings_new,
                                              size: 50.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _watervalue == true
                                                ? _post('0')
                                                : _post('1');
                                            _watervalue == true
                                                ? _watervalue = false
                                                : _watervalue = true;
                                          });
                                        },
                                      ),
                                    ),
                                  )
                                ])),
                ))));
  }
}
