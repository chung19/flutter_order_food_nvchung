

import '../../data/datasources/remote/api_request.dart';

abstract class BaseRepository {
  late ApiRequest apiRequest;

  void updateRequest(ApiRequest apiRequest) {
    this.apiRequest = apiRequest;
  }
}