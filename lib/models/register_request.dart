class RegisterRequest {
  RegisterRequest({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  final String username;
  final String password;
  final String? firstName;
  final String? lastName;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      };
}
