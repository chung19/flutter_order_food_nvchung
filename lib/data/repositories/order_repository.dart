import 'dart:async';

import 'package:dio/dio.dart';

import '../../common/bases/base_repository.dart';
import '../../common/constants/api_constant.dart';
import '../datasources/remote/app_response.dart';
import '../datasources/remote/dio_client.dart';
import '../datasources/remote/dto/order_dto.dart';

class OrderRepository extends BaseRepository {
  OrderRepository() {
    _dio = DioClient.instance.dio;
  }
  late Dio _dio;

  Future getOrder() {
    return apiRequest.getOrder();
  }

  Future<List<OrderDto>> fetchOrderHistory() {
    Completer<List<OrderDto>> completer = Completer();
    _dio.post(ApiConstant.orderHistoryCart).then((response) {
      AppResponse<List<OrderDto>> dataResponse = AppResponse.fromJson(
          response.data as Map<String, dynamic>, OrderDto.convertJson);
      completer.complete(dataResponse.data);
    }).catchError((error) {
      if (error is DioError) {
        completer.completeError(
            error.response?.data['message'] as Map<String, dynamic>);
      } else {
        completer.completeError(error.toString);
      }
    });
    return completer.future;
  }
}
