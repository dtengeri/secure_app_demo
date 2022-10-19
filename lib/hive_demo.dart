import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'account';
const _encryptionKey = 'boxEncryptionKey';
const _balanceKey = 'balance';

class HiveDemo extends StatelessWidget {
  const HiveDemo({super.key});

  /// Opens the Hive box
  Future<void> _openBox() async {
    // Initialize Hive for Flutter
    await Hive.initFlutter();
    // Read the key used for encryption.
    const secureStorage = FlutterSecureStorage();
    String? encryptionKey = await secureStorage.read(key: _encryptionKey);
    if (encryptionKey == null) {
      // Create a new key if it does not exists.
      final key = Hive.generateSecureKey();
      // Add it to the secure storage.
      await secureStorage.write(
        key: _encryptionKey,
        value: base64UrlEncode(key),
      );
    }
    // Read the key from the secure storage.
    final key = await secureStorage.read(key: _encryptionKey);
    final encryptionKeyBytes = base64Url.decode(key!);
    // Open the box with the encryption key.
    await Hive.openBox<double>(
      _boxName,
      encryptionCipher: HiveAesCipher(encryptionKeyBytes),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _openBox(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const _HiveDemoContent();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

/// Displays the balance and modifies it.
class _HiveDemoContent extends StatelessWidget {
  const _HiveDemoContent({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder reacts to changes in the given box.
    // It will run its builder method when any value in the box changes.
    return ValueListenableBuilder(
      valueListenable: Hive.box<double>(_boxName).listenable(),
      builder: (context, box, child) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Balance',
              style: Theme.of(context).textTheme.headline3,
            ),
            // Get the current value of the balance from the box.
            Text(
              box.get(_balanceKey, defaultValue: 0.0).toString(),
            ),
            ElevatedButton(
              onPressed: () {
                // Get the balance value from the box.
                final balance = box.get(_balanceKey, defaultValue: 0.0);
                // Update it with the new value.
                box.put(_balanceKey, balance! + 5.0);
              },
              child: const Text('Add \$5'),
            )
          ],
        ),
      ),
    );
  }
}
