class Message {
  final String id;
  final String senderPhone;
  final String receiverPhone;
  final int time;
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    this.id,
    this.senderPhone,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
    this.receiverPhone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderPhone': senderPhone,
      'receiverPhone': receiverPhone,
      'time': time,
      'text': text,
      'isLiked': isLiked,
      'unread': unread,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Message(
      id: map['id'],
      senderPhone: map['senderPhone'],
      receiverPhone: map['receiverPhone'],
      time: map['time'],
      text: map['text'],
      isLiked: map['isLiked'],
      unread: map['unread'],
    );
  }
}
