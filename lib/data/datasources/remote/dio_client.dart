import 'package:dio/dio.dart';
import '../../../common/constants/api_constant.dart';
import '../../../common/constants/variable_constant.dart';
import '../local/cache/app_cache.dart';

class DioClient {
  Dio? _dio;
  static final BaseOptions _options = BaseOptions(
    baseUrl: ApiConstant.baseUrl,
    connectTimeout: 30000,
    receiveTimeout: 30000,
  );

  static final DioClient instance = DioClient._internal();

  DioClient._internal() {
    if (_dio == null) {
      _dio = Dio(_options);
      _dio?.interceptors.add(LogInterceptor(requestBody: true));
      _dio?.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        String token = AppCache.getString(VariableConstant.token);
        if (token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      }, onResponse: (response, handler) {
        return handler.next(response);
      }, onError: (e, handler) {
        return handler.next(e);
      }));
    }
  }

  Dio get dio => _dio!;
}
