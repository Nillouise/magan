import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Frame extends StatefulWidget {
  const Frame({Key? key}) : super(key: key);

  @override
  State<Frame> createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  int count = 0;

  @override
  void initState() {
    SchedulerBinding.instance.addPersistentFrameCallback(_frame);
    super.initState();
  }

  int _lastFrameTime = 0;
  String _frameRate = "0 fps";

  void _frame(Duration elapsed) {
    int elapsedMicroseconds = elapsed.inMicroseconds;
    double elapsedSeconds = (elapsedMicroseconds - _lastFrameTime) * 1e-6;
    if (elapsedSeconds != 0) {
      _lastFrameTime = elapsedMicroseconds;
      count++;

      if (count % 10 == 0) {
        setState(() {
          _frameRate = '${(1.0 / elapsedSeconds).round()} fps';
        });
      }
    }

    SchedulerBinding.instance.scheduleFrame();

    // Redraw.
  }

  @override
  Widget build(BuildContext context) {
    return Text(_frameRate);
  }
}
