import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String str = '01d';
  final myController = TextEditingController();
  String str1 = "";
  String units = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[50],
        title: Text(widget.title,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      body: Center(

        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: AssetImage(
                  'lib/img.png'
                //'lib/img_1.png'
              ),
              fit: BoxFit.cover,
            ),
          ),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(color: Colors.black),
                        hintText: 'Cities',
                        labelText: 'Search cities',
                        labelStyle: TextStyle(color: Colors.black)),
                    controller: myController,
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Color(0xff44000000))),
                      onPressed: (() {
                        str1 = myController.text;
                        myController.text =
                            myController.text;
                        setState(() {});
                      }),
                      child: Text(
                        "Search",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ),
                ],
              ),
              FutureBuilder(
                  future: apicall(str1),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      str = snapshot.data['icon'];
                      return Container(
                        height: 400,
                        width: 500,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),


                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data['temp'].toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        textScaleFactor: 5,

                                      ),
                                      Text(
                                        snapshot.data['feels_like'].toString(),
                                        style: TextStyle(
                                          fontSize: 30,
                                        ),
                                      ),
                                      Image.network(
                                          'https://openweathermap.org/img/w/${str}.png'),
                                    ],
                                  ),

                                ),
                              ),
                              Text(snapshot.data['description'].toString(),
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround,
                                children: [

                                  Text('Min temp : ${snapshot.data['temp_min']
                                      .toString()} celcius',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Max temp : ${snapshot.data['temp_max']
                                      .toString()} celcius',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround,
                                children: [
                                  Text('Pressure : ${snapshot.data['pressure']
                                      .toString()} atm',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text('Humidity : ${snapshot.data['humidity']
                                      .toString()} %',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text('Visibility : ${snapshot.data['visibility']
                                  .toString()} meters',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),


                            ]
                        ),
                      );
                    }
                    else {
                      return CircularProgressIndicator();
                    }
                  }),
            ],
          ),


        ),
      ),
    );
  }
}



  Future apicall(String str1) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=bangalore&appid=14ac07103a961c3bbf67d81847e3dae5&units=Metric');
    final response = await http.get(url);
    print(response);
    //return "hi";
    final json = jsonDecode(response.body);
    print(json['weather'][0]["description"]);
    var output = {
      'description': json['weather'][0]["description"],
      'temp': json['main']['temp'],
      'feels_like': json['main']['feels_like'],
      'icon': json['weather'][0]['icon'],
      'temp_min': json['main']['temp_min'],
      'temp_max': json['main']['temp_max'],
      'pressure': json['main']['pressure'],
      'humidity': json['main']['humidity'],
      'visibility':json['visibility'],
    };
    print(output);
    return output;
  }


