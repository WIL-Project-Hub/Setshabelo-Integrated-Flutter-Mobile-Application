import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _bucketName = 'application_documents';

  static Future<Map<String, dynamic>?> pickImage(ImageSource source) async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        return {
          'bytes': bytes,
          'fileName': pickedFile.name,
          'path': pickedFile.path,
        };
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  Future<String?> uploadDocument(
    String applicationId,
    Map<String, dynamic> imageData,
  ) async {
    try {
      final originalName = imageData['name'] as String;
      final extension = originalName.split('.').last;
      final filename = '${DateTime.now().millisecondsSinceEpoch}.$extension';
      final filepath = 'applications/$applicationId/$filename';

      debugPrint('Uploading document to bucket: $_bucketName');
      debugPrint('File path: $filepath');

      await _supabase.storage
          .from(_bucketName)
          .uploadBinary(
            filepath,
            imageData['bytes'] as Uint8List,
            fileOptions: FileOptions(cacheControl: '3600', upsert: true),
          );

      final publicUrl = _supabase.storage
          .from(_bucketName)
          .getPublicUrl(filepath);
      debugPrint('Document uploaded successfully. Public URL: $publicUrl');

      return publicUrl;
    } catch (e) {
      debugPrint('Error uploading document: $e');
      return null;
    }
  }

  Future<bool> deleteDocument(String imaheUrl) async {
    try {
      final uri = Uri.parse(imaheUrl);
      final segments = uri.pathSegments;
      final filepath = segments.sublist(2).join('/');

      await _supabase.storage.from(_bucketName).remove([filepath]);
      return true;
    } catch (e) {
      debugPrint('Error deleting document : $e');
      return false;
    }
  }
}
