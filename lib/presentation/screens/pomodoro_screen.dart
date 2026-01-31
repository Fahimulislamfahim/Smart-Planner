import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class PomodoroScreen extends ConsumerStatefulWidget {
  const PomodoroScreen({super.key});

  @override
  ConsumerState<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends ConsumerState<PomodoroScreen> {
  int _workMinutes = 25;
  int _breakMinutes = 5;
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  bool _isWorkSession = true;
  Timer? _timer;

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _onSessionComplete();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _isWorkSession ? _workMinutes * 60 : _breakMinutes * 60;
    });
  }

  void _onSessionComplete() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isWorkSession = !_isWorkSession;
      _remainingSeconds = _isWorkSession ? _workMinutes * 60 : _breakMinutes * 60;
    });

    // Show notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isWorkSession ? '🎉 Break complete! Time to work!' : '⏰ Work session complete! Take a break!'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isWorkSession ? '🎯 Focus Time' : '☕ Break Time',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isWorkSession
                    ? Colors.red.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                border: Border.all(
                  color: _isWorkSession ? Colors.red : Colors.green,
                  width: 8,
                ),
              ),
              child: Center(
                child: Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: _isWorkSession ? Colors.red : Colors.green,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? 'Pause' : 'Start'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: _isWorkSession ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Work Duration:'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (_workMinutes > 5) {
                                  setState(() {
                                    _workMinutes -= 5;
                                    if (!_isRunning && _isWorkSession) {
                                      _remainingSeconds = _workMinutes * 60;
                                    }
                                  });
                                }
                              },
                            ),
                            Text('$_workMinutes min', style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                if (_workMinutes < 60) {
                                  setState(() {
                                    _workMinutes += 5;
                                    if (!_isRunning && _isWorkSession) {
                                      _remainingSeconds = _workMinutes * 60;
                                    }
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Break Duration:'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (_breakMinutes > 5) {
                                  setState(() {
                                    _breakMinutes -= 5;
                                    if (!_isRunning && !_isWorkSession) {
                                      _remainingSeconds = _breakMinutes * 60;
                                    }
                                  });
                                }
                              },
                            ),
                            Text('$_breakMinutes min', style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                if (_breakMinutes < 30) {
                                  setState(() {
                                    _breakMinutes += 5;
                                    if (!_isRunning && !_isWorkSession) {
                                      _remainingSeconds = _breakMinutes * 60;
                                    }
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
