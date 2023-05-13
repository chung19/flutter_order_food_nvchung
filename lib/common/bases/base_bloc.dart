import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'base_event.dart';

abstract class BaseBloc {
  BaseBloc() {
    _eventStreamController.stream.listen((BaseEvent event) {
      dispatch(event);
    });
  }

  final StreamController<BaseEvent> _eventStreamController =
      StreamController<BaseEvent>();
  final StreamController<bool> _loadingController =
      StreamController<bool>.broadcast();
  final StreamController<BaseEvent> _progressController =
      BehaviorSubject<BaseEvent>();
  final StreamController<String> _messageController = BehaviorSubject<String>();

  Stream<String> get messageStream => _messageController.stream;
  Sink<String> get messageSink => _messageController.sink;
  Stream<BaseEvent> get progressStream => _progressController.stream;
  Sink<BaseEvent> get progressSink => _progressController.sink;
  Sink<BaseEvent> get eventSink => _eventStreamController.sink;
  Stream<bool> get loadingStream => _loadingController.stream;
  Sink<bool> get loadingSink => _loadingController.sink;

  void dispatch(BaseEvent event);

  void dispose() {
    _eventStreamController.close();
    loadingSink.close();
    _loadingController.close();
    _progressController.close();
    _messageController.close();
    messageSink.close();
  }
}
