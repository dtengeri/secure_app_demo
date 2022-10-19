import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secure_banking_app/change_secret_dialog.dart';
import 'package:secure_banking_app/my_secret.dart';

const _mySecretValueKey = 'mySecretValue';

/// Displays the usage of the flutter_secure_storage example.
class SecureStorageDemo extends StatefulWidget {
  const SecureStorageDemo({super.key});

  @override
  State<SecureStorageDemo> createState() => _SecureStorageDemoState();
}

class _SecureStorageDemoState extends State<SecureStorageDemo> {
  /// Create a new instance of the secure storage
  late final _secureStorage = const FlutterSecureStorage();

  /// Changes the current secret value by showing an edit dialog
  Future<void> _changeMySecret() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    /// Read the actual value
    final currentSecret = await _secureStorage.read(key: _mySecretValueKey);
    // Display a dialog with a text field where the user can change their secret.
    final newSecret = await showDialog(
      context: context,
      builder: (context) => ChangeSecretDialog(
        currentSecret: currentSecret,
      ),
    );
    if (newSecret != null) {
      // Save the secret value in the secure storage.
      await _secureStorage.write(key: _mySecretValueKey, value: newSecret);
      setState(() {});
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Your little secret is updated.',
          ),
        ),
      );
    }
  }

  /// Removes the current value.
  Future<void> _deleteMySecret() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // Deletes a key from the secure storage.
    await _secureStorage.delete(key: _mySecretValueKey);
    setState(() {});
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text(
          'Your little secret is removed.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MySecret(
      readMySecret: () => _secureStorage.read(key: _mySecretValueKey),
      changeMySecret: _changeMySecret,
      deleteMySecret: _deleteMySecret,
    );
  }
}
