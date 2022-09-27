import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'base_event.dart';

abstract class BaseBloc {
  final StreamController<BaseEvent> _eventStreamController = StreamController();
  final StreamController<bool> _loadingController = StreamController.broadcast();
  final StreamController<BaseEvent> _progressController = BehaviorSubject();
  final StreamController<String> _messageController = BehaviorSubject();

  Stream<String> get messageStream => _messageController.stream;
  Sink<String> get messageSink => _messageController.sink;
  Stream<BaseEvent> get progressStream => _progressController.stream;
  Sink<BaseEvent> get progressSink => _progressController.sink;
  Sink<BaseEvent> get eventSink => _eventStreamController.sink;
  Stream<bool> get loadingStream => _loadingController.stream;
  Sink<bool> get loadingSink => _loadingController.sink;

  BaseBloc(){
    _eventStreamController.stream.listen((event) {
      dispatch(event);
    });
  }

  void dispatch(BaseEvent event);

  void dispose() {
    _eventStreamController.close();
    _loadingController.close();
    _progressController.close();
  }
}
