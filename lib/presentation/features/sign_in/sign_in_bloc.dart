import 'package:dio/dio.dart';
import 'package:flutter_order_food_nvchung/common/bases/base_event.dart';
import 'package:flutter_order_food_nvchung/data/datasources/local/cache/app_cache.dart';
import 'package:flutter_order_food_nvchung/data/datasources/remote/app_response.dart';
import 'package:flutter_order_food_nvchung/data/datasources/remote/dto/user_dto.dart';
import 'package:flutter_order_food_nvchung/data/repositories/authentication_repository.dart';
import 'package:flutter_order_food_nvchung/presentation/features/sign_in/sign_in_event.dart';
import '../../../common/bases/base_bloc.dart';
import '../../../common/constants/variable_constant.dart';

class SignInBloc extends BaseBloc {
  late AuthenticationRepository _repository;

  void updateRepository(AuthenticationRepository signInRepository) {
    _repository = signInRepository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case SignInEvent:
        _handleSignIn(event as SignInEvent);
        break;
    }
  }
  Future<void> _handleSignIn(SignInEvent event) async {
    loadingSink.add(true);
    try {
      Response response =
          await _repository.signInRequest(event.email, event.password);
      AppResponse<UserDto> userResponse =
          AppResponse.fromJson(response.data, UserDto.fromJson);
     final UserDto? userDto = userResponse.data;
      if (userDto!=null&&response.statusCode==200) {
        AppCache.setString(key: VariableConstant.token, value: userDto.token ?? '');
        progressSink.add(SignInSuccessEvent(message: 'Đăng nhập thành công'));
      }
    }
    on DioError catch (e) {
      // Xử lý lỗi từ server (nếu có)
      if (e.response != null) {
        // Xử lý lỗi từ response của server
        String errorMessage = 'Unknown error occurred.';

        if (e.response!.statusCode == 400|| e.response!.statusCode==500) {
          // Lỗi BadRequest: Có thể là do sai mật khẩu
          messageSink.add(e.message.toString());
          errorMessage = 'Invalid email or password.\n${e.error}';
        }
        // Hiển thị thông báo lỗi
        messageSink.add(errorMessage);
      } else {
        // Xử lý lỗi mạng hoặc lỗi khác
        messageSink.add(e.message);
      }
    }
    catch (e) {
      messageSink.add(e.toString());
      progressSink.add(SignInFailEvent(message: e.toString()));
    }
    loadingSink.add(false);
  }

}
