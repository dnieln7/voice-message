import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:voice_message/utils/sound_player.dart';

class MessageBubbleAudio extends StatefulWidget {
  MessageBubbleAudio({required this.audio});

  final File audio;

  @override
  _MessageBubbleAudioState createState() => _MessageBubbleAudioState();
}

class _MessageBubbleAudioState extends State<MessageBubbleAudio> {
  final player = SoundPlayer();
  var started = false;
  var paused = false;

  var pos = 0;
  var percentage = 0.0;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();

    player.init().then((_) {
      subscription = player.progress!.listen((event) {
        final limit = event.duration.inMilliseconds;
        final current = event.position.inMilliseconds;

        setState(() {
          percentage = ((current * 100) / limit) / 100;
          print('------------$percentage');
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: started
                    ? paused
                        ? resume
                        : pause
                    : start,
                icon: Icon(
                  started
                      ? paused
                          ? Icons.play_arrow_outlined
                          : Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 35,
                ),
              ),
              if (started)
                IconButton(
                  onPressed: stop,
                  icon: Icon(Icons.stop_rounded, size: 35),
                ),
              const SizedBox(width: 5),
              Flexible(
                fit: FlexFit.loose,
                child: started
                    ? ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: LinearProgressIndicator(value: percentage),
                      )
                    : Text(
                        'Voice message',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '${DateTime.now().toString().substring(0, 16)}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    player.stop();
    subscription?.cancel();
    subscription = null;
    super.dispose();
  }

  void start() {
    player.start(widget.audio, resetUI);

    setState(() {
      started = true;
      paused = false;
    });
  }

  void pause() {
    player.pause();

    setState(() {
      started = true;
      paused = true;
    });
  }

  void resume() {
    player.resume();

    setState(() {
      started = true;
      paused = false;
    });
  }

  void stop() {
    player.stop();

    setState(() {
      started = false;
      paused = false;
    });
  }

  void resetUI() {
    setState(() {
      started = false;
      paused = false;
      percentage = 0.0;
    });
  }
}
