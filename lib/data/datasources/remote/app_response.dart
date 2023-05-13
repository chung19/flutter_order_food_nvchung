class AppResponse<T> {

  AppResponse({this.message, this.data});

  AppResponse.fromJson(Map<String, dynamic> json, Function parseModel) {
    message = json['message'].toString();
    data = parseModel(json['data'] ) as T ;
  }
  String? message;
  T? data;
}
