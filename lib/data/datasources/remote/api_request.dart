import 'dart:async';

import 'package:dio/dio.dart';

import '../../../common/constants/api_constant.dart';
import 'app_response.dart';
import 'dio_client.dart';
import 'dto/cart_dto.dart';

class ApiRequest  {
  late Dio _dio;

  ApiRequest(){
    _dio = DioClient.instance.dio;
  }

  Future signIn(String email, String password) {
    return _dio.post(ApiConstant.SIGN_IN_URL, data: {
      "email": email,
      "password": password
    });
  }

  Future signUp(String email, String name, String phone, String password, String address) {
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
  Future<CartDto> fetchCart() {
    Completer<CartDto> completer = Completer();
    getCart().then((response){
      AppResponse<CartDto> dataResponse = AppResponse.fromJson(response.data, CartDto.convertJson);
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
  Future<CartDto> addCart(String idProduct) {
    Completer<CartDto> completer = Completer();
    _dio.post(ApiConstant.ADD_CART_URL,  data: {
      "id_product": idProduct
    })
        .then((response){
      AppResponse<CartDto> dataResponse = AppResponse.fromJson(response.data, CartDto.convertJson);
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
  Future<CartDto> updateCart(String idCart, int quantity, String idProduct) {
    Completer<CartDto> completer = Completer();
    _dio.post(ApiConstant.CART_UPDATE_URL,  data: {
      "id_product": idProduct,
      "id_cart": idCart,
      "quantity": quantity})
        .then((response){
      AppResponse<CartDto> dataResponse = AppResponse.fromJson(response.data, CartDto.convertJson);
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
  Future<String> confirmCard(String idCart) {
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