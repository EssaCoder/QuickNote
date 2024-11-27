class User {
  const User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'],
        username: map['username']?.toString(),
        lastName: map['lastName']?.toString(),
        firstName: map['firstName']?.toString(),
      );

  final String id;
  final String? username;
  final String? firstName;
  final String? lastName;

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'lastName': lastName,
        'firstName': firstName,
      };
}
