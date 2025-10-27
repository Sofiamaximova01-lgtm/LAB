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
          
          title: Text('Каждый охотник желает знать где сидит фазан.',
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
        
      child: Wrap(
        spacing: 10.0, // Расстояние между элементами по горизонтали
        runSpacing: 10.0, // Расстояние между рядами
        children: <Widget>[
          Container(
            width: 180, 
            height: 150, 
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 243, 9, 9),
          ),
          Container(
            width: 180, 
            height: 150, 
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 218, 129, 12),
          ),
          Container(
            width: 180, 
            height: 150, 
            padding: EdgeInsets.all(8.0),
            color: Color.fromARGB(255, 230, 215, 6),
          ),
          Container(
            width: 180, 
            height: 150, 
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 73, 202, 14),
          ),
          Container(
            width: 180, 
            height: 150, 
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 21, 181, 209),
          ),
          Container(
            width: 180, 
            height: 150, 
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 16, 13, 189),
          ),
          Container(
            width: 180, 
            height: 150, 
            padding: EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 119, 8, 184),
          ),
        ],
      ),
      )
    );
  }
}