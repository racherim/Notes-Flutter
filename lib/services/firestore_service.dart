import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo_web/utils/todo_Items.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user's ID
  String? get _userId => _auth.currentUser?.uid;

  // Get reference to user's notes collection
  CollectionReference<Map<String, dynamic>>? get _notesCollection {
    if (_userId == null) return null;
    return _firestore.collection('users').doc(_userId).collection('notes');
  }

  // Add a new note
  Future<void> addNote(TodoItem note) async {
    if (_notesCollection == null) throw Exception('User not authenticated');
    
    await _notesCollection!.doc(note.id).set(note.toMap());
  }

  // Update an existing note
  Future<void> updateNote(TodoItem note) async {
    if (_notesCollection == null) throw Exception('User not authenticated');
    
    await _notesCollection!.doc(note.id).update(note.toMap());
  }

  // Delete a note (move to trash)
  Future<void> moveToTrash(String noteId) async {
    if (_notesCollection == null) throw Exception('User not authenticated');
    
    await _notesCollection!.doc(noteId).update({
      'isDeleted': true,
      'deletedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Restore a note from trash
  Future<void> restoreFromTrash(String noteId) async {
    if (_notesCollection == null) throw Exception('User not authenticated');
    
    await _notesCollection!.doc(noteId).update({
      'isDeleted': false,
      'deletedAt': null,
    });
  }

  // Permanently delete a note
  Future<void> permanentlyDeleteNote(String noteId) async {
    if (_notesCollection == null) throw Exception('User not authenticated');
    
    await _notesCollection!.doc(noteId).delete();
  }

  // Get all active notes (not deleted)
  Stream<List<TodoItem>> getActiveNotes() {
    if (_notesCollection == null) {
      return Stream.value([]);
    }
    
    return _notesCollection!
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TodoItem.fromMap(doc.data()))
            .toList());
  }

  // Get all trashed notes
  Stream<List<TodoItem>> getTrashedNotes() {
    if (_notesCollection == null) {
      return Stream.value([]);
    }
    
    return _notesCollection!
        .where('isDeleted', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TodoItem.fromMap(doc.data()))
            .toList());
  }

  // Get all notes (active and trashed)
  Stream<List<TodoItem>> getAllNotes() {
    if (_notesCollection == null) {
      return Stream.value([]);
    }
    
    return _notesCollection!
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TodoItem.fromMap(doc.data()))
            .toList());
  }

  // Empty trash (permanently delete all trashed notes)
  Future<void> emptyTrash() async {
    if (_notesCollection == null) throw Exception('User not authenticated');
    
    final trashedNotes = await _notesCollection!
        .where('isDeleted', isEqualTo: true)
        .get();
    
    final batch = _firestore.batch();
    for (final doc in trashedNotes.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }

  // Check and delete notes that have been in trash for more than 14 days
  Future<void> cleanupExpiredTrashNotes() async {
    if (_notesCollection == null) throw Exception('User not authenticated');
    
    final fourteenDaysAgo = DateTime.now().subtract(const Duration(days: 14));
    final fourteenDaysAgoTimestamp = fourteenDaysAgo.millisecondsSinceEpoch;
    
    // Get all trashed notes older than 14 days
    final expiredNotes = await _notesCollection!
        .where('isDeleted', isEqualTo: true)
        .where('deletedAt', isLessThan: fourteenDaysAgoTimestamp)
        .get();
    
    if (expiredNotes.docs.isEmpty) return;
    
    // Delete expired notes in batch
    final batch = _firestore.batch();
    for (final doc in expiredNotes.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }

  // Get trashed notes with days remaining before auto-deletion
  Stream<List<Map<String, dynamic>>> getTrashedNotesWithExpiryInfo() {
    if (_notesCollection == null) {
      return Stream.value([]);
    }
    
    return _notesCollection!
        .where('isDeleted', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          final now = DateTime.now();
          return snapshot.docs.map((doc) {
            final data = doc.data();
            final deletedAt = data['deletedAt'] != null 
                ? DateTime.fromMillisecondsSinceEpoch(data['deletedAt'])
                : null;
            
            int daysRemaining = 14;
            if (deletedAt != null) {
              final daysSinceDeleted = now.difference(deletedAt).inDays;
              daysRemaining = 14 - daysSinceDeleted;
            }
            
            return {
              'note': TodoItem.fromMap(data),
              'daysRemaining': daysRemaining,
              'deletedAt': deletedAt,
            };
          }).toList();
        });
  }

  // Auto-cleanup service that should be called periodically
  Future<void> performAutoCleanup() async {
    try {
      await cleanupExpiredTrashNotes();
    } catch (e) {
      log('Auto-cleanup error: $e');
    }
  }

  // Create user document on first login (optional)
  Future<void> initializeUserDocument() async {
    if (_userId == null) return;
    
    final userDoc = _firestore.collection('users').doc(_userId);
    final docSnapshot = await userDoc.get();
    
    if (!docSnapshot.exists) {
      await userDoc.set({
        'createdAt': FieldValue.serverTimestamp(),
        'email': _auth.currentUser?.email,
      });
    }
  }
}
