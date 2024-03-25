// Inspired by https://api.flutter.dev/flutter/material/Autocomplete-class.html#material.Autocomplete.5
import 'dart:async';

typedef Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new object that is a debounced version of the given function.
///
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
class DebounceableFunction<S, T> {
  DebouncerTimer? debounceTimer;
  final Debounceable<S?, T> function;
  final Duration duration;

  DebounceableFunction(this.function, this.duration);

  Future<S?> call(T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = DebouncerTimer(duration);
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is DebouncerCancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  }

  void cancel() {
    if (debounceTimer != null) debounceTimer!.cancel();
  }
}

/*DebounceableObject<S, T> debounce<S, T>(
    Debounceable<S?, T> function, Duration duration) {
  return DebounceableObject(function, duration);
}*/

// A wrapper around Timer used for debouncing.
class DebouncerTimer {
  final Duration debounceDuration;

  DebouncerTimer(this.debounceDuration) {
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
    // Do nothing if the completer is already completed
    if (_completer.isCompleted) return;

    // Cancel the timer and complete the completer with an error
    _timer.cancel();
    _completer.completeError(const DebouncerCancelException());
  }
}

// An exception indicating that the timer was canceled.
class DebouncerCancelException implements Exception {
  const DebouncerCancelException();
}
