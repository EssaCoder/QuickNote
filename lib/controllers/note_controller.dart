import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_note/controllers/user_controller.dart';
import 'package:quick_note/models/note_request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'note_controller.g.dart';

@Riverpod(keepAlive: true)
class NoteController extends _$NoteController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<NoteRequest>> build() async {
    state = AsyncLoading();
    return await getNotes();
  }

  Future<List<NoteRequest>> getNotes() async {
    try {
      final user = ref.read(userControllerProvider);
      if (user == null) throw Exception("User not logged in");

      final querySnapshot = await firestore
          .collection('notes')
          .where('userId', isEqualTo: user.id)
          .get();

      final notes = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return NoteRequest.fromMap(data..addAll({'id': doc.id}));
      }).toList();

      return notes;
    } catch (e) {
      print("Failed to fetch notes: $e");
      return [];
    }
  }

  Future<bool> addNote(NoteRequest noteRequest) async {
    try {
      final user = ref.read(userControllerProvider);
      if (user == null) throw Exception("User not logged in");

      final noteData = noteRequest.toJson()..addAll({'userId': user.id});
      await firestore.collection('notes').add(noteData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateNote(NoteRequest updatedNote) async {
    try {
      final noteData = updatedNote.toJson();
      await firestore.collection('notes').doc(updatedNote.id).update(noteData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteNote(String? noteId) async {
    try {
      await firestore.collection('notes').doc(noteId).delete();

      print("Note deleted successfully");
    } catch (e) {
      print("Failed to delete note: $e");
    }
  }
}
