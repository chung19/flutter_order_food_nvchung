import 'dart:async';

import 'package:dio/dio.dart';

import '../../../common/constants/api_constant.dart';
import 'app_response.dart';
import 'dio_client.dart';
import 'dto/cart_dto.dart';

class ApiRequest {
  late Dio _dio;

  ApiRequest() {
    _dio = DioClient.instance.dio;
  }

  Future signIn(String email, String password) {
    return _dio.post(ApiConstant.SIGN_IN_URL,
        data: {"email": email, "password": password});
  }

  Future signUp(String email, String name, String phone, String password,
      String address) {
    return _dio.post(ApiConstant.SIGN_UP_URL, data: {
      "email": email,
      "password": password,
      "phone": phone,
      "name": name,
      "address": address
    });
  }

  Future getProducts() {
    return _dio.get(ApiConstant.LIST_PRODUCT_URL);
  }

  Future getCart() {
    return _dio.get(ApiConstant.CART_URL);
  }

  Future getOrder() {
    return _dio.get(ApiConstant.ORDER_HISTORY_URL);
  }

  Future addCart(String idProduct) {
    return _dio.post(ApiConstant.ADD_CART_URL, data: {"id_product": idProduct});
  }

  Future updateCart(String idCart, int quantity, String idProduct) {

   return _dio.post(ApiConstant.CART_UPDATE_URL, data: {
      "id_product": idProduct,
      "id_cart": idCart,
      "quantity": quantity
    });

  }

  Future  confirmCard (String idCart) {
  return  _dio.post(ApiConstant.CART_CONFORM_URL,
        data: {"id_cart": idCart, "status": false});

  }
}
