import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  bool _isRunning = false;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  int _elapsedMilliseconds = 0;
  late SharedPreferences _prefs;
  final String _prefsKey = 'stopwatch';

  @override
  void initState() {
    super.initState();
    _loadElapsedTime();
  }

  void _loadElapsedTime() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _elapsedMilliseconds = _prefs.getInt(_prefsKey) ?? 0;
    });
  }

  void _saveElapsedTime() {
    _prefs.setInt(_prefsKey, _elapsedMilliseconds);
  }

  void _startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _stopwatch.start();
      _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        setState(() {
          _elapsedMilliseconds = _stopwatch.elapsedMilliseconds;
          _saveElapsedTime();
        });
      });
    }
  }

  void _stopTimer() {
    if (_isRunning) {
      _isRunning = false;
      _stopwatch.stop();
      _timer?.cancel();
    }
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _stopwatch.reset();
      _elapsedMilliseconds = 0;
      _saveElapsedTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stopwatch Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Time: ${_formatTime(_elapsedMilliseconds)}',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _startTimer,
                  child: Text('Start'),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: Text('Stop'),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int milliseconds) {
    int hours = milliseconds ~/ (1000 * 60 * 60);
    int remainingMilliseconds = milliseconds % (1000 * 60 * 60);
    int minutes = remainingMilliseconds ~/ (1000 * 60);
    remainingMilliseconds %= (1000 * 60);
    int seconds = remainingMilliseconds ~/ 1000;
    remainingMilliseconds %= 1000;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    String millisecondsStr = remainingMilliseconds.toString().padLeft(3, '0');

    return '$hoursStr:$minutesStr:$secondsStr.$millisecondsStr';
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
