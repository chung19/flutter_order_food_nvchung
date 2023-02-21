import 'dart:async';
import 'dart:isolate';
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
import '../../../data/model/order.dart';
import '../../../data/repositories/cart_repository.dart';

class HomeBloc extends BaseBloc {
  StreamController<List<Product>> listProductController = StreamController.broadcast();
  StreamController<Cart> cartController = StreamController();
  StreamController<Order> orderController = StreamController();
  StreamController<String> message = StreamController();
  late   ProductRepository _repository;
  late  CartRepository _cartRepository;

  void updateProductRepository(
      {required ProductRepository productRepository,
      required CartRepository cartRepository}) {
    _repository = productRepository;
    _cartRepository = cartRepository;
  }

  @override
  void dispatch(BaseEvent event) {
    if (event is GetListProductEvent) {
      _getListProductBase();
    } else if (event is FetchCartEvent) {
      _fetchCartBase();
    } else if (event is AddCartEvent) {
      _addCartBase(event);
    }
  }





// Hàm getListProduct dùng để lấy danh sách sản phẩm từ Repository
  void _getListProductBase() async {
    final data = await handleResponse<List<ProductDto>>(
        _repository.getListProducts(),
        ProductDto.convertJson
    );
    if (data != null) {
      final products = data.map((dto) => Product(dto.id, dto.name, dto.address, dto.price, dto.img, dto.quantity, dto.gallery)).toList();
      listProductController.sink.add(products);
    }
  }


  void _getListProduct() async {
    // Thông báo cho người dùng biết đang xử lý yêu cầu
    loadingSink.add(true);
    try {
      // Gửi yêu cầu lấy danh sách sản phẩm
      Response response = await _repository.getListProducts();
      // Chuyển đổi dữ liệu từ JSON sang danh sách sản phẩm
      List<ProductDto> listProductResponse =
          AppResponse.fromJson(response.data, ProductDto.convertJson).data;
      List<Product> products = listProductResponse
          .map((dto) => Product(dto.id, dto.name, dto.address, dto.price, dto.img, dto.quantity, dto.gallery))
          .toList();
      // Trả về danh sách sản phẩm cho người dùng
      listProductController.sink.add(products);
    } on DioError catch (e) {
      // Hiển thị thông báo lỗi nếu có lỗi xảy ra
      messageSink.add(e.response?.data["message"]);
// Hoặc thông báo lỗi mặc định nếu không có thông tin lỗi trả về
          messageSink.add(e.message);
    } finally {
// Thông báo cho người dùng biết việc xử lý yêu cầu đã kết thúc
      loadingSink.add(false);
    }
  }

// add product to product
  void _addCart(AddCartEvent event) async {
    loadingSink.add(true);
    try {
      Response response = await _cartRepository.addCart(event.idProduct);
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
  void _addCartBase(AddCartEvent event) async {
    final data = await handleResponse<CartDto>(
        _cartRepository.addCart(event.idProduct), CartDto.convertJson);
    if (data != null) {
      Cart cart = Cart(
        data.id,
        data.products?.map((dto) {
          return Product(dto.id, dto.name, dto.address, dto.price, dto.img,
              dto.quantity, dto.gallery);
        }).toList(),
        data.price,
        data.idUser,
      );
      cartController.sink.add(cart);
    }
  }
void _fetchCartBase()async{
  final data = await handleResponse<CartDto>(_cartRepository.getCart(), CartDto.convertJson);
  if (data != null) {
    Cart cart = Cart(
      data.id,
      data.products?.map((dto) {
        return Product(dto.id, dto.name, dto.address, dto.price, dto.img,
            dto.quantity, dto.gallery);
      }).toList(),
      data.price,
      data.idUser,
    );
    cartController.sink.add(cart);
  }
}

  // void _fetchCart(fetchCartEvent ) async {
  //   loadingSink.add(true);
  //   try {
  //     Response response = await _repository.getCart();
  //     AppResponse<CartDto> cartResponse =
  //         AppResponse.fromJson(response.data, CartDto.convertJson);
  //     Cart cart = Cart(
  //       cartResponse.data?.id,
  //       cartResponse.data?.products?.map((dto) {
  //         return Product(dto.id, dto.name, dto.address, dto.price, dto.img,
  //             dto.quantity, dto.gallery);
  //       }).toList(),
  //       cartResponse.data?.price,
  //       cartResponse.data?.idUser,
  //     );
  //     cartController.sink.add(cart);
  //   } on DioError catch (e) {
  //     cartController.sink.addError(e.response?.data["message"]);
  //     messageSink.add(e.response?.data["message"]);
  //   } catch (e) {
  //     messageSink.add(e.toString());
  //   }
  //   loadingSink.add(false);
  // }





  @override
  void dispose() {
    super.dispose();
    listProductController.close();
    cartController.close();
    message.close();
  }
}
