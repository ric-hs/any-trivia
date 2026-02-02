import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/loading_messages.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  int _currentMessageIndex = 0;
  late Timer _messageTimer;

  List<String> get _messages {
    final locale = Localizations.localeOf(context).languageCode;
    return LoadingMessages.getMessages(locale);
  }

  @override
  void initState() {
    super.initState();
    _startTimers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pick an initial random message once we have context for the locale
    if (_messages.isNotEmpty) {
      _currentMessageIndex = Random().nextInt(_messages.length);
    }
  }

  void _startTimers() {
    // Timer for changing messages (slower)
    _messageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      setState(() {
        if (_messages.length > 1) {
          int newIndex;
          do {
            newIndex = Random().nextInt(_messages.length);
          } while (newIndex == _currentMessageIndex);
          _currentMessageIndex = newIndex;
        }
      });
    });

    // _shapeTimer no longer needed
  }

  @override
  void dispose() {
    _messageTimer.cancel();
    // _shapeTimer no longer needed

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure indices are within bounds in case of hot reload/state changes
    final safeMessageIndex = _currentMessageIndex % (_messages.isEmpty ? 1 : _messages.length);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            // Game-like shape switcher
          SizedBox(
            height: 120, // Increased size for better visibility
            width: 120,
            child: Image.asset(
              'assets/logo/logo.png',
              fit: BoxFit.contain,
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.1, 1.1),
              duration: 1000.ms,
              curve: Curves.easeInOut,
            ),
          ),
          const SizedBox(height: 24),
          // Loading text
          if (_messages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  _messages[safeMessageIndex],
                  key: ValueKey<String>(_messages[safeMessageIndex]),
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
