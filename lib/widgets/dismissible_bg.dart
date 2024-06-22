import 'package:flutter/material.dart';

class DismissibleBg extends StatelessWidget {
  final bool isSecondary;
  final bool isPinned;

  const DismissibleBg(
      {Key? key, required this.isSecondary, required this.isPinned})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSecondary
          ? Colors.red
          : isPinned
              ? Colors.grey[600]
              : Colors.green,
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: isSecondary
              ? const [
                  Text('Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(width: 8.0),
                  Icon(Icons.delete, color: Colors.white),
                ]
              : [
                  const Icon(Icons.push_pin, color: Colors.white),
                  const SizedBox(width: 8.0),
                  Text(isPinned ? 'Unpin' : 'Pin',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ],
        ),
      ),
    );
  }
}
