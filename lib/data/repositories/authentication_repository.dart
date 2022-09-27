
import '../../common/bases/base_repository.dart';

class AuthenticationRepository extends BaseRepository{
  Future signInRequest(String email, String password) {
    return apiRequest.signIn(email, password);
  }

  Future sigUpRequest(String email, String name, String phone, String password, String address) {
    return apiRequest.signUp(email, name, phone, password, address);
  }
}