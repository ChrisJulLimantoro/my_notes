import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/widgets/pin.dart';
import 'package:crypt/crypt.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({Key? key}) : super(key: key);

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String pin = '';
  String pass = Crypt.sha256('123456').toString();
  int isCorrect = 0;

  void addPin(BuildContext context, String value) async {
    if (pin.length < 5) {
      setState(() {
        pin += value;
      });
    } else if (pin.length == 5) {
      setState(() {
        pin += value;
        if (Crypt(pass).match(pin.trim())) {
          isCorrect = 1;
        } else {
          isCorrect = 2;
        }
      });
      await Future.delayed(const Duration(seconds: 1));
      if (Crypt(pass).match(pin.trim())) {
        debugPrint("hello");
        Navigator.pushReplacementNamed(context, '/home');
      }
      setState(() {
        pin = '';
        isCorrect = 0;
      });
    }
  }

  void removePin() {
    if (pin.isNotEmpty) {
      setState(() {
        pin = pin.substring(0, pin.length - 1);
      });
    }
  }

  Widget buildPinRow(BuildContext context, int start, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        int value = start + index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: FloatingActionButton(
            onPressed: () {
              addPin(context, '$value');
            },
            backgroundColor: Colors.white,
            elevation: 2,
            shape: const CircleBorder(),
            heroTag: 'pin_$value',
            child: Text('$value'),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text('Please Enter your pin'),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PinWidget(
                    isActive: index < pin.length,
                    isCorrect: isCorrect,
                  ),
                ),
              ),
            ),
            Text(
              isCorrect == 0
                  ? ''
                  : isCorrect == 1
                      ? 'Your Pin is Correct'
                      : 'Wrong Pin, Please try again',
              style: TextStyle(
                color: isCorrect == 1 ? Colors.green[400] : Colors.red[400],
              ),
            ),
            const Spacer(),
            buildPinRow(context, 1, 3),
            const SizedBox(height: 32.0),
            buildPinRow(context, 4, 3),
            const SizedBox(height: 32.0),
            buildPinRow(context, 7, 3),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 112.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      addPin(context, '0');
                    },
                    backgroundColor: Colors.white,
                    elevation: 2,
                    shape: const CircleBorder(),
                    heroTag: 'pin_0',
                    child: const Text('0'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      removePin();
                    },
                    backgroundColor: Colors.white,
                    elevation: 2,
                    shape: const CircleBorder(),
                    heroTag: 'pin_back',
                    child: const Icon(CupertinoIcons.chevron_back),
                  ),
                )
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
