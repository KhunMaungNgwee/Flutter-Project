import 'package:flutter/material.dart';

class DeleteConfirmationScreen extends StatefulWidget {
  @override
  _DeleteConfirmationScreenState createState() =>
      _DeleteConfirmationScreenState();
}

class _DeleteConfirmationScreenState extends State<DeleteConfirmationScreen> {
  void _showDeleteConfirmationDialog(BuildContext context,
      {required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete?'),
          actions: <Widget>[
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                print('Delete canceled');
              },
              child: const Text('Cancel'),
            ),
            // Confirm Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Execute the delete logic passed from the caller
                print('Delete confirmed');
              },
              child: const Text(
                'Confirm',
                style: TextStyle(
                    color: Colors.red), // Red color for confirm button
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AlertDialog Example')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            _showDeleteConfirmationDialog(
              context,
              onConfirm: () {
                // Add your delete logic here
                print('Item deleted');
              },
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 88, 90, 88),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
