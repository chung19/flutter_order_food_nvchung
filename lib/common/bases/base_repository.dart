

import '../../data/datasources/remote/api_request.dart';

abstract class BaseRepository {
  ApiRequest apiRequest= ApiRequest();

  void updateRequest(ApiRequest apiRequest) {

    this.apiRequest = apiRequest;
  }
}