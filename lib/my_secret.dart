import 'package:flutter/material.dart';

/// This widget displays and modifies your little secret.
class MySecret extends StatelessWidget {
  const MySecret({
    super.key,
    required this.readMySecret,
    required this.changeMySecret,
    required this.deleteMySecret,
  });

  /// A callback that can read the secret.
  final Future<String?> Function() readMySecret;

  /// A callback that can change the value of the secret.
  final Future<void> Function() changeMySecret;

  /// A callback that can delete your secret.
  final Future<void> Function() deleteMySecret;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'My secret',
            style: Theme.of(context).textTheme.headline3,
          ),
          FutureBuilder(
            future: readMySecret(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(snapshot.data ?? 'Provide your little secret');
              }
              return const CircularProgressIndicator();
            },
          ),
          ElevatedButton(
            onPressed: changeMySecret,
            child: const Text('Change'),
          ),
          ElevatedButton(
            onPressed: deleteMySecret,
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
