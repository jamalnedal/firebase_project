import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vp9_firebase/bloc/bloc/storage_bloc.dart';
import 'package:vp9_firebase/bloc/events/storage_event.dart';
import 'package:vp9_firebase/bloc/states/storage_state.dart';
import 'package:vp9_firebase/helpers/helpers.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({Key? key}) : super(key: key);

  @override
  _ImagesScreenState createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> with Helpers {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<StorageBloc>(context).add(ReadImagesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/upload_image_screen'),
            icon: const Icon(
              Icons.cloud_upload,
            ),
          )
        ],
      ),
      body: BlocConsumer<StorageBloc, StorageState>(
        listenWhen: (previous, current) =>
            current is ProcessState && current.process == Process.delete,
        listener: (context, state) {},
        buildWhen: (previous, current) =>
            current is LoadingState || current is ReadImagesState,
        builder: (context, state) {
          if (state is ReadImagesState) {
            if (state.references.isNotEmpty) {
              return GridView.builder(
                itemCount: state.references.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Card();
                },
              );
            } else {
              return const Center(child: Text('NO IMAGES'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
