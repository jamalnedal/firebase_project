import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vp9_firebase/bloc/bloc/storage_bloc.dart';
import 'package:vp9_firebase/bloc/events/storage_event.dart';
import 'package:vp9_firebase/helpers/helpers.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> with Helpers {
  ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedFile;
  double? _linearProgressValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _pickedFile != null
                ? Image.file(File(_pickedFile!.path))
                : Center(
                    child: IconButton(
                        onPressed: () async => await pickImage(),
                        icon: Icon(Icons.cloud_upload)),
                  ),
          ),
          ElevatedButton(
            onPressed: () async => await performUpload(),
            child: Text('UPLOAD'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickImage() async {
    XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  Future<void> performUpload() async {}

  bool checkData() {
    if (_pickedFile != null) {
      return true;
    }
    showSnackBar(
        context: context, message: 'Pick image to upload', error: true);
    return false;
  }

  void uploadImage() {
    BlocProvider.of<StorageBloc>(context)
        .add(UploadImageEvent(_pickedFile!.path));
  }
}
