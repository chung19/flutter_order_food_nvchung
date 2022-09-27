import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_order_food_nvchung/common/bases/base_bloc.dart';
import 'package:flutter_order_food_nvchung/common/bases/base_event.dart';
import 'package:flutter_order_food_nvchung/data/datasources/remote/dto/cart_dto.dart';
import 'package:flutter_order_food_nvchung/data/model/cart.dart';
import 'package:flutter_order_food_nvchung/data/model/product.dart';
import 'package:flutter_order_food_nvchung/data/repositories/product_repository.dart';
import 'package:flutter_order_food_nvchung/presentation/features/home/home_event.dart';
import '../../../data/datasources/remote/app_response.dart';
import '../../../data/datasources/remote/dto/product_dto.dart';
import '../../../data/repositories/cart_repository.dart';

class HomeBloc extends BaseBloc {
  StreamController<List<Product>> listProductController = StreamController();
  StreamController<Cart> cartController = StreamController.broadcast();
  StreamController<String> message = StreamController();
  late ProductRepository _repository;
  late CartRepository _cartRepository;
  void updateProductRepository(
      {required ProductRepository productRepository,
        required CartRepository cartRepository}) {
    _repository = productRepository;
    _cartRepository = cartRepository;
  }

  @override
  void dispatch(BaseEvent event) {
    if (event is GetListProductEvent) {
      _getListProduct();
    } else if ( event is FetchCartEvent) {
      _fetchCart();
    }
    else if (event is AddCartEvent  ){
      _addCart(event);
    }

  }

  void _getListProduct( ) async {
    loadingSink.add(true);
    try {
      Response response = await _repository.getListProducts();
      AppResponse<List<ProductDto>> listProductResponse =
      AppResponse.fromJson(response.data, ProductDto.convertJson);
      List<Product>? listProduct = listProductResponse.data?.map((dto) {
        return Product(dto.id, dto.name, dto.address, dto.price, dto.img,
            dto.quantity, dto.gallery);
      }).toList();
      listProductController.add(listProduct ?? []);
    } on DioError catch (e) {
      messageSink.add(e.response?.data["message"]);
    } catch (e) {
      messageSink.add(e.toString());
    }
    loadingSink.add(false);
  }

  void _addCart(AddCartEvent event) {
    loadingSink.add(true);
    _cartRepository
        .addCart(event.idProduct)
        .then((cartData) => cartController.sink.add(Cart(
        cartData.id,
        cartData.products
            ?.map((model) => Product(model.id, model.name, model.address,
            model.price, model.img, model.quantity, model.gallery))
            .toList(),
        cartData.price)))
        .catchError((e) {
      message.sink.add(e.toString());
    }).whenComplete(() => loadingSink.add(false));
  }

//get cart == get all  value card
//   void _fetchCart(GetCartEvent event) {
//     loadingSink.add(true);
//       _cartRepository
//         .fetchCard()
//         .then((cartData) => cartController.sink.add(Cart(
//         cartData.id,
//         cartData.products
//             ?.map((model) => Product(
//             model.id,
//             model.name,
//             model.address,
//             model.price,
//             model.img,
//             model.quantity,
//             model.gallery))
//             .toList(),
//         cartData.price)))
//         .catchError((e) {
//       message.sink.add(e.toString());
//     }).whenComplete(() => loadingSink.add(false));
//   }

  void _fetchCart() async {
    loadingSink.add(true);
    try {
      Response response = await _repository.getCart();
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
  @override
  void dispose() {
    super.dispose();
    listProductController.close();
    cartController.close();
    message.close();

  }
}
