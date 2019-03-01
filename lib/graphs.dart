import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:ui';

var decodedJson;
class Temperature{
final String time;
final double value;
final charts.Color color;

Temperature(this.time, this.value, Color color)
      :this.color=new charts.Color(
        r: color.red, g: color.green, b:color.blue, a:color.alpha); 
}

class DisplayGraph extends StatefulWidget{
  _DisplayGraphState createState()=>new _DisplayGraphState();
}

class _DisplayGraphState extends State<DisplayGraph>{



Future fetchData() async{
http.Response response=await http.get(
'https://api.thingspeak.com/channels/648338/feeds.json?api_key=I7DRJEYHEPJ81REB&results=10'
);
if(response.statusCode==200){
  print('Successful');
  setState(() {
      decodedJson=json.decode(response.body);
    });
   print(decodedJson['feeds']);
   print(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][9]['created_at'])));
}
else{

}
}

void initState(){
  super.initState();
  fetchData();
}

@override
  Widget build(BuildContext context){
    var data=[
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][0]['created_at'])),double.parse(decodedJson['feeds'][9]['field1']),Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][1]['created_at'])), double.parse(decodedJson['feeds'][8]['field1']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][2]['created_at'])), double.parse(decodedJson['feeds'][7]['field1']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][3]['created_at'])), double.parse(decodedJson['feeds'][6]['field1']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][4]['created_at'])), double.parse(decodedJson['feeds'][5]['field1']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][5]['created_at'])), double.parse(decodedJson['feeds'][4]['field1']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][6]['created_at'])), double.parse(decodedJson['feeds'][3]['field1']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][7]['created_at'])), double.parse(decodedJson['feeds'][2]['field1']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][8]['created_at'])), double.parse(decodedJson['feeds'][1]['field1']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][9]['created_at'])), double.parse(decodedJson['feeds'][0]['field1']), Colors.blue),
    ];
   
   
   
   var series=[
     new charts.Series(
       domainFn: (Temperature temperature, _)=>temperature.time,
       measureFn: (Temperature temperature, _)=>temperature.value,
       colorFn: (Temperature temperature,_)=>temperature.color,
       id: 'Temperature',
       data: data
     )
   ];

   var chart=new charts.BarChart(
      series,
      animate: true,
   );
   var chartWidget=new Padding(
     padding: EdgeInsets.all(4.0),
     child: new SizedBox(
       height: 400.0,
       child: chart,
     ),
   );

      return new Scaffold(
        appBar: AppBar(
          title: new Text('Graphs'),
        ),
        body:decodedJson==null?Container(
        decoration: BoxDecoration(
            image: new DecorationImage(
                image: AssetImage(
                    'images/IMG-20190119-WA0004.jpg'),
                fit: BoxFit.cover)),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0,sigmaY: 10.0),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                child: new Center(
                 child: new CircularProgressIndicator(),
                ),
              ),
            ),
      ):
      Container(
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: ExactAssetImage('images/IMG-20190119-WA0004.jpg'),
            fit: BoxFit.cover
          ),
        ),
        child:new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child:  Container(
        decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
         child: ListView(
          children:[
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Center(child: new Text('Temperature Graph', style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold))),
            ),
          chartWidget,
          SizedBox(height: 8.0,),
          Padding(
              padding: const EdgeInsets.only(top:16.0),
              child: Center(child: new Text('Humidity Graph', style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold))),
            ),
            humidity(),
            SizedBox(height: 8.0,),
            Padding(
              padding: const EdgeInsets.only(top:16.0),
              child: Center(child: new Text('Light Intensity Graph', style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold))),
            ),
            lightintensity()
          ]
          ), 
      )
      )
      )
      );
  }
}

Widget humidity(){
 var data=[
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][0]['created_at'])),double.parse(decodedJson['feeds'][9]['field2']),Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][1]['created_at'])), double.parse(decodedJson['feeds'][8]['field2']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][2]['created_at'])), double.parse(decodedJson['feeds'][7]['field2']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][3]['created_at'])), double.parse(decodedJson['feeds'][6]['field2']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][4]['created_at'])), double.parse(decodedJson['feeds'][5]['field2']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][5]['created_at'])), double.parse(decodedJson['feeds'][4]['field2']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][6]['created_at'])), double.parse(decodedJson['feeds'][3]['field2']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][7]['created_at'])), double.parse(decodedJson['feeds'][2]['field2']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][8]['created_at'])), double.parse(decodedJson['feeds'][1]['field2']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][9]['created_at'])), double.parse(decodedJson['feeds'][0]['field2']), Colors.blue),
    ];
   

var series=[
     new charts.Series(
       domainFn: (Temperature temperature, _)=>temperature.time,
       measureFn: (Temperature temperature, _)=>temperature.value,
       colorFn: (Temperature temperature,_)=>temperature.color,
       id: 'Temperature',
       data: data
     )
   ];


var chart=new charts.BarChart(
      series,
      animate: true,
   );



  return new Padding(
     padding: EdgeInsets.all(4.0),
     child: new SizedBox(
       height: 400.0,
       child: chart,
     )
     );
}


Widget lightintensity(){
 var data=[
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][0]['created_at'])),double.parse(decodedJson['feeds'][9]['field3']),Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][1]['created_at'])), double.parse(decodedJson['feeds'][8]['field3']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][2]['created_at'])), double.parse(decodedJson['feeds'][7]['field3']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][3]['created_at'])), double.parse(decodedJson['feeds'][6]['field3']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][4]['created_at'])), double.parse(decodedJson['feeds'][5]['field3']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][5]['created_at'])), double.parse(decodedJson['feeds'][4]['field3']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][6]['created_at'])), double.parse(decodedJson['feeds'][3]['field3']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][7]['created_at'])), double.parse(decodedJson['feeds'][2]['field3']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][8]['created_at'])), double.parse(decodedJson['feeds'][1]['field3']), Colors.blue),
      Temperature(DateFormat('kk:mm').format(DateTime.parse(decodedJson['feeds'][9]['created_at'])), double.parse(decodedJson['feeds'][0]['field3']), Colors.blue),
    ];
   

var series=[
     new charts.Series(
       domainFn: (Temperature temperature, _)=>temperature.time,
       measureFn: (Temperature temperature, _)=>temperature.value,
       colorFn: (Temperature temperature,_)=>temperature.color,
       id: 'Temperature',
       data: data
     )
   ];


var chart=new charts.BarChart(
      series,
      animate: true,
   );



  return new Padding(
     padding: EdgeInsets.all(4.0),
     child: new SizedBox(
       height: 400.0,
       child: chart,
     )
     );
}