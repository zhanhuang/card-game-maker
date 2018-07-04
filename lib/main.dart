import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Card Game Testing',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Card Deck Tester'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<File> _allCards;
  List<File> _drawnCards;
  bool _showAll = true;

  Future uploadImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (_allCards == null) {
        _allCards = new List<File>();
      }
      if (image != null) {
        _allCards.add(image);
      }
    });
  }

  List<Card> _buildCards() {
    if (_allCards == null || _allCards.isEmpty) {
      return [
        Card(
          child: new Center(
            child: Text('Upload an image to get started.'),
          ),
        ),
      ];
    }

    var cardsToDisplay = _showAll ? _allCards : _drawnCards;

    if(_drawnCards == null || _drawnCards.isEmpty) {
      cardsToDisplay = _allCards;
    }

    return cardsToDisplay.map((file) {
      return Card(
        child: new Image.file(file),
      );
    }).toList();
  }

  void shuffleAndDraw() {
    setState(() {
      if (_drawnCards == null) {
        _drawnCards = new List<File>();
      }
      _allCards.shuffle();
      _drawnCards = _allCards.sublist(0, min(2, _allCards.length));
      _showAll = false;
    });
  }

  void showAll() {
    setState(() {
      _showAll = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.border_all),
          onPressed: showAll,
        ),
        title: new Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: uploadImage,
          )
        ],
      ),
      body: GridView.count(
          crossAxisCount: 2,
          children: _buildCards()
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter),
        onPressed: shuffleAndDraw,
      ),
    );
  }
}