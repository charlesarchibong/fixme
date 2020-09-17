import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

const RECEIVER = 'receiver';
const READ = 'read';

class MessageCount {
  final CollectionReference messageCountCollection;
  final String messageId;
  MessageCount({
    @required this.messageCountCollection,
    this.messageId,
  });

  Future<void> setMessageCount({
    @required String receiver,
    @required bool read,
  }) async {
    return messageCountCollection.doc(this.messageId).set({
      '$RECEIVER': receiver,
      '$READ': read,
    });
  }

  Stream<QuerySnapshot> getMessageCount(
      {@required String receiver, @required bool isRead}) {
    return messageCountCollection
        .where(
          '$RECEIVER',
          isEqualTo: receiver,
        )
        .where(
          '$READ',
          isEqualTo: isRead,
        )
        .snapshots();
  }

  Stream<DocumentSnapshot> getMessage() {
    return messageCountCollection.doc(messageId).snapshots();
  }
}
