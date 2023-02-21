

import '../../data/datasources/remote/api_request.dart';

abstract class BaseRepository {
  ApiRequest _apiRequest = ApiRequest();
  ApiRequest get apiRequest => _apiRequest;
  void updateRequest(ApiRequest apiRequest) {
    _apiRequest = apiRequest;
  }
}