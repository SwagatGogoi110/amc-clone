import 'package:flutter/material.dart';

class SimpleCounter extends StatefulWidget {
  final ValueChanged<int> onChanged;
  final int initialValue;
  final int minValue;
  final int maxValue;

  const SimpleCounter({
    required this.onChanged,
    this.initialValue = 1,
    this.minValue = 1,
    this.maxValue = 99,
  });

  @override
  _SimpleCounterState createState() => _SimpleCounterState();
}

class _SimpleCounterState extends State<SimpleCounter> {
  late int _counter;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            if (_counter > widget.minValue) {
              setState(() {
                _counter--;
                widget.onChanged(_counter);
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: const Icon(Icons.remove, color: Colors.white),
          ),
        ),
        Text(
          '$_counter',
          style: const TextStyle(fontSize: 18),
        ),
        GestureDetector(
          onTap: () {
            if (_counter < widget.maxValue) {
              setState(() {
                _counter++;
                widget.onChanged(_counter);
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
