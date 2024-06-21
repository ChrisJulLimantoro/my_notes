import 'package:flutter/material.dart';

class PinWidget extends StatelessWidget {
  final bool isActive;
  final int isCorrect;
  const PinWidget({Key? key, required this.isActive, required this.isCorrect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20, // Circle diameter
      height: 20, // Circle diameter
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCorrect == 0
            ? (isActive ? Colors.grey[600] : Colors.grey[200])
            : isCorrect == 1 || isCorrect == 3
                ? Colors.green[300]
                : Colors.red[400], // Circle color
      ),
    );
  }
}
