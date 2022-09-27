import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_order_food_nvchung/presentation/features/sign_up/sign_up_event.dart';
import 'package:flutter_order_food_nvchung/common/bases/base_event.dart';
import '../../../common/bases/base_bloc.dart';
import '../../../data/datasources/remote/app_response.dart';
import '../../../data/datasources/remote/dto/user_dto.dart';
import '../../../data/model/user.dart';
import '../../../data/repositories/authentication_repository.dart';

class SignUpBloc extends BaseBloc {
  StreamController<User> userData = StreamController();
  late AuthenticationRepository _repository;

  void updateRepository(AuthenticationRepository signInRepository) {
    _repository = signInRepository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case SignUpEvent:
        _handleSignUp(event as SignUpEvent);
        break;
    }
  }

  void _handleSignUp(SignUpEvent event) async {
    loadingSink.add(true);
    try {
      Response response = await _repository.sigUpRequest(
          event.email, event.name, event.phone, event.password, event.address);
      AppResponse<UserDto> userResponse =
          AppResponse.fromJson(response.data, UserDto.fromJson);
      UserDto? userDto = userResponse.data;
      if (userDto != null) {
        User user = User(
            userDto.email,
            userDto.name,
            userDto.phone,
            userDto.registerDate,
            userDto.token);
        userData.sink.add(user);
        progressSink.add(SignUpSuccessEvent(
                            message: "Đăng nhập thành công",
                            password: event.password,
                            email: user.email));
      }
    } on DioError catch (e) {
      messageSink.add(e.response?.data["message"]);
    } catch (e) {
      messageSink.add(e.toString());
    }
    loadingSink.add(false);
  }
}
