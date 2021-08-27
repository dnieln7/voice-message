import 'dart:io';

import 'package:flutter/material.dart';
import 'package:voice_message/utils/sound_recorder.dart';
import 'package:voice_message/widget/rounded_icon_button.dart';

class MessageInput extends StatefulWidget {
  MessageInput({required this.saveRecording});

  final void Function(File recording) saveRecording;

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final recorder = SoundRecorder();
  final controller = TextEditingController();

  var message = '';
  var recording = false;

  @override
  void initState() {
    super.initState();

    recorder.init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              padding: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: const InputDecoration(
                  hintText: 'Type something',
                  alignLabelWithHint: true,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
                onChanged: (text) => setState(() => message = text),
              ),
            ),
          ),
          if (recording)
            RoundedIconButton(
              icon: Icons.delete_rounded,
              background: Theme.of(context).errorColor,
              action: cancelRecording,
            ),
          if (recording)
            RoundedIconButton(
              icon: Icons.stop_rounded,
              background: Colors.green,
              action: stopRecording,
            ),
          if (!recording)
            RoundedIconButton(
              icon: Icons.mic_rounded,
              background: Theme.of(context).primaryColor,
              action: startRecording,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  void sendMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Text Message!')),
    );
  }

  void startRecording() {
    recorder.start();
    setState(() {
      recording = true;
    });
  }

  void cancelRecording() {
    recorder.stopWithoutSaving();

    setState(() {
      recording = false;
    });
  }

  void stopRecording() {
    recorder.stop().then((recording) {
      if (recording != null) {
        widget.saveRecording(recording);
      }
    });

    setState(() {
      recording = false;
    });
  }
}
