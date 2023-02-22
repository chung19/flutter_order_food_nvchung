import 'dart:async';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/datasources/remote/app_response.dart';
import 'base_event.dart';

abstract class BaseBloc {


  Future<T?> handleResponse<T>(
  Future<dynamic> responseFuture, Function convertJson) async {
    loadingSink.add(true);
    T? data ;
    try {
      Response response = await responseFuture;
      AppResponse<T> appResponse =
      AppResponse.fromJson(response.data, convertJson);
      data = appResponse.data;
    } on DioError catch (e) {
      messageSink.add(e.response?.data["message"]);
    } catch (e) {
      messageSink.add(e.toString());
    }
    loadingSink.add(false);
    return data;
  }





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
    loadingSink.close();
    // _loadingController.close();
    // _progressController.close();
    // _messageController.close();
    // messageSink.close();
  }
}
