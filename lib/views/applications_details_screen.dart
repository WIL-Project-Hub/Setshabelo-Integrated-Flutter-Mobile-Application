
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/application.dart';
import '../services/supabase_service.dart';

// Setshabelo colour scheme
const Color _detailGreen = Color(0xFF2D873B);
const Color _detailDarkGreen = Color(0xFF1B4D3E);
const Color _detailLightGreen = Color(0xFFE2F3D2);
const Color _detailPaleGreen = Color(0xFFF3F8EF);
const Color _detailBorder = Color(0xFFD9E5D6);

class ApplicationDetailScreen extends StatefulWidget {
  final Application application;

  const ApplicationDetailScreen({
    super.key,
    required this.application,
  });

  @override
  State<ApplicationDetailScreen> createState() =>
      _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState
    extends State<ApplicationDetailScreen> {
  final _supabaseService = SupabaseService();

  List<Map<String, dynamic>> _comments = [];
  List<Map<String, dynamic>> _documents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final comments = await _supabaseService.getCommentsForApplication(
        widget.application.applicationId!,
      );

      final documents = await _supabaseService.getDocumentsForApplication(
        widget.application.applicationId!,
      );

      if (!mounted) return;

      setState(() {
        _comments = comments;
        _documents = documents;
      });
    } catch (e) {
      debugPrint('Error loading details: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return _detailGreen;
      case 'Rejected':
        return Colors.red.shade700;
      case 'Under Review':
        return _detailDarkGreen;
      default:
        return Colors.orange.shade800;
    }
  }

  Widget _buildInfoRow(String label, String? value) {
    final displayValue =
        value == null || value.trim().isEmpty ? '—' : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              style: const TextStyle(
                color: _detailDarkGreen,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDocument(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open document'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.application;
    final statusColor = _getStatusColor(app.applicationStatus);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Application Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _detailDarkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: _detailGreen,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Application status
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _detailPaleGreen,
                      border: Border.all(
                        color: _detailBorder,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'CURRENT STATUS',
                          style: TextStyle(
                            color: _detailDarkGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.10),
                            border: Border.all(
                              color: statusColor.withValues(alpha: 0.5),
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            app.applicationStatus,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                        if (app.submissionDate != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Submitted: ${app.submissionDate!.day}/${app.submissionDate!.month}/${app.submissionDate!.year}',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        if (app.reviewedDate != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Reviewed: ${app.reviewedDate!.day}/${app.reviewedDate!.month}/${app.reviewedDate!.year}',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Child information
                  _buildSectionCard(
                    title: 'Child Information',
                    icon: Icons.child_care_outlined,
                    children: [
                      _buildInfoRow('Full Name', app.childFullName),
                      _buildInfoRow('Date of Birth', app.childDateOfBirth),
                      _buildInfoRow('Grade', app.gradeApplyingFor),
                      _buildInfoRow('Gender', app.childGender),
                      _buildInfoRow('Race', app.childRace),
                      _buildInfoRow('ID / Birth Cert', app.childIdNumber),
                      _buildInfoRow('Citizenship', app.childCitizenship),
                      _buildInfoRow('Home Language', app.childHomeLanguage),
                      _buildInfoRow('Pre-Primary', app.prePrimaryEducation),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Parent information
                  _buildSectionCard(
                    title: 'Parent Information',
                    icon: Icons.family_restroom_outlined,
                    children: [
                      _buildInfoRow('Title', app.parentTitle),
                      _buildInfoRow('Initials', app.parentInitials),
                      _buildInfoRow(
                        'Full Name',
                        '${app.parentFirstName} ${app.parentLastName}',
                      ),
                      _buildInfoRow('Relationship', app.parentRelationship),
                      _buildInfoRow('ID Number', app.parentIdNumber),
                      _buildInfoRow('Race', app.parentRace),
                      _buildInfoRow('Home Language', app.parentHomeLanguage),
                      _buildInfoRow('Occupation', app.parentOccupation),
                      _buildInfoRow('Employer', app.parentEmployer),
                      _buildInfoRow('Phone', app.parentPhone),
                      _buildInfoRow('Email', app.parentEmail),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Address and contact
                  _buildSectionCard(
                    title: 'Address & Contact',
                    icon: Icons.location_on_outlined,
                    children: [
                      _buildInfoRow('Physical Address', app.physicalAddress),
                      _buildInfoRow('City / Suburb', app.cityOrSuburb),
                      _buildInfoRow('Postal Code', app.postalCode),
                      _buildInfoRow('Emergency Phone', app.emergencyPhone),
                      _buildInfoRow('Child Phone', app.childPhone),
                      _buildInfoRow('Child Email', app.childEmail),
                      _buildInfoRow('Mode of Transport', app.modeOfTransport),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Previous education
                  _buildSectionCard(
                    title: 'Previous Education',
                    icon: Icons.school_outlined,
                    children: [
                      _buildInfoRow('Previous School', app.previousSchool),
                      _buildInfoRow('School Address', app.previousSchoolAddress),
                      _buildInfoRow(
                        'Highest Grade Passed',
                        app.highestGradePassed,
                      ),
                      _buildInfoRow('Year Passed', app.yearGradePassed),
                      _buildInfoRow('Accession No.', app.accessionNo),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Medical information
                  _buildSectionCard(
                    title: 'Medical Information',
                    icon: Icons.medical_services_outlined,
                    children: [
                      _buildInfoRow('Medical Aid', app.medicalAid),
                      _buildInfoRow('Medical Aid No.', app.medicalAidNumber),
                      _buildInfoRow('Main Member', app.medicalAidMainMember),
                      _buildInfoRow('Doctor Name', app.doctorName),
                      _buildInfoRow('Doctor Address', app.doctorAddress),
                      _buildInfoRow('Doctor Phone', app.doctorPhone),
                      _buildInfoRow('Medical Conditions', app.medicalCondition),
                      _buildInfoRow('Special Problems', app.specialProblems),
                      _buildInfoRow('Dexterity', app.childDexterity),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Uploaded documents
                  _buildSectionCard(
                    title: 'Uploaded Documents',
                    icon: Icons.folder_open_outlined,
                    children: [
                      if (_documents.isEmpty)
                        _buildEmptyMessage('No documents uploaded.')
                      else
                        ..._documents.map(
                          (doc) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: _detailPaleGreen,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _detailBorder,
                              ),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.insert_drive_file_outlined,
                                color: _detailDarkGreen,
                              ),
                              title: Text(
                                doc['document_type'] ?? 'Document',
                                style: const TextStyle(
                                  color: _detailDarkGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.open_in_new,
                                size: 18,
                                color: _detailGreen,
                              ),
                              onTap: () {
                                final url = doc['file_url'];
                                if (url != null) {
                                  _openDocument(url);
                                }
                              },
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // School comments
                  _buildSectionCard(
                    title: 'Comments from School',
                    icon: Icons.chat_bubble_outline,
                    children: [
                      if (_comments.isEmpty)
                        _buildEmptyMessage('No comments yet.')
                      else
                        ..._comments.map(
                          (comment) => Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: _detailPaleGreen,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _detailBorder,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment['created_at']
                                          ?.toString()
                                          .substring(0, 10) ??
                                      '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  comment['comment_text'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: _detailDarkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _detailBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _detailLightGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: _detailDarkGreen,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: _detailDarkGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: _detailBorder, height: 1),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 13,
        ),
      ),
    );
  }
}
