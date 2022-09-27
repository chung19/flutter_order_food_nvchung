import 'package:flutter_order_food_nvchung/common/bases/base_event.dart';
abstract class HomeEvent extends BaseEvent {}
class GetListProductEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class FetchCartEvent extends  HomeEvent {
  @override
  List<Object?> get props => [];
}

class  AddCartEvent extends  HomeEvent {

  String idProduct;

  AddCartEvent({required this.idProduct});

  @override
  List<Object?> get props => [idProduct];
}
