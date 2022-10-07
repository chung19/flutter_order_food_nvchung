import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_order_food_nvchung/common/bases/base_repository.dart';
import 'package:flutter_order_food_nvchung/data/datasources/remote/dio_client.dart';
import 'package:flutter_order_food_nvchung/data/datasources/remote/dto/order_dto.dart';
import '../../common/constants/api_constant.dart';
import '../datasources/remote/app_response.dart';


class OrderRepository extends BaseRepository {
  late Dio _dio;

  OrderRepository() {
    _dio = DioClient.instance.dio;
  }

  Future getOrder() {
    return apiRequest.getOrder();
  }
  Future<List<OrderDto>> fetchOrderHistory() {
    Completer<List<OrderDto>> completer = Completer();
    _dio.post(ApiConstant.ORDER_HISTORY_URL).then((response){
      AppResponse<List<OrderDto>> dataResponse = AppResponse.fromJson(response.data, OrderDto.convertJson);
      completer.complete(dataResponse.data);
    }).catchError((error) {
      if (error is DioError) {
        completer.completeError((error).response?.data["message"]);
      } else {
        completer.completeError(error);
      }
    });
    return completer.future;
  }
}