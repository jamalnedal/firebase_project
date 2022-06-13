abstract class StorageEvent {}

class ReadImagesEvent extends StorageEvent {}

class UploadImageEvent extends StorageEvent {
  String path;

  UploadImageEvent(this.path);
}

class DeleteImageEvent extends StorageEvent {
  String path;

  DeleteImageEvent(this.path);
}