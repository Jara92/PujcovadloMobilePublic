// Inspired by https://api.flutter.dev/flutter/material/Autocomplete-class.html#material.Autocomplete.5
import 'dart:async';

typedef Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
///
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
Debounceable<S, T> debounce<S, T>(
    Debounceable<S?, T> function, Duration duration) {
  Debouncer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = Debouncer(duration);
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is DebouncerCancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  };
}

// A wrapper around Timer used for debouncing.
class Debouncer {
  final Duration debounceDuration;

  Debouncer(this.debounceDuration) {
    _timer = Timer(debounceDuration, _onComplete);
  }

  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const DebouncerCancelException());
  }
}

// An exception indicating that the timer was canceled.
class DebouncerCancelException implements Exception {
  const DebouncerCancelException();
}

// An exception indicating that a network request has failed.
class DebouncerNetworkException implements Exception {
  const DebouncerNetworkException();
}
