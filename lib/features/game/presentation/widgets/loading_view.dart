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
  int _currentMessageIndex = 0;
  int _currentShapeIndex = 0;
  late Timer _messageTimer;
  late Timer _shapeTimer;

  static const List<IconData> _gameIcons = [
    Icons.videogame_asset,
    Icons.extension,
    Icons.sports_esports,
    Icons.casino,
    Icons.smart_toy,
    Icons.sports_basketball,
    Icons.flag, // goal/finish
    Icons.star,
  ];

  static const List<Color> _iconColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
  ];

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
    _currentShapeIndex = Random().nextInt(_gameIcons.length);
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

    // Timer for changing shapes (faster)
    _shapeTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!mounted) return;
      setState(() {
        int newIndex;
        do {
          newIndex = Random().nextInt(_gameIcons.length);
        } while (newIndex == _currentShapeIndex);
        _currentShapeIndex = newIndex;
      });
    });
  }

  @override
  void dispose() {
    _messageTimer.cancel();
    _shapeTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure indices are within bounds in case of hot reload/state changes
    final safeMessageIndex = _currentMessageIndex % (_messages.isEmpty ? 1 : _messages.length);
    final safeShapeIndex = _currentShapeIndex % _gameIcons.length;
    final safeColorIndex = _currentShapeIndex % _iconColors.length;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Game-like shape switcher
          SizedBox(
            height: 80,
            width: 80,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: RotationTransition(
                    turns: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Icon(
                _gameIcons[safeShapeIndex],
                key: ValueKey<int>(safeShapeIndex),
                size: 60,
                color: _iconColors[safeColorIndex],
              ),
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
