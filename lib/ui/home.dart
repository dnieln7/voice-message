import 'dart:io';

import 'package:flutter/material.dart';
import 'package:voice_message/widget/message_bubble_audio.dart';
import 'package:voice_message/widget/message_input.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final recordings = <File>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice Message')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: recordings.length,
              itemBuilder: (ctx, i) => MessageBubbleAudio(audio: recordings[i]),
            ),
          ),
          MessageInput(saveRecording: (recording) => saveRecording(recording)),
        ],
      ),
    );
  }

  void saveRecording(File file) {
    setState(() {
      recordings.add(file);
    });
  }
}
