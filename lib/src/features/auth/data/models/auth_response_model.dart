class AuthResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  AuthResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'],
    );
  }
}
