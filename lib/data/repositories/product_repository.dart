
import '../../common/bases/base_repository.dart';

class ProductRepository extends BaseRepository{

  Future getListProducts() {
    return apiRequest.getProducts();
  }

  Future getCart() {
    return apiRequest.getCart();
  }
}