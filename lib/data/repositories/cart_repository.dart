import 'dart:async';
import 'package:dio/dio.dart';
import '../../common/bases/base_repository.dart';
import '../../common/constants/api_constant.dart';
import '../datasources/remote/api_request.dart';
import '../datasources/remote/app_response.dart';
import '../datasources/remote/dto/cart_dto.dart';

class CartRepository extends BaseRepository{

  @override
  ApiRequest apiRequest= ApiRequest();
  late Dio _dio;



  Future getCart() {
    return apiRequest.getCart();
  }
  // Future fetchCart() {
  //   return apiRequest.fetchCart();
  // }
  Future<CartDto> fetchCart() {
    Completer<CartDto> completer = Completer();
    apiRequest.getCart().then((response){
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
  Future addCart(String idProduct) {
    return apiRequest.addCart(idProduct);
  }
  Future updateCart(String idCart, int quantity,String  idProduct){
    return apiRequest.updateCart(idCart, quantity, idProduct);
  }
  Future confirmCart(String idCart) {
    return apiRequest.confirmCard(idCart);
  }


}