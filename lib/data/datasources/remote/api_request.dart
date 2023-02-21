import 'dart:async';

import 'package:dio/dio.dart';

import '../../../common/constants/api_constant.dart';
import 'dio_client.dart';


class ApiRequest {
  late Dio _dio;

  ApiRequest() {
    _dio = DioClient.instance.dio;
  }

  Future signIn(String email, String password) {
    return _dio.post(ApiConstant.signInUrl,
        data: {"email": email, "password": password});
  }

  Future signUp(String email, String name, String phone, String password,
      String address) {
    return _dio.post(ApiConstant.signUpUrl, data: {
      "email": email,
      "password": password,
      "phone": phone,
      "name": name,
      "address": address
    });
  }

  Future getProducts() {
    return _dio.get(ApiConstant.listProductUrl);
  }

  Future getCart() {
    return _dio.get(ApiConstant.cartUrl);
  }

  Future getOrder( ) {
    return _dio.get(ApiConstant.orderHistoryCart);
  }

  Future addCart(String idProduct) {
    return _dio.post(ApiConstant.addCartUrl, data: {"id_product": idProduct});
  }

  Future updateCart(String idCart, int quantity, String idProduct) {

   return _dio.post(ApiConstant.updateCartUrl, data: {
      "id_product": idProduct,
      "id_cart": idCart,
      "quantity": quantity
    });

  }

  Future confirmCard (String idCart ) {
  return  _dio.post(ApiConstant.conformCartUrl,
        data: {"id_cart": idCart, "status": false});

  }
}
