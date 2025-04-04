import 'package:flutter/material.dart';
import 'dart:async';

class AuthUIProvider with ChangeNotifier {
  bool _isSendingCode = false;
  int _secondsRemaining = 0;
  Timer? _timer;

  bool get isSendingCode => _isSendingCode;
  int get secondsRemaining => _secondsRemaining;

  void startCountdown(int seconds) {
    _secondsRemaining = seconds;
    _isSendingCode = true;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsRemaining--;
      if (_secondsRemaining <= 0) {
        _isSendingCode = false;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  void reset() {
    _timer?.cancel();
    _isSendingCode = false;
    _secondsRemaining = 0;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
} 