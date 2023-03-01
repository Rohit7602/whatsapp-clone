import 'package:flutter/material.dart';

import '../../styles/textTheme.dart';

class CallScreen extends StatelessWidget {
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
            style: TextThemeProvider.bodyText,
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                child: const Icon(Icons.mic_off),
                onPressed: () {
                  // TODO: Implement mute functionality
                },
              ),
              FloatingActionButton(
                child: const Icon(Icons.call_end),
                backgroundColor: Colors.red,
                onPressed: () {
                  // TODO: Implement end call functionality
                },
              ),
              FloatingActionButton(
                child: const Icon(Icons.volume_up),
                onPressed: () {
                  // TODO: Implement speaker functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
