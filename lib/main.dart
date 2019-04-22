import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // intarintional format of date and time and number

void main() async {
  Map _data = await getQueak(); // our json api reutrn Map

  List _features = _data['features']; //then we make a List from our Map

  for (int i = 0; i < _features.length; i++) {
    print(_features[i]['properties']['time']);
  }

  runApp(MaterialApp(
    title: 'erathqueak',
    home: Scaffold(
      appBar: AppBar(
        title: Text("erathQueakApi"),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent[50],
      ),
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: ListView.builder(
          itemCount:
              _features.length, // we should pass List.lenght not Map.lenght
          padding: EdgeInsets.all(5.5),

          itemBuilder: (BuildContext context, int position) {
            // var format=DateFormat("yMd"); year-month-day look at DateFormat in Docs of Flutter
            var format = DateFormat.yMMMMd("en_US").add_jm();
            //time *1000 to convert it to microsecond
            // utc: true to show our local time zone
            var date = format.format(DateTime.fromMicrosecondsSinceEpoch(
                _features[position]['properties']['time'] * 1000,
                isUtc: true));

            return ListTile(
              title: Text('At:$date'),
              subtitle: Text("${_features[position]['properties']['place']}"),
              leading: CircleAvatar(
                backgroundColor: Colors.yellow[200],
                child: Text(
                  "${_features[position]['properties']['mag']}",
                  style: TextStyle(fontSize: 20.5,color: Colors.black),
                ), //magnitued means qoht or mqdar lzlzal
              ),
              onTap: () {
                _showQueakDialog(
                    context, "${_features[position]['properties']['title']}");
              },
            );
          },
        ),
      ),
    ),
  ));
}

void _showQueakDialog(BuildContext context, String message) {
  var alert = AlertDialog(
    title: Text('Dialog'),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        child: Text(
          "ok",
          style: TextStyle(
              fontSize: 18.0,
              fontStyle: FontStyle.italic,
              color: Colors.lightBlue),
        ),
        onPressed: () {
          // Navigator.pop(context) get ride of this alert in the same function that's why we need context
          Navigator.pop(context);
        },
      )
    ],
  );
// show this context in the same func
  showDialog(context: context, child: alert);
}

Future<Map> getQueak() async {
  String apiUrl =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';

  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}
