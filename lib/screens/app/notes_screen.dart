import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vp9_firebase/controllers/fb_auth_controller.dart';
import 'package:vp9_firebase/controllers/fb_fire_store_controller.dart';
import 'package:vp9_firebase/controllers/fb_notifications.dart';
import 'package:vp9_firebase/helpers/helpers.dart';
import 'package:vp9_firebase/models/note.dart';
import 'package:vp9_firebase/screens/app/note_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with Helpers, FbNotifications {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeForegroundNotificationForAndroid();
    manageNotificationAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            onPressed: () async {
              await FbAuthController().signOut();
              Navigator.pushReplacementNamed(context, '/login_screen');
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoteScreen(),
                ),
              );
            },
            icon: const Icon(Icons.note_add),
          ),
          IconButton(
            onPressed: () async {
              await FbAuthController().signOut();
              Navigator.pushReplacementNamed(context, '/images_screen');
            },
            icon: const Icon(Icons.image),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FbFireStoreController().read(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              List<QueryDocumentSnapshot> _documents = snapshot.data!.docs;
              return ListView.builder(
                itemCount: _documents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteScreen(
                              note: generateNote(_documents[index]),
                              title: 'Update',
                            ),
                          ));
                    },
                    leading: Icon(Icons.note),
                    title: Text(_documents[index].get('title')),
                    subtitle: Text(_documents[index].get('details')),
                    trailing: IconButton(
                      onPressed: () async => await deleteNote(id: _documents[index].id),
                      icon: Icon(Icons.delete),
                      color: Colors.red.shade800,
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.warning,
                      size: 85,
                      color: Colors.grey,
                    ),
                    Text(
                      'NO DATA',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }

  Note generateNote(QueryDocumentSnapshot documentSnapshot) {
    Note note = Note();
    note.id = documentSnapshot.id;
    note.title = documentSnapshot.get('title');
    note.details = documentSnapshot.get('details');
    return note;
  }

  Future<void> deleteNote({required String id}) async {
    bool status = await FbFireStoreController().delete(id: id);
    String message = status ? 'Deleted successfully' : 'Delete failed';
    showSnackBar(context: context, message: message, error: !status);
  }
}
