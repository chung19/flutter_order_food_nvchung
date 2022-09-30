import 'dart:async';
import 'package:flutter_order_food_nvchung/common/bases/base_bloc.dart';
import 'package:flutter_order_food_nvchung/common/bases/base_event.dart';
import 'package:flutter_order_food_nvchung/data/repositories/order_repository.dart';
import 'package:flutter_order_food_nvchung/presentation/features/order/order_event.dart';
import '../../../data/model/order.dart';
import '../../../data/model/product.dart';

class OrderBloc  extends BaseBloc
{
  StreamController <List<Order>>orderController = StreamController();
  StreamController<String> message = StreamController();
  late OrderRepository _orderRepository;
  void updateRepository({required OrderRepository orderRepository}) {
    _orderRepository = orderRepository;
  }
  @override
  void dispatch(BaseEvent event) {
    switch(event.runtimeType){
      case FetchOrderEvent:
       fetchOrder( );
        break;
    }
  }
  void fetchOrder() {
    loadingSink.add(true);
    _orderRepository.fetchOrderHistory().then((orderListsData) {
      orderController.sink.add(orderListsData.map((order) {
        return Order(
            order.id,
            order.products
                ?.map((ProductDto) => Product(
                ProductDto.id,
                ProductDto.name,
                ProductDto.address,
                ProductDto.price,
                ProductDto.img,
                ProductDto.quantity,
                ProductDto.gallery))
                .toList(),
            order.price,
            order.status,
            order.date_created);
      }).toList());
    }).catchError((e) {
      message.sink.add(e);
    }).whenComplete(() => loadingSink.add(false));
  }



}