import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:weather_app/weathersec.dart';
import 'package:weather_icons/weather_icons.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: "Weather"),
    );
  }
}
class MyWidget extends StatelessWidget {

  Widget build(BuildContext context) {
    return IconButton(
        color: Colors.blue,
        icon: BoxedIcon(WeatherIcons.day_sunny),
        onPressed: () {
          print("Foo");
        }

    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

String str='';
String units='';
  @override
  Widget build(BuildContext context)=>Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
          image:AssetImage(
            'lib/img.png'
          ),
        fit: BoxFit.fill,
      ),
    ),
    child : Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text(widget.title),
      ),
      //drawer: const NavigationDrawer(),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            FutureBuilder(
                future: apicall(),
                builder: (context,snapshot){
                  if(snapshot.hasData) {
                    str=snapshot.data['icon'];
                    return Column(
                        children: [
                         Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                      snapshot.data['temp'].toString(),
                                    style: TextStyle(
                                      color: Colors.white70,
                                    ),
                                    textScaleFactor: 5,

                                  ),
                                  Image.network('https://openweathermap.org/img/w/${str}.png'),
                                ],
                              ),

                            ),
                          ),
                             Text(snapshot.data['description'].toString()),
                          Text(snapshot.data['pressure'].toString()),

                  ]
                  );
                  }
                  else{
                    return CircularProgressIndicator();
                  }




            }),
            IconButton(
                color: Colors.blue,
                icon: BoxedIcon(WeatherIcons.day_sunny),
                onPressed: () {
                  print("Foo");
                }
            )

          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed:((){}),
        tooltip: 'increment',
        child: const Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    ),
  );

  }


Future apicall() async{
  final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=Bangalore&appid=14ac07103a961c3bbf67d81847e3dae5&units=Metric');
  final response = await http.get(url);
  print(response);
  //return "hi";
  final json = jsonDecode(response.body);
  print(json['weather'][0]["description"]);
  final output = {
    'description' : json['weather'][0]["description"],
    'temp': json['main']['temp'],
    'icon': json['weather'][0]['icon'],
    'pressure' : json['main'][4]['pressure'],
  };
  return output;
}

