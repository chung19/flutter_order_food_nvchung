import 'dart:async';

import 'package:dio/dio.dart';

import '../../../common/constants/api_constant.dart';
import 'dio_client.dart';


class ApiRequest {

  ApiRequest() {
    _dio = DioClient.instance.dio;
  }
  late Dio _dio;

  Future<dynamic> signIn(String email, String password) {
    return _dio.post(ApiConstant.signInUrl,
        data: {'email': email, 'password': password});
  }

  Future<dynamic> signUp(String email, String name, String phone, String password,
      String address) {
    return _dio.post(ApiConstant.signUpUrl, data: {
      'email': email,
      'password': password,
      'phone': phone,
      'name': name,
      'address': address
    });
  }

  Future<dynamic> getProducts() {
    return _dio.get(ApiConstant.listProductUrl);
  }

  Future<dynamic>  getCart() {
    return _dio.get(ApiConstant.cartUrl);
  }

  Future<dynamic>  getOrder( ) {
    return _dio.get(ApiConstant.orderHistoryCart);
  }

  Future<dynamic>  addCart(String idProduct) {
    return _dio.post(ApiConstant.addCartUrl, data: {'id_product': idProduct});
  }

  Future<dynamic>  updateCart(String idCart, int quantity, String idProduct) {

   return _dio.post(ApiConstant.updateCartUrl, data: {
      'id_product': idProduct,
      'id_cart': idCart,
      'quantity': quantity
    });

  }

  Future<dynamic>  confirmCard (String idCart ) {
  return  _dio.post(ApiConstant.conformCartUrl,
        data: {'id_cart': idCart, 'status': false});

  }
}
