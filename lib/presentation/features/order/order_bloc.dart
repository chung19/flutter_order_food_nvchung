import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_order_food_nvchung/common/bases/base_bloc.dart';
import 'package:flutter_order_food_nvchung/common/bases/base_event.dart';
import 'package:flutter_order_food_nvchung/data/datasources/remote/dto/order_dto.dart';
import 'package:flutter_order_food_nvchung/data/datasources/remote/dto/product_dto.dart';
import 'package:flutter_order_food_nvchung/data/repositories/order_repository.dart';
import 'package:flutter_order_food_nvchung/presentation/features/order/order_event.dart';
import '../../../data/datasources/remote/app_response.dart';
import '../../../data/model/order.dart';
import '../../../data/model/product.dart';

class OrderBloc extends BaseBloc {
  StreamController<List<Order>> orderController = StreamController.broadcast();
  StreamController<String> message = StreamController();
  late OrderRepository _orderRepository;
  late ProductDto productDto;
  void updateRepository({required OrderRepository orderRepository}) {
    _orderRepository = orderRepository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case FetchOrderEvent:
       oldFetchOrder(event as FetchOrderEvent);
        break;
    }
  }
  void fetchOrder(FetchOrderEvent event)async{
    loadingSink.add(true);
    try {
      Response response = await _orderRepository.getOrder();
      AppResponse<Order> orderListsData =
      AppResponse.fromJson(response.data, OrderDto.convertJson);
    //   orderController.sink.add (Order(
    //     orderListsData.data?.id ,
    // orderListsData.data?.products?.map((productDto) {
    //   => Product(
    //       productDto.id,
    //       productDto.name,
    //       productDto.address,
    //       productDto.price,
    //       productDto.img,
    //       productDto.quantity,
    //       productDto.gallery);
    // });
    // orderListsData.data?.img ,
    // orderListsData.data?.price ,
    // orderListsData.data?.status ,
    // orderListsData.data?.date_created
    //   ) );



    }on DioError catch (e) {
      orderController.sink.addError(e.response?.data["message"]);
      messageSink.add(e.response?.data["message"]);
    } catch (e) {
      messageSink.add(e.toString());
    }
    loadingSink.add(false);
  }
  void oldFetchOrder(  FetchOrderEvent event) {
    loadingSink.add(true);
    _orderRepository.fetchOrderHistory().then((orderListsData) {
      orderController.sink.add(orderListsData.map((order) {
        return Order(
            order.id,
            order.products
                ?.map((productDto) => Product(
                productDto.id,
                productDto.name,
                productDto.address,
                productDto.price,
                productDto.img,
                productDto.quantity,
                productDto.gallery))
                .toList(),
            order.img,
            order.price,
            order.status,
            order.date_created);
      }).toList());
    }).catchError((e) {
      message.sink.add(e);
    }).whenComplete(() => loadingSink.add(false));
  }



}
