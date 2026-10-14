import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/application_model.dart';

class ApplicationViewModel extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<ApplicationModel> _applications = [];
  String? _errorMessage;
  bool _isLoading = false;

  List<ApplicationModel> get applications => _applications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> submitApplication(ApplicationModel application) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('applications')
          .insert(application.toJson())
          .select();
      if (response.isNotEmpty) {
        final newApp = ApplicationModel.fromJson(response.first);
        _applications.insert(0, newApp);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // READ - Fetch ONLY current user's applications (FIXED)
  Future<void> fetchMyApplications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _supabase.auth.currentUser?.id;
      print('Current User ID: $userId'); // Debug

      if (userId == null) {
        _applications = [];
        return;
      }

      final response = await _supabase
          .from('applications')
          .select()
          .eq('user_id', userId) // This MUST filter by user_id
          .order('created_at', ascending: false);

      print('Found ${response.length} applications for user $userId'); // Debug
      _applications = response
          .map((json) => ApplicationModel.fromJson(json))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error fetching applications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // READ - Fetch ALL applications (for Admin only)
  Future<void> fetchAllApplications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _supabase
          .from('applications')
          .select()
          .order('created_at', ascending: false);

      _applications = response
          .map((json) => ApplicationModel.fromJson(json))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE - Edit existing application (only if pending)
  Future<bool> updateApplication(ApplicationModel application) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _supabase.from('applications').update(application.toJson()).match({
        'id': application.applicationId!,
      });

      final index = _applications.indexWhere(
        (a) => a.applicationId == application.applicationId,
      );
      if (index != -1) {
        _applications[index] = application;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE - Admin approves/rejects application
  Future<bool> updateApplicationStatus(
    String applicationId,
    String newStatus, {
    String? notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _supabase
          .from('applications')
          .update({
            'status': newStatus,
            'admin_notes': notes,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .match({'id': applicationId});

      final index = _applications.indexWhere(
        (a) => a.applicationId == applicationId,
      );
      if (index != -1) {
        _applications[index] = _applications[index].copyWith(
          applicationStatus: newStatus,
          //adminNotes: notes,
          //updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // DELETE - Delete application (only if pending)
  Future<bool> deleteApplication(String applicationId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _supabase.from('applications').delete().match({
        'id': applicationId,
      });

      _applications.removeWhere((a) => a.applicationId == applicationId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper to get single application by ID
  ApplicationModel? getApplicationById(String id) {
    try {
      return _applications.firstWhere((a) => a.applicationId == id);
    } catch (e) {
      return null;
    }
  }

  // Check if student already has an application
  Future<bool> hasExistingApplication() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await _supabase
          .from('applications')
          .select('id')
          .eq('user_id', userId)
          .limit(1);

      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
