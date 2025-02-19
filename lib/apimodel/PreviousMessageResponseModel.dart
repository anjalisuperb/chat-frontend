class PreviousMessageModel {
  String? message;
  List<Messages>? messages;

  PreviousMessageModel({this.message, this.messages});

  PreviousMessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  String? content;
  Sender? sender;
  String? createdAt;

  Messages({this.content, this.sender, this.createdAt});

  Messages.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    sender =
    json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class Sender {
  String? id;
  String? name;
  String? username;

  Sender({this.id, this.name, this.username});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    return data;
  }
}
