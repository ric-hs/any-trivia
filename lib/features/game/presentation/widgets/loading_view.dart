import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/loading_messages.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  int _currentIndex = 0;
  late Timer _timer;

  List<String> get _messages {
    final locale = Localizations.localeOf(context).languageCode;
    return LoadingMessages.getMessages(locale);
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pick an initial random message once we have context for the locale
    _currentIndex = Random().nextInt(_messages.length);
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
