import 'package:flutter/material.dart';
import 'navigation/home_page.dart';

void main() {
  runApp(const SongLyricsApp());
}

class SongLyricsApp extends StatelessWidget {
  const SongLyricsApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Song Lyrics Display',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}