class AllUsers{
  final String id;
  final String username;
  final String email;
  final String password;
  final String role;
  final String status;


  AllUsers({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    required this.status
  }) ;

  factory AllUsers.fromJson(Map<String, dynamic> json) {
    return AllUsers(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      status: json['status']

    );
  }

}