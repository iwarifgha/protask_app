import 'dart:async';

import 'package:flutter/material.dart';

class ProtaskLoader extends StatefulWidget {
  const ProtaskLoader({super.key});

  @override
  State<ProtaskLoader> createState() => _RecordingWaveWidgetState();
}

class _RecordingWaveWidgetState extends State<ProtaskLoader> {
  final List<double> _heights = [0.002, 0.03, 0.05, 0.006, 0.008];
  Timer? _timer;

  @override
  void initState() {
    _startAnimating();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimating() {
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        // This is a simple way to rotate the list, creating a wave effect.
        _heights.add(_heights.removeAt(0));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context).colorScheme;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _heights.map((height) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 8,
            height: MediaQuery.sizeOf(context).height * height,
            //margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: const Color(0xff008fff),
              borderRadius: BorderRadius.circular(50),
            ),
          );
        }).toList(),
      ),
    );
  }
}