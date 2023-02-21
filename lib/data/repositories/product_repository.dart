

import '../../common/bases/base_repository.dart';
import '../../common/constants/api_constant.dart';
import 'dart:isolate';
import 'dart:convert';
import 'package:dio/dio.dart';
class ProductRepository extends BaseRepository{


  Future getListProducts() {
    return apiRequest.getProducts();
  }

  Future getCart() {
    return apiRequest.getCart();
  }
}