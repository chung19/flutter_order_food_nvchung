import 'dart:async';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

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
  final StreamController<BaseEvent> _progressController = BehaviorSubject();
  late CartRepository _cartRepository;
  @override
  Stream<BaseEvent> get progressStream => _progressController.stream;
  void updateRepository({required CartRepository cartRepository}) {
    _cartRepository = cartRepository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case FetchCartEvent:
        _fetchCart();
        break;
      case UpdateCartEvent:
        updateCart(event as UpdateCartEvent);
        break;
      case CartConform:
        _cartConform(event as CartConform);
        break;
    }
  }

  void _fetchCart() async {
    loadingSink.add(true);
    try {
      Response response = await _cartRepository.getCart() as Response<dynamic>;
      AppResponse<CartDto> cartResponse = AppResponse.fromJson(
          response.data as Map<String, dynamic>, CartDto.fromJsonFactory);
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
      cartController.sink.addError(e.response?.data["message"] as Object);
      message.sink.add(e.response?.data['message'] as String);
    } catch (e) {
      message.sink.add(e.toString());
    }
    loadingSink.add(false);
  }

  void updateCart(UpdateCartEvent event) async {
    loadingSink.add(true);
    try {
      Response response = await _cartRepository.updateCart(
          event.idCart, event.quantity, event.idProduct) as Response<dynamic>;
      AppResponse<CartDto> cartResponse = AppResponse.fromJson(
          response.data as Map<String, dynamic>, CartDto.fromJsonFactory);
      cartController.sink.add(Cart(
          cartResponse.data?.id,
          cartResponse.data?.products?.map((data) {
            return Product(data.id, data.name, data.address, data.price,
                data.img, data.quantity, data.gallery);
          }).toList(),
          cartResponse.data?.price));
    } on DioError catch (e) {
      cartController.sink.addError(e.response?.data["message"] as String);
      message.sink.add(e.response?.data["message"] as String);
    } catch (e) {
      messageSink.add(e.toString());
    }
    loadingSink.add(false);
  }

  void _cartConform(CartConform event) async {
    loadingSink.add(true);
    try {
      (await _cartRepository.confirmCart(event.idCart));
      cartController.sink.add(Cart("", [], -1));

      progressSink.add(CartConFormSuccessEvent(
        message: "thanh toán thành công",
      ));
    } on DioError catch (e) {
      cartController.sink.addError(e.response?.data["message"] as String);

      message.sink.add(e.response?.data["message"] as String);
    } catch (e) {
      message.sink.add(e.toString());
    }
    loadingSink.add(false);
  }

  @override
  void dispose() {
    super.dispose();
    cartController.close();
    message.close();
    _progressController.close();
  }
}
