import 'dart:async';
import 'package:dio/dio.dart';
import '../../../common/bases/base_bloc.dart';
import '../../../common/bases/base_event.dart';
import '../../../data/datasources/remote/app_response.dart';
import '../../../data/datasources/remote/dto/cart_dto.dart';
import '../../../data/model/cart.dart';
import '../../../data/model/product.dart';
import '../../../data/repositories/cart_repository.dart';
import 'cart_event.dart';
class CartBloc extends BaseBloc {
  StreamController<Cart> cartController = StreamController();
  StreamController<String> message = StreamController();
  late CartRepository _cartRepository;

  void updateRepository({required CartRepository cartRepository}) {
    _cartRepository = cartRepository;

  }

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case FetchCartEvent:
        fetchCart();
        break;
      case UpdateCartEvent:
        updateCart(event as UpdateCartEvent);
        break;
      case CartConform:
       oldconform(event as CartConform);
        break;
    }
  }


  void fetchCart() async {
    loadingSink.add(true);
    try {
      Response response = await _cartRepository.getCart();
      AppResponse<CartDto> cartResponse =
      AppResponse.fromJson(response.data, CartDto.convertJson);
      Cart cart = Cart(
        cartResponse.data?.id,
        cartResponse.data?.products?.map((dto) {
          return Product(dto.id, dto.name, dto.address, dto.price, dto.img,
              dto.quantity, dto.gallery);
        }).toList(),
        cartResponse.data?.price,
        cartResponse.data?.idUser,
      );
      cartController.sink.add(cart);
    } on DioError catch (e) {
      cartController.sink.addError(e.response?.data["message"]);
      messageSink.add(e.response?.data["message"]);
    } catch (e) {
      messageSink.add(e.toString());
    }
    loadingSink.add(false);
  }

  void updateCart(UpdateCartEvent event)  async{
    loadingSink.add(true);
    try{
    Response response = await  _cartRepository.updateCart(event.idCart, event.quantity, event.idProduct);
    AppResponse<CartDto> cartResponse =
    AppResponse.fromJson(response.data, CartDto.convertJson);
      cartController.sink.add(Cart(
          cartResponse.data?.id,
          cartResponse.data?.products?.map((data) {
            return Product(data.id, data.name, data.address, data.price,
                data.img, data.quantity, data.gallery);
          }).toList(),
          cartResponse.data?.price));
     }
     on DioError catch (e) {
  cartController.sink.addError(e.response?.data["message"]);
  messageSink.add(e.response?.data["message"]);
  } catch (e) {
  messageSink.add(e.toString());
  }
  loadingSink.add(false);
}

  void conform(CartConform event) async {
    loadingSink.add(true);
    try{
      Response response = (await  _cartRepository.confirmCart(event.idCart)) as Response;
    AppResponse.fromJson(response.data, CartDto.convertJson);
      cartController.sink.add(Cart("", [], -1));
    } on DioError catch (e) {
      cartController.sink.addError(e.response?.data["message"]);

      messageSink.add(e.response?.data["message"]);
    } catch (e) {
      messageSink.add(e.toString());
    }
    loadingSink.add(false);
  }
  void  oldconform(CartConform event) {
    loadingSink.add(true);
    _cartRepository.oldconfirm(event.idCart).then((cartData) {
      cartController.sink.add(Cart("", [], -1));
    }).catchError((e) {
      message.sink.add(e);
    }).whenComplete(() => loadingSink.add(false));
  }
  @override
  void dispose() {
    super.dispose();
    cartController.close();
    message.close();
  }
}
