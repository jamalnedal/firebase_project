import 'package:firebase_storage/firebase_storage.dart';

enum Process { create, delete }

abstract class StorageState {}

class LoadingState extends StorageState {}

class ReadImagesState extends StorageState {
  List<Reference> references;

  ReadImagesState(this.references);
}

class ProcessState extends StorageState {
  Process process;
  bool status;
  String message;

  ProcessState(this.process, this.status, this.message);
}
