import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vp9_firebase/models/note.dart';

class FbFireStoreController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> create({required Note note}) async {
    return await _firebaseFirestore
        .collection('Notes')
        .add(note.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Stream<QuerySnapshot> read() async* {
    yield* _firebaseFirestore.collection('Notes').snapshots();
  }

  Future<bool> update({required Note note}) async {
    return await _firebaseFirestore
        .collection('Notes')
        .doc(note.id)
        .update(note.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> delete({required String id}) async {
    return await _firebaseFirestore
        .collection('Notes')
        .doc(id)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }
}
