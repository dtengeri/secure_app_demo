import 'package:flutter/material.dart';

class ChangeSecretDialog extends StatefulWidget {
  const ChangeSecretDialog({
    super.key,
    required this.currentSecret,
  });

  final String? currentSecret;

  @override
  State<ChangeSecretDialog> createState() => _ChangeSecretDialogState();
}

class _ChangeSecretDialogState extends State<ChangeSecretDialog> {
  late final _textEditingController = TextEditingController(
    text: widget.currentSecret,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change your secret'),
      content: TextField(
        controller: _textEditingController,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, _textEditingController.text);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
