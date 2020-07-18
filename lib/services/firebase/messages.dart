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
        .collection('chats')
        .document(this.messageId)
        .setData(
          message.toMap(),
        );
  }

  Stream<List<Message>> getMessages(String sender, String receiver) {
    return _collectionReference
        .document(getChatNode(sender, receiver))
        .collection('chats')
        .orderBy('time', descending: true)
        .snapshots()
        .map(_convertMessageToListStream);
  }

//   Stream<QuerySnapshot> getAllUserUnRead() {
//     return _collectionReference.getDocuments().then((value) {
// value.documents.length
//     });
//   }

  getUserChats(String phone) async {
    return _collectionReference
        .where('receiverPhone', arrayContains: phone)
        .snapshots();
  }

  List<Message> getUnRead(QuerySnapshot querySnapshot) {
    querySnapshot.documents.forEach((element) {
      element.reference.collection('chats').snapshots();
    });
  }

  // Stream<List<Message>> getPendingMessages(String id, String userPhone) {
  //   return getAllUserUnRead().listen((event) {
  //     event.map((map) {
  //       return _collectionReference
  //           .document(map)
  //           .collection(map)
  //           .where('receiverPhone', isEqualTo: userPhone)
  //           .orderBy('time', descending: true)
  //           .snapshots()
  //           .map(_convertMessageToListStream);
  //     });
  //   });
  // }

  // Stream<Stream<List<Message>>> _documentIn(QuerySnapshot snapshot) async* {
  //   for (var i = 0; i < snapshot.documents.length; i++) {
  //     yield _collectionReference
  //         .document(snapshot.documents[i].documentID)
  //         .collection(snapshot.documents[i].documentID)
  //         .where('receiverPhone', isEqualTo: '9039311559')
  //         .orderBy('time', descending: true)
  //         .snapshots()
  //         .map(_convertMessageToListStream);
  //   }
  // }
  // List<String> _documentIn(QuerySnapshot snapshot) {
  //   return snapshot.documents.map((doc) {
  //     return doc.documentID;
  //   }).toList();
  // }

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
