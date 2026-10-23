import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/application.dart';
import '../models/school_content.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 
  // AUTHENTICATION
  // 
  
  User? get currentUser => _supabase.auth.currentUser;

  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpParent(
    String email, 
    String password, 
    String firstName, 
    String lastName,
  ) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user != null) {
      await _supabase.from('profiles').insert({
        'id': response.user!.id,
        'email': email,
        'role': 'Parent',
      });

      await _supabase.from('parents').insert({
        'user_id': response.user!.id,
        'first_name': firstName,
        'last_name': lastName,
      });
    }
    return response;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<Map<String, dynamic>?> getParentProfile() async {
    if (currentUser == null) return null;
    final response = await _supabase
        .from('parents')
        .select()
        .eq('user_id', currentUser!.id)
        .maybeSingle();
    return response;
  }

  Future<bool> updateParentProfile(String firstName, String lastName) async {
    if (currentUser == null) return false;
    try {
      await _supabase
          .from('parents')
          .update({
            'first_name': firstName,
            'last_name': lastName,
          })
          .eq('user_id', currentUser!.id);
      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }

  // 
  // APPLICATIONS
  // 
  
  Future<List<Application>> getMyApplications(String parentId) async {
    final response = await _supabase
        .from('applications')
        .select()
        .eq('parent_id', parentId)
        .order('submission_date', ascending: false);
    
    return (response as List).map((json) => Application.fromJson(json)).toList();
  }

  Future<String?> submitApplication(Application app) async {
    try {
      final response = await _supabase
          .from('applications')
          .insert(app.toJson())
          .select('application_id')
          .single();
      return response['application_id'];
    } catch (e) {
      debugPrint('Error submitting application: $e');
      return null;
    }
  }

  // 
  // DOCUMENTS (WEB & MOBILE SUPPORT)
  //
  
  Future<String?> uploadDocument(String applicationId, File file) async {
    try {
      final fileName = '$applicationId/${DateTime.now().millisecondsSinceEpoch}_${file.path.split(Platform.pathSeparator).last}';
      await _supabase.storage.from('application_documents').upload(fileName, file);
      return _supabase.storage.from('application_documents').getPublicUrl(fileName);
    } catch (e) {
      debugPrint('Error uploading file: $e');
      return null;
    }
  }

  Future<String?> uploadDocumentBytes(String applicationId, Uint8List bytes, String originalFileName) async {
    try {
      final fileName = '$applicationId/${DateTime.now().millisecondsSinceEpoch}_$originalFileName';
      
      await _supabase.storage.from('application_documents').uploadBinary(
        fileName, 
        bytes,
      );
      
      final url = _supabase.storage.from('application_documents').getPublicUrl(fileName);
      
      await _supabase.from('documents').insert({
        'application_id': applicationId,
        'document_type': originalFileName.split('.').first,
        'file_url': url,
      });

      return url;
    } catch (e) {
      debugPrint('Error uploading bytes: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCommentsForApplication(String applicationId) async {
    final response = await _supabase
        .from('comments')
        .select()
        .eq('application_id', applicationId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getDocumentsForApplication(String applicationId) async {
    final response = await _supabase
        .from('documents')
        .select()
        .eq('application_id', applicationId);
    return List<Map<String, dynamic>>.from(response);
  }

  // 
  // UPDATES & ACHIEVEMENTS
  // 
  
  Future<List<SchoolUpdate>> getSchoolUpdates() async {
    final response = await _supabase
        .from('school_updates')
        .select()
        .order('published_at', ascending: false);
    return (response as List).map((json) => SchoolUpdate.fromJson(json)).toList();
  }

  Future<List<Achievement>> getAchievements() async {
    final response = await _supabase
        .from('achievements')
        .select()
        .order('published_at', ascending: false);
    return (response as List).map((json) => Achievement.fromJson(json)).toList();
  }
}
