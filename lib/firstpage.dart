import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'graphs.dart';
import 'dart:ui';
//import 'package:mqtt_client/mqtt_client.dart';
import 'firsttabpublish.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class Item {
  final String value;

  Item(this.value);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json['last_value']);
  }
}

class FirstPage extends StatefulWidget {
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    // FirstTab(),
    //BFirstPage(),
    // FirstTabPublish(),
    FutureBuild(),
    SecondTab(),
    ThirdTab(),
    DisplayGraph()
  ];

  void onTabTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTap,
          items: [
            BottomNavigationBarItem(
                icon: new Icon(
                  Icons.list,
                  color: Colors.green,
                ),
                title: new Text(
                  'Toggles',
                  style: TextStyle(color: Colors.green),
                )),
            BottomNavigationBarItem(
                icon: new Icon(Icons.brush, color: Colors.green),
                title: new Text('Customize',
                    style: TextStyle(color: Colors.green))),
            BottomNavigationBarItem(
                icon: new Icon(Icons.info_outline, color: Colors.green),
                title: new Text('System Info',
                    style: TextStyle(color: Colors.green))),
            BottomNavigationBarItem(
                icon: new Icon(Icons.show_chart, color: Colors.green),
                title:
                    new Text('Charts', style: TextStyle(color: Colors.green)))
          ]),
    );
  }
}

class SecondTab extends StatefulWidget {
  _SecondTabState createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {
  var alarmstaus;
  bool _isSwitched = false;

  Future<Item> _getAlarm() async {
    http.Response response =
        await http.get('https://io.adafruit.com/api/v2/fawkes/feeds/scheduler');

    if (response.statusCode == 200) {
      setState(() {
        alarmstaus = json.decode(response.body);
        setState(() {
          if (alarmstaus["last_value"] == 'true') {
            _isSwitched = true;
          } else {
            _isSwitched = false;
          }
        });
      });
    }
    print(alarmstaus['last_value']);
    return Item.fromJson(alarmstaus);
  }

  Future _postScheduler(String value) async {
    var object = {
      "datum": {"value": value}
    };
    http.Response response = await http.post(
        'https://io.adafruit.com/api/v2/fawkes/feeds/scheduler/data?X-aio-key=00d81e41b14145bb98463f14ae3e580b',
        body: json.encode(object),
        headers: {"Content-type": "application/json"});
    if (response.statusCode == 200) {
      print('Success');
    } else {
      print(response.statusCode);
    }
  }

  Future _postAlarm(String url, DateTime value) async {
    String val = formatDate(value, [HH, ':', nn, ':', ss]);
    print(val);
    var object = {
      "datum": {"value": val}
    };
    http.Response response = await http.post(url,
        body: json.encode(object),
        headers: {"Content-type": "application/json"});
    if (response.statusCode == 200) {
      print('Success');
    } else {
      print(response.statusCode);
    }
  }

  void initState() {
    super.initState();
    _getAlarm();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Customize'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
              signOut(context);
            },
          )
        ],
      ),
      body: Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new ExactAssetImage('images/IMG-20190119-WA0004.jpg'),
                fit: BoxFit.cover)),
        child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: new Container(
              decoration:
                  new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              child: Center(
                  child: Center(
                      child: alarmstaus == null
                          ? new Center(
                              child: CircularProgressIndicator(),
                            )
                          : new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ListTile(
                                    leading: new Icon(Icons.timer),
                                    title: new Text('Automatic Control',
                                        style: new TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold)),
                                    trailing: _isSwitched == true
                                        ? RaisedButton(
                                            child: new Text('Turn Off'),
                                            color: Colors.red,
                                            onPressed: () {
                                              setState(() {
                                                _isSwitched = false;
                                                _postScheduler('false');
                                              });
                                            },
                                          )
                                        : FlatButton(
                                            child: new Text('Turn On'),
                                            color: Colors.green,
                                            onPressed: () {
                                              setState(() {
                                                _isSwitched = true;
                                                _postScheduler('true');
                                              });
                                            },
                                          )),
                                new ListTile(
                                  leading: Icon(Icons.alarm),
                                  title: new Text(
                                    'Set Timer',
                                    style: new TextStyle(color: Colors.black),
                                  ),
                                  trailing: RaisedButton(
                                    color: Colors.green,
                                    child: Text('Set'),
                                    onPressed: () {
                                      DatePicker.showTimePicker(context,
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en,
                                          onChanged: (date) {
                                        print(date);
                                      }, onConfirm: (date) {
                                        _postAlarm(
                                            'https://io.adafruit.com/api/v2/fawkes/feeds/alarmone/data?X-aio-key=00d81e41b14145bb98463f14ae3e580b',
                                            date);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )))),
        ),
      ),
    );
  }
}

class ThirdTab extends StatefulWidget {
  _ThirdTabState createState() => _ThirdTabState();
}

class _ThirdTabState extends State<ThirdTab> {
  var jsonResponse;
  // Duration _timerDuration=new Duration(seconds: 1);

  Future fetchData() async {
    http.Response response = await http.get(
        'https://io.adafruit.com/api/v2/fawkes/groups?X-AIO-Key=00d81e41b14145bb98463f14ae3e580b');
    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = json.decode(response.body);
      });

      print(jsonResponse[0]["feeds"][4]["last_value"]);
    } else {
      print('Failed to Load Vitals');
    }
  }

  void initState() {
    super.initState();
    fetchData();
  }

//4 humidity
//5light
//9 temp
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Vitals'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  fetchData();
                }),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
                signOut(context);
              },
            )
          ],
        ),
        body: Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new ExactAssetImage('images/IMG-20190119-WA0004.jpg'),
                  fit: BoxFit.cover),
            ),
            child: new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration:
                      new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  child: jsonResponse == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.whatshot,
                                color: Colors.red,
                              ),
                              title: new Text(
                                'Temperature',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: new Text(
                                  jsonResponse[0]["feeds"][9]["last_value"]),
                            ),
                            ListTile(
                              leading:
                                  Icon(Icons.bubble_chart, color: Colors.blue),
                              title: new Text('Humidity',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              trailing: new Text(
                                  jsonResponse[0]["feeds"][4]["last_value"]),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.lightbulb_outline,
                                color: Colors.white,
                              ),
                              title: new Text(
                                'Light Intensity',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: new Text(
                                  jsonResponse[0]["feeds"][5]["last_value"]),
                            ),
                          ],
                        ),
                ))));
  }
}

class BFirstPage extends StatefulWidget {
  _BFirstPageState createState() => _BFirstPageState();
}

class _BFirstPageState extends State<BFirstPage> {
  bool _lightvalue = false;
  bool _watervalue = false;

  var jsonLightResponse;
  var jsonWaterResponse;

  Future fetchData() async {
    http.Response response = await http.get(
        'https://api.thingspeak.com/channels/652166/feeds.json?api_key=OGZF4W77UDB1E3C2&results=1');
    if (response.statusCode == 200) {
      setState(() {
        jsonLightResponse = json.decode(response.body);
        if (jsonLightResponse['feeds'][0]['field1'] == '0') {
          _lightvalue = false;
        } else {
          _lightvalue = true;
        }

        print(_lightvalue);
        //print(_lightvalue);
      });
    } else {
      print('Failed to Load Vitals');
    }
  }

  Future fetchOtherData() async {
    http.Response response = await http.get(
        'https://api.thingspeak.com/channels/652168/feeds.json?api_key=JWRNSKHONATSSBNP&results=1');
    if (response.statusCode == 200) {
      setState(() {
        jsonWaterResponse = json.decode(response.body);
        if (jsonWaterResponse['feeds'][0]['field1'] == '0') {
          _watervalue = false;
        } else {
          _watervalue = true;
        }

        print(_watervalue);
        //print(_lightvalue);
      });
    } else {
      print('Failed to Load Vitals');
    }
  }

  Future toggleLight(int value) async {
    http.Response response = await http.get(
        'https://api.thingspeak.com/update?api_key=GUGXZQOXSDGKMUBC&field1=' +
            value.toString());
    if (response.statusCode == 200) {
      print('Successful');
    } else {
      print('failed');
    }
  }

  Future toggleWater(int value) async {
    http.Response response = await http.get(
        'https://api.thingspeak.com/update?api_key=CJE3YTO6RBA83WOZ&field1=' +
            value.toString());
    if (response.statusCode == 200) {
      print('Successful');
    } else {
      print('failed');
    }
  }

  void initState() {
    super.initState();
    fetchData();
    fetchOtherData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Toggles'),
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
                image: new ExactAssetImage('images/IMG-20190119-WA0004.jpg'),
                fit: BoxFit.cover),
          ),
          child: new BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration:
                  new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              padding: const EdgeInsets.all(12.0),
              child: jsonWaterResponse == null
                  ? new Center(
                      child: new CircularProgressIndicator(),
                    )
                  : new ListView(
                      children: <Widget>[
                        SizedBox(height: 32.0),
                        Center(
                            child: new Text('Light Control',
                                style: TextStyle(fontSize: 30.0))),
                        SizedBox(height: 12.0),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: _lightvalue == true
                                    ? Colors.red
                                    : Colors.green),
                            child: Center(
                                child: new Icon(Icons.power_settings_new,
                                    size: 50.0, color: Colors.white)),
                          ),
                          onTap: () {
                            _lightvalue == true
                                ? toggleLight(0)
                                : toggleLight(1);
                            setState(() {
                              _lightvalue == true
                                  ? _lightvalue = false
                                  : _lightvalue = true;
                            });
                          },
                        ),
                        new SizedBox(height: 70.0),
                        Center(
                            child: new Text(
                          'Water Control',
                          style: TextStyle(fontSize: 30.0),
                        )),
                        new SizedBox(height: 20.0),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
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
                                  ? toggleWater(0)
                                  : toggleWater(1);
                              _watervalue == true
                                  ? _watervalue = false
                                  : _watervalue = true;
                            });
                          },
                        ),
                      ],
                    ),
            ),
          ),
        ));
  }
}
