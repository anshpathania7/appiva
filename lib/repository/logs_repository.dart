import 'dart:developer';
import 'dart:io';

import 'package:appiva/models/log_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LogsRepository {
  static final LogsRepository _singleton = LogsRepository._internal();
  factory LogsRepository() {
    return _singleton;
  }
  LogsRepository._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _logsRef = 'Logs';
  final String _userRef = 'User';

  ///Returns true if succesfully logged data
  Future<bool> addLog({required LogModel logModel}) async {
    try {
      await _firestore
          .collection(_userRef)
          .doc(_auth.currentUser!.uid)
          .collection(_logsRef)
          .add(
            logModel.toMap(),
          );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<String?> uploadImage({required File imageFile}) async {
    final uploadFileTask = await _storage
        .ref(_auth.currentUser!.uid)
        .child(Timestamp.now().microsecondsSinceEpoch.toString())
        .putFile(imageFile);
    final imgUrl = await uploadFileTask.ref.getDownloadURL();
    return imgUrl;
  }

  Future<List<LogModel>> getAllLogs() async {
    //
    final querySnapshots = await _firestore
        .collection(_userRef)
        .doc(_auth.currentUser!.uid)
        .collection(_logsRef)
        .get();
    final logModels = List<LogModel>.of(
      querySnapshots.docs.map(
        (doc) => LogModel.fromMap(
          doc.data(),
        ),
      ),
    );
    return logModels;
  }
}
