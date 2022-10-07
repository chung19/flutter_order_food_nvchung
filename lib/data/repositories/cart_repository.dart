import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_order_food_nvchung/data/datasources/remote/dio_client.dart';

import '../../common/bases/base_repository.dart';
import '../../common/constants/api_constant.dart';
import '../datasources/remote/api_request.dart';

class CartRepository extends BaseRepository{
  late Dio _dio;

  CartRepository() {
    _dio = DioClient.instance.dio;
  }
  Future getCart() {
    return apiRequest.getCart();
  }

  Future addCart(String idProduct) {
    // ApiRequest apiRequest =ApiRequest();
    return apiRequest.addCart(idProduct);
  }
  Future updateCart(String idCart, int quantity,String  idProduct){
    return apiRequest.updateCart(idCart, quantity, idProduct);
  }
  Future  confirmCart(String idCart,) {
    return apiRequest.confirmCard(idCart, );
  }

  Future<String> oldconfirm(String idCart) {
    Completer<String> completer = Completer();
    _dio.post(ApiConstant.CART_CONFORM_URL,  data: {
      "id_cart": idCart,
      "status": false})
        .then((response){
      completer.complete(response.data["data"]);
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