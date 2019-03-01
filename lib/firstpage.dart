import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'graphs.dart';
import 'dart:ui';

class FirstPage extends StatefulWidget {
  _FirstPageState createState() => _FirstPageState();
}


class _FirstPageState extends State<FirstPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    BFirstPage(),
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
                title: new Text('Charts',
                    style: TextStyle(color: Colors.green)))
          ]),
    );
  }
}
/*
class FirstTab extends StatefulWidget {
  _FirstTabState createState() => _FirstTabState();
}

class _FirstTabState extends State<FirstTab> {
 
  bool _watervalue = false;
  bool _lightvalue = false;
  bool _autovalue = false;

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

  void onWaterChanged(bool value) {
    setState(() {
      _watervalue = value;
    });
  }

  void onLightChanged(bool value) {
    setState(() {
      _lightvalue = value;
    });
  }

  void onAutoChanged(bool value) {
    setState(() {
      _autovalue = value;
    });
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              signOut();
              Navigator.popAndPushNamed(context, '/login');
            },
          )
        ],
      ),
      body: jsonLightResponse == null
          ? new Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'images/green-iceberg-lettuce-on-white-background_62856-328.jpg'),
                      fit: BoxFit.cover)),
              child: Center(child: new CircularProgressIndicator()))
          : new Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'images/green-iceberg-lettuce-on-white-background_62856-328.jpg'),
                      fit: BoxFit.cover)),
              child: new ListView(
                children: <Widget>[
                  new ListTile(
                    title: new Text('Automated Control'),
                    trailing: Switch(
                      value: _autovalue,
                      onChanged: (bool value) {
                        onAutoChanged(value);
                      },
                    ),
                  ),
                  new Center(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text('Specific Controls',
                            style: new TextStyle(fontSize: 24.0))
                      ],
                    ),
                  ),
                  new ListTile(
                    title: new Text('Automatic Water Pump Control'),
                    trailing: Switch(
                      value: _watervalue,
                      onChanged: (bool value) {
                        _watervalue == true ? toggleWater(0) : toggleWater(1);
                        onWaterChanged(value);
                      },
                    ),
                  ),
                  new ListTile(
                    title: new Text('Automatic Light Control'),
                    trailing: Switch(
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        _lightvalue == true ? toggleLight(0) : toggleLight(1);
                        onLightChanged(value);
                      },
                      value: _lightvalue,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
*/
class SecondTab extends StatefulWidget {
  _SecondTabState createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Customize'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              signOut(context);
              Navigator.popAndPushNamed(context, '/login');
            },
          )
        ],
      ),
      body: Container(
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
                 child: new Text('Nothing to show', style: TextStyle(fontWeight: FontWeight.w500),)
                ),
              ),
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

  Future<Null> fetchData() async {
    http.Response response = await http.get(
        'https://api.thingspeak.com/channels/648338/feeds.json?api_key=I7DRJEYHEPJ81REB&results=1');
    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = json.decode(response.body);
      });

      print(jsonResponse['feeds'][0]['field1']);
    } else {
      print('Failed to Load Vitals');
    } 
  }

  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('System Information'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed:(){ 
              fetchData();
            }
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              signOut(context);
              Navigator.popAndPushNamed(context, '/login');
            },
          )
        ],
      ),
      body: jsonResponse == null
          ? new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new ExactAssetImage('images/IMG-20190119-WA0004.jpg'),
                fit: BoxFit.cover
              )
            ),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                child: new Center(
                  child: new CircularProgressIndicator(),
                ),
              ),
            ),
          )
          : new Container(
              decoration: BoxDecoration(
                  image: new DecorationImage(
                image: ExactAssetImage(
                    'images/IMG-20190119-WA0004.jpg'),
                fit: BoxFit.cover,
              )
              ),
             
              child: BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                              child: 
    new Container(
      decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
          child: new ListView(
  
                      children: <Widget>[
  
                        new ListTile(
  
                          leading: new Icon(
  
                            Icons.whatshot,
  
                            color: Colors.orange[300],
  
                          ),
  
                          title: new Text('Temperature'),
  
                          trailing: new Text(jsonResponse['feeds'][0]['field1']),
  
                        ),
  
                        new ListTile(
  
                          leading:
  
                              new Icon(Icons.scatter_plot, color: Colors.blue[200]),
  
                          title: new Text('Humidity'),
  
                          trailing: new Text(jsonResponse['feeds'][0]['field2']),
  
                        ),
  
                        new ListTile(
  
                          leading: new Icon(Icons.wb_sunny, color: Colors.grey),
  
                          title: new Text('Light Intensity'),
  
                          trailing: new Text(jsonResponse['feeds'][0]['field3']),
  
                        ),
  
                        new SizedBox(
  
                          height: 12.0,
  
                        ),
  
                      ],
  
                    ),
    ),
              ),
            ),
    );
  }
}
class BFirstPage extends StatefulWidget
{
  _BFirstPageState createState()=> _BFirstPageState();
}


class _BFirstPageState extends State<BFirstPage>{

bool _lightvalue=false;
bool _watervalue=false;

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


  void initState(){
    super.initState();
    fetchData();
    fetchOtherData();
  }

  @override
  Widget build(BuildContext context){
      return new Scaffold(
          appBar: new AppBar(
            title: new Text('Toggles'),
          ),
          body: Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new ExactAssetImage('images/IMG-20190119-WA0004.jpg'),
                fit: BoxFit.cover
              ),
            ),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                padding: const EdgeInsets.all(12.0),
                child: jsonWaterResponse==null?new Center(child: new CircularProgressIndicator(),):new ListView(
                  children: <Widget>[
                    SizedBox(height: 32.0),
                    Center(child: new Text('Light Control', style: TextStyle(fontSize: 30.0))),
                    SizedBox(height: 12.0),
                  GestureDetector(
                                      child: Container(
                      padding: EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: _lightvalue==true?Colors.red:Colors.green
                      ),
                        child: Center(
                          child: new Icon(Icons.power_settings_new,size: 50.0, color:Colors.white)
                        ),
                    ),
                    onTap: (){
                      _lightvalue==true?toggleLight(0):toggleLight(1);
                       setState(() {
                                      _lightvalue==true?_lightvalue=false:_lightvalue=true;                
                                    });
                    },
                  ),
                  new SizedBox(height: 70.0),
                  Center(child: new Text('Water Control', style: TextStyle(fontSize: 30.0),)),
                  new SizedBox(height: 20.0),
                  GestureDetector(
                                      child: Container(
                      padding: EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: _watervalue==true?Colors.red:Colors.green
                      ),
                        child: Center(
                          child: new Icon(
                            Icons.power_settings_new, size: 50.0, color: Colors.white,
                          ),
                        ),
                    ),
                    onTap: (){
                       setState(() {
                         _watervalue==true?toggleWater(0):toggleWater(1);
                                      _watervalue==true?_watervalue=false:_watervalue=true;                
                                                    });
                    },
                  ),
                  ],
                ),
              ),
            ),
          )
      );
  }
}
class Channel {
  int id;
  String name;
  String latitude;
  String longitude;
  String field1;
  String field2;
  String field3;
  String created_at;
  String updated_at;
  int last_entry_id;

  Channel(
      {this.id,
      this.name,
      this.latitude,
      this.longitude,
      this.field1,
      this.field2,
      this.field3,
      this.created_at,
      this.last_entry_id,
      this.updated_at});

  factory Channel.fromJson(Map<String, dynamic> channelJson) {
    return Channel(
        id: channelJson['id'],
        name: channelJson['name'],
        latitude: channelJson['latitude'],
        longitude: channelJson['longitude'],
        field1: channelJson['field1'],
        field2: channelJson['field2'],
        field3: channelJson['field3'],
        created_at: channelJson['created_at'],
        updated_at: channelJson['updated_at'],
        last_entry_id: channelJson['last_entry_id']);
  }
}

class Information {
  final List<Feed> feeds;
  Channel channel;

  Information({this.channel, this.feeds});

  factory Information.fromJson(Map<String, dynamic> infoJson) {
    var list = infoJson['feeds'] as List;
    //print(list.runtimeType);
    List<Feed> feedlist = list.map((i) => Feed.fromJson(i)).toList();

    return Information(
      channel: Channel.fromJson(infoJson['channel']),
      feeds: feedlist,
    );
  }
}

class Feed {
  String created_at;
  int entry_id;
  String field1;
  String field2;
  String field3;

  Feed({this.created_at, this.entry_id, this.field1, this.field2, this.field3});

  factory Feed.fromJson(Map<String, dynamic> feedJson) {
    return Feed(
        created_at: feedJson['created_at'],
        entry_id: feedJson['entry_id'],
        field1: feedJson['field1'],
        field2: feedJson['field2'],
        field3: feedJson['field3']);
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
