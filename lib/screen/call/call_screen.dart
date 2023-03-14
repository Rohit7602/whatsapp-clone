import 'package:flutter/material.dart';

import '../../helper/styles/app_style_sheet.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Name'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: CircleAvatar(
              radius: 96.0,
              backgroundImage:
                  NetworkImage('https://randomuser.me/api/portraits/men/3.jpg'),
            ),
          ),
          const SizedBox(height: 24.0),
          Text(
            'Call duration: 00:02:33',
            style: GetTextTheme.sf16_regular,
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                child: const Icon(Icons.mic_off),
                onPressed: () {
                  // ignore: todo
                  // TODO: Implement mute functionality
                },
              ),
              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {},
                child: const Icon(Icons.call_end),
              ),
              FloatingActionButton(
                child: const Icon(Icons.volume_up),
                onPressed: () {
 
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
