import 'package:flutter/material.dart';
import 'package:vp9_firebase/controllers/fb_fire_store_controller.dart';
import 'package:vp9_firebase/helpers/helpers.dart';
import 'package:vp9_firebase/models/note.dart';
import 'package:vp9_firebase/widgets/app_text_field.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({
    Key? key,
    this.title = 'Create',
    this.note,
  }) : super(key: key);

  final String title;
  final Note? note;

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> with Helpers {
  late TextEditingController _titleTextController;
  late TextEditingController _detailsTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleTextController =
        TextEditingController(text: widget.note?.title ?? '');
    _detailsTextController =
        TextEditingController(text: widget.note?.details ?? '');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleTextController.dispose();
    _detailsTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          AppTextField(
            hint: 'Title',
            controller: _titleTextController,
            prefixIcon: Icons.title,
          ),
          const SizedBox(height: 10),
          AppTextField(
            hint: 'Details',
            controller: _detailsTextController,
            prefixIcon: Icons.details,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () async => await performProcess(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 50),
            ),
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  Future<void> performProcess() async {
    if (checkData()) {
      await process();
    }
  }

  bool checkData() {
    if (_titleTextController.text.isNotEmpty &&
        _detailsTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context: context, message: 'Enter required data', error: true);
    return false;
  }

  Future<void> process() async {
    bool status = widget.note == null
        ? await FbFireStoreController().create(note: note)
        : await FbFireStoreController().update(note: note);

    if (status) {
      isUpdate() ? Navigator.pop(context) : clear();
    }

    showSnackBar(
      context: context,
      message: status ? 'Process success' : 'Process failed',
      error: !status,
    );
  }

  bool isUpdate() => widget.note != null;

  Note get note {
    Note note = widget.note == null ? Note() : widget.note!;
    note.title = _titleTextController.text;
    note.details = _detailsTextController.text;
    return note;
  }

  void clear() {
    _titleTextController.text = '';
    _detailsTextController.text = '';
  }
}
