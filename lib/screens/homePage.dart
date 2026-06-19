import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool loading = false;
  String baseUrl = "https://dummyjson.com/users";

  final id = 0;
  final firstName = '';

  
  void getData() async {
  final url = Uri.parse(baseUrl);
  
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decode data if successful
      var data = jsonDecode(response.body);
      // id = data.
      

      
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (error) {
    print('Connection error: $error');
  }
}


  void postData(){}

  void putData(){}

  void removeData(){}
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        title: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Text("API Integration")),
        
      ),
      body: Row(

        children: [

          ElevatedButton(onPressed: getData, child: Text("GET")),
          ElevatedButton(onPressed: postData, child: Text("GET")),
          ElevatedButton(onPressed: putData, child: Text("GET")),
          ElevatedButton(onPressed: removeData, child: Text("GET"))

        ],

      )
    );
  }
}
