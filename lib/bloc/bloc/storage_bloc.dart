import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vp9_firebase/bloc/events/storage_event.dart';
import 'package:vp9_firebase/bloc/states/storage_state.dart';
import 'package:vp9_firebase/controllers/fb_storage_controller.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final FbStorageController fbStorageController = FbStorageController();
  List<Reference> references = <Reference>[];

  StorageBloc(StorageState initialState) : super(initialState) {
    on<UploadImageEvent>(_onUploadImage);
    on<DeleteImageEvent>(_onDeleteImage);
    on<ReadImagesEvent>(_onReadImages);
  }

  void _onUploadImage(UploadImageEvent event, Emitter emitter) async {
    fbStorageController.uploadImage(path: event.path).listen((event) {
      if (event.state == TaskState.success) {
        references.add(event.ref);
        emitter(ReadImagesState(references));
        emitter(
            ProcessState(Process.create, true, 'Image uploaded successfully'));
      } else {
        emitter(ProcessState(Process.create, false, 'Image upload failed!'));
      }
    }).asFuture();
  }

  void _onReadImages(ReadImagesEvent event, Emitter emitter) async {
    references = await fbStorageController.read();
    emitter(ReadImagesState(references));
  }

  void _onDeleteImage(DeleteImageEvent event, Emitter emitter) async {
    bool deleted = await fbStorageController.delete(path: event.path);
    if (deleted) {
      int index =
          references.indexWhere((element) => element.fullPath == event.path);
      if (index != -1) {
        references.removeAt(index);
        emitter(ReadImagesState(references));
      }
    }
    emitter(
      ProcessState(
        Process.delete,
        deleted,
        deleted ? 'Deleted successfully' : 'Delete failed',
      ),
    );
  }
}
