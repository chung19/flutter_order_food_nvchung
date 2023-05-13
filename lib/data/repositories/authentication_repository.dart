
import '../../common/bases/base_repository.dart';

class AuthenticationRepository extends BaseRepository {
// Hàm signInRequest dùng để gửi request để đăng nhập
  Future<dynamic> signInRequest(String email, String password) {
    return apiRequest.signIn(email, password);
  }

// Hàm sigUpRequest dùng để gửi request để đăng ký tài khoản
  Future<dynamic> sigUpRequest(String email, String name, String phone, String password, String address) {
    return apiRequest.signUp(email, name, phone, password, address);
  }
}