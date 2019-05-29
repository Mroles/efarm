import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'main.dart';

var decodedJson;
var decodedJson2;
var decodedJson3;

class Temperature {
  final String time;
  final double value;
  final charts.Color color;

  Temperature(this.time, this.value, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class DisplayGraph extends StatefulWidget {
  _DisplayGraphState createState() => new _DisplayGraphState();
}

class _DisplayGraphState extends State<DisplayGraph> {
  Future fetchTemperatureData() async {
    http.Response response = await http.get(
        'https://io.adafruit.com/api/v2/fawkes/feeds/temperature/data?X-AIO-Key=00d81e41b14145bb98463f14ae3e580b&limit=10');
    if (response.statusCode == 200) {
      print('Successful');
      setState(() {
        decodedJson = json.decode(response.body);
      });
      print(decodedJson);
      print(DateFormat('kk:mm')
          .format(DateTime.parse(decodedJson[9]['created_at'])));
    } else {}
  }

  Future fetchHumidityData() async {
    http.Response response = await http.get(
        'https://io.adafruit.com/api/v2/fawkes/feeds/humidity/data?X-AIO-Key=00d81e41b14145bb98463f14ae3e580b&limit=10');
    if (response.statusCode == 200) {
      print('Successful');
      setState(() {
        decodedJson2 = json.decode(response.body);
      });
      print(decodedJson2);
      print(DateFormat('kk:mm')
          .format(DateTime.parse(decodedJson[9]['created_at'])));
    } else {}
  }

  Future fetchLightData() async {
    http.Response response = await http.get(
        'https://io.adafruit.com/api/v2/fawkes/feeds/lightintensity/data?X-AIO-Key=00d81e41b14145bb98463f14ae3e580b&limit=10');
    if (response.statusCode == 200) {
      print('Successful');
      // setState(() {
      decodedJson3 = json.decode(response.body);
      //  });
      print(decodedJson3);
      print(DateFormat('kk:mm')
          .format(DateTime.parse(decodedJson[0]['created_at'])));
    } else {}
  }

  void initState() {
    super.initState();
    fetchHumidityData();
    fetchLightData();
    fetchTemperatureData();
  }

  @override
  Widget build(BuildContext context) {
    final data = [
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson[0]['created_at'])),
          double.parse(decodedJson[0]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson[1]['created_at'])),
          double.parse(decodedJson[1]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson[2]['created_at'])),
          double.parse(decodedJson[2]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson[3]['created_at'])),
          double.parse(decodedJson[3]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson[4]['created_at'])),
          double.parse(decodedJson[4]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson[5]['created_at'])),
          double.parse(decodedJson[5]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson[6]['created_at'])),
          double.parse(decodedJson[6]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson[7]['created_at'])),
          double.parse(decodedJson[7]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson[8]['created_at'])),
          double.parse(decodedJson[8]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson[9]['created_at'])),
          double.parse(decodedJson[9]['value']),
          Colors.blue),
    ];

    var series = [
      new charts.Series(
          domainFn: (Temperature temperature, _) => temperature.time,
          measureFn: (Temperature temperature, _) => temperature.value,
          colorFn: (Temperature temperature, _) => temperature.color,
          id: 'Temperature',
          data: data)
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
    );
    var chartWidget = new Padding(
      padding: EdgeInsets.all(4.0),
      child: new SizedBox(
        height: 400.0,
        child: chart,
      ),
    );

    return new Scaffold(
        appBar: AppBar(
          title: new Text('Graphs'),
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
        body: decodedJson == null
            ? Container(
                decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: AssetImage('images/IMG-20190119-WA0004.jpg'),
                        fit: BoxFit.cover)),
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: new Container(
                    decoration:
                        new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    child: new Center(
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  image: new DecorationImage(
                      image: ExactAssetImage('images/IMG-20190119-WA0004.jpg'),
                      fit: BoxFit.cover),
                ),
                child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: new BoxDecoration(
                          color: Colors.white.withOpacity(0.0)),
                      child: ListView(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Center(
                              child: new Text('Temperature Graph',
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold))),
                        ),
                        chartWidget,
                        SizedBox(
                          height: 8.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Center(
                              child: new Text('Humidity Graph',
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold))),
                        ),
                        humidity(),
                        SizedBox(
                          height: 8.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Center(
                              child: new Text('Light Intensity Graph',
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold))),
                        ),
                        lightintensity()
                      ]),
                    ))));
  }

  Widget humidity() {
    final data = [
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson2[0]['created_at'])),
          double.parse(decodedJson2[0]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson2[1]['created_at'])),
          double.parse(decodedJson2[1]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson2[2]['created_at'])),
          double.parse(decodedJson2[2]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson2[3]['created_at'])),
          double.parse(decodedJson2[3]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson2[4]['created_at'])),
          double.parse(decodedJson2[4]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson2[5]['created_at'])),
          double.parse(decodedJson2[5]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson2[6]['created_at'])),
          double.parse(decodedJson2[6]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson2[7]['created_at'])),
          double.parse(decodedJson2[7]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson2[8]['created_at'])),
          double.parse(decodedJson2[8]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson2[9]['created_at'])),
          double.parse(decodedJson2[9]['value']),
          Colors.blue),
    ];

    var series = [
      new charts.Series(
          domainFn: (Temperature temperature, _) => temperature.time,
          measureFn: (Temperature temperature, _) => temperature.value,
          colorFn: (Temperature temperature, _) => temperature.color,
          id: 'Temperature',
          data: data)
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
    );

    return new Padding(
        padding: EdgeInsets.all(4.0),
        child: new SizedBox(
          height: 400.0,
          child: chart,
        ));
  }

  Widget lightintensity() {
    final data = [
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson3[0]['created_at'])),
          double.parse(decodedJson3[0]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson3[1]['created_at'])),
          double.parse(decodedJson3[1]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson3[2]['created_at'])),
          double.parse(decodedJson3[2]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson3[3]['created_at'])),
          double.parse(decodedJson3[3]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson3[4]['created_at'])),
          double.parse(decodedJson3[4]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson3[5]['created_at'])),
          double.parse(decodedJson3[5]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson3[6]['created_at'])),
          double.parse(decodedJson3[6]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson3[7]['created_at'])),
          double.parse(decodedJson3[7]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson3[8]['created_at'])),
          double.parse(decodedJson3[8]['value']),
          Colors.blue),
      Temperature(
          DateFormat('kk:mm')
              .format(DateTime.parse(decodedJson3[9]['created_at'])),
          double.parse(decodedJson3[9]['value']),
          Colors.blue),
    ];

    var series = [
      new charts.Series(
          domainFn: (Temperature temperature, _) => temperature.time,
          measureFn: (Temperature temperature, _) => temperature.value,
          colorFn: (Temperature temperature, _) => temperature.color,
          id: 'Temperature',
          data: data)
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
    );

    return new Padding(
        padding: EdgeInsets.all(4.0),
        child: new SizedBox(height: 400.0, child: chart));
  }
}
