import 'package:flutter/material.dart';

class DismissableBgWidget extends StatelessWidget {
  final bool pin;
  const DismissableBgWidget({Key? key, required this.pin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: Colors.green,
          height: double.infinity,
          width: (MediaQuery.of(context).size.width / 2) - 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.push_pin, color: Colors.white),
                const SizedBox(width: 8.0),
                Text(pin ? 'Unpin' : 'Pin',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.red,
          height: double.infinity,
          width: (MediaQuery.of(context).size.width / 2) - 20,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(width: 8.0),
                Icon(Icons.delete, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
