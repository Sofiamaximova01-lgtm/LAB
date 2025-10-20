import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          
          title: Text('Легендарные моменты из легендарного мультфильма',
          style: TextStyle(
            fontSize: 30.0, 
          ),
          ),
          centerTitle: true,
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:SingleChildScrollView(
        
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 134, 108, 108),
            child: Image.asset(
              'logo_1.jpg', 
              height: 500,
              width: 750,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 134, 108, 108),
            child: Image.asset(
              'logo_2.jpg', 
              height: 500,
              width: 750,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: Color.fromARGB(255, 42, 23, 146),
            child: Image.asset(
              'logo_3.jpg', 
              height: 500,
              width: 750,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 42, 23, 146),
            child: Image.asset(
              'logo_4.jpg',
              height: 500,
              width: 750,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 42, 23, 146),
            child: Image.asset(
              'logo_5.jpg', 
              height: 500,
              width: 750,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 175, 14, 14),
            child: Image.asset(
              'logo_6.png', 
              height: 500,
              width: 750,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 175, 14, 14),
            child: Image.asset(
              'logo_7.jpg', 
              height: 500,
              width: 750,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      )
    );
  }
}