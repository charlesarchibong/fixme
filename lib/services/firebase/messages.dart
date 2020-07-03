import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickfix/modules/chat/model/message.dart';

class MessageService {
  final String messageId;

  MessageService({this.messageId});

  final CollectionReference _collectionReference =
      Firestore.instance.collection('messages');

  Future updateMessage(Message message) async {
    return await _collectionReference
        .document(getChatNode(
          message.senderPhone,
          message.receiverPhone,
        ))
        .collection(getChatNode(
          message.senderPhone,
          message.receiverPhone,
        ))
        .document(this.messageId)
        .setData(
          message.toMap(),
        );
  }

  Stream<List<Message>> getMessages(String sender, String receiver) {
    return _collectionReference
        .document(getChatNode(sender, receiver))
        .collection(getChatNode(sender, receiver))
        .orderBy('time', descending: true)
        .snapshots()
        .map(_convertMessageToListStream);
  }

  String getChatNode(String sender, String receiver) {
    if (sender.hashCode <= receiver.hashCode) {
      return sender + '-' + receiver;
    } else {
      return receiver + '-' + sender;
    }
  }

  List<Message> _convertMessageToListStream(QuerySnapshot querySnapshot) {
    return querySnapshot.documents
        .map((doc) => Message.fromMap(doc.data))
        .toList();
  }
}
