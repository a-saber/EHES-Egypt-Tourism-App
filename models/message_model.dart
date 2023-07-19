class MessageModel {
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? messageId;
  String? text;

  MessageModel({
    this.senderId,
    this.receiverId,
    this.dateTime,
    this.messageId,
    this.text,
  });
  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    text = json['text'];
    messageId = json['messageId'];
  }
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
      'text': text ?? "",
      'messageId': messageId ,

    };
  }
}
