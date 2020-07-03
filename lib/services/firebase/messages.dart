import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickfix/modules/chat/model/message.dart';

class MessageService {
  final String messageId;

  MessageService({this.messageId});

  final CollectionReference _collectionReference =
      Firestore.instance.collection('messages');

  Future updateMessage(Message message) async {
    return await _collectionReference.document(this.messageId).setData(
          message.toMap(),
        );
  }

  Stream<List<Message>> getMessages(String sender, String receiver) {
    return _collectionReference
        .orderBy('time', descending: true)
        .where('senderPhone', isEqualTo: sender)
        .where(
          'receiverPhone',
          isEqualTo: receiver,
        )
        .snapshots()
        .map(_convertMessageToListStream);
  }

  List<Message> _convertMessageToListStream(QuerySnapshot querySnapshot) {
    return querySnapshot.documents
        .map((doc) => Message.fromMap(doc.data))
        .toList();
  }
}
