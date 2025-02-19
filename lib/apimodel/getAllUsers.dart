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
      id: json['_id'] ?? "",
      username: json['name'] ?? "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      role: json['role'] ?? "",
      status: json['status'] ?? "",

    );
  }
  static AllUsers defaultUser() {
    return AllUsers(id: '_id', username: 'name', email: 'email', password: 'password', role: 'role', status: 'status');
  }
}

//fetch all session
class AllSessions{
  final String id;
  final String hostid;
  // final String username;
  final String status;

  AllSessions({
    required this.id,
    required this.hostid,
    // required this.username,
    required this.status});

  factory AllSessions.fromJson(Map<String, dynamic> json) {
    return AllSessions(
      id: json['_id'].toString() ?? 'Unknown_ID',

      hostid: json['hostId'] ?? 'Unknown_HostID',

      // username: json['hostId']?['username'] ?? 'Unknown User',

      status: json['status'] ?? 'Inactive',
    );
  }
}
//fetch previous messages
// class PreviousMessages {
//   // final String message;
//   final String senderId;
//   final String content;
//   final String senderName;
//   final String createdAt;
//
//   PreviousMessages(
//       {required this.senderId,
//         required this.content,
//         required this.senderName,
//         required this.createdAt});
//
//   factory PreviousMessages.fromJson(Map<String, dynamic> json) {
//     // print("Raw JSON for PreviousMessages: $json"); // Debugging
//
//     return PreviousMessages(
//       senderId: json['sender']?['id']?.toString() ?? 'Unknown_Sender_ID',
//       senderName: json['sender']?['username'] ?? 'Unknown User',
//       content: json['content'] ?? '[No Content]',
//       createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
//     );
//   }
// }