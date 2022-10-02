import 'dart:async';
import '../../common/bases/base_repository.dart';
import '../datasources/remote/api_request.dart';

class CartRepository extends BaseRepository{

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
  Future confirmCart(String idCart) {
    return apiRequest.confirmCard(idCart);
  }


}