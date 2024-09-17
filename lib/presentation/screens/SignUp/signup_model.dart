class SignUpResponse {
  final bool success;
  final String message;
  final String token;

  SignUpResponse({
    required this.success,
    required this.message,
    required this.token,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      success: json['success'],
      message: json['message'],
      token: json['token'],
    );
  }
}
