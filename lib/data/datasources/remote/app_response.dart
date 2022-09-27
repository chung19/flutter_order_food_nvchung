class AppResponse<T> {
  String? message;
  T? data;

  AppResponse({this.message, this.data});

  AppResponse.fromJson(Map<String, dynamic> json, Function parseModel) {
    message = json['message'];
    data = parseModel(json['data']);
  }
}