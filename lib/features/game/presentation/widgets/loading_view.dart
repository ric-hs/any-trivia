import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  int _currentIndex = 0;
  late Timer _timer;

  final List<String> _messages = [
    "Summoning the trivia gods...",
    "Polishing the trophies...",
    "Consulting the oracle...",
    "Loading knowledge crystals...",
    "Sharpening the questions...",
    "Preparing your challenge...",
    "Rolling the dice in the cloud...",
    "Gathering intelligence..."
  ];

  @override
  void initState() {
    super.initState();
    // Pick an initial random message
    _currentIndex = Random().nextInt(_messages.length);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      setState(() {
        int newIndex;
        do {
          newIndex = Random().nextInt(_messages.length);
        } while (newIndex == _currentIndex && _messages.length > 1);
        _currentIndex = newIndex;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                _messages[_currentIndex],
                key: ValueKey<String>(_messages[_currentIndex]),
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
