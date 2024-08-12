import 'package:flutter/material.dart';

import '../Widgets/customButton.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({required this.onDelete, super.key});

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.red.shade700,
            size: 30,
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: const Text(
              'Confirm Deletion',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        'Are you sure you want to delete your account? '
        'This action is irreversible.',
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 16,
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: CustomButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.grey.shade200,
                textColor: Colors.black,
                text: 'Cancel',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDelete();
                },
                text: 'Delete',
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

void showDeleteConfirmationDialog({
  required BuildContext context,
  required VoidCallback onDelete,
}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return DeleteConfirmationDialog(onDelete: onDelete);
    },
  );
}
