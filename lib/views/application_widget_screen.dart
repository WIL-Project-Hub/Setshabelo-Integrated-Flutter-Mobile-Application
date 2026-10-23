
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/application.dart';
import '../services/supabase_service.dart';
import '../viewmodels/parent_home_viewmodel.dart';
import 'package:provider/provider.dart';

// Setshabelo colour scheme
const Color _wizardGreen = Color(0xFF2D873B);
const Color _wizardDarkGreen = Color(0xFF1B4D3E);
const Color _wizardLightGreen = Color(0xFFE2F3D2);
const Color _wizardBorder = Color(0xFFD9E5D6);

class ApplicationWizardScreen extends StatefulWidget {
  const ApplicationWizardScreen({super.key});

  @override
  State<ApplicationWizardScreen> createState() =>
      _ApplicationWizardScreenState();
}

class _ApplicationWizardScreenState
    extends State<ApplicationWizardScreen> {
  final _supabaseService = SupabaseService();
  int _currentStep = 0;
  bool _isSubmitting = false;

  // Step 1: Parent details
  final _parentFirstName = TextEditingController();
  final _parentLastName = TextEditingController();
  final _parentTitle = TextEditingController();
  final _parentInitials = TextEditingController();
  final _parentIdNumber = TextEditingController();
  final _parentPhone = TextEditingController();
  final _parentEmail = TextEditingController();
  String? _parentRelationship = 'Mother';
  final _parentRace = TextEditingController();
  final _parentHomeLanguage = TextEditingController();
  final _parentOccupation = TextEditingController();
  final _parentEmployer = TextEditingController();

  // Step 2: Child details
  final _childFullName = TextEditingController();
  final _childDateOfBirth = TextEditingController();
  String? _childGender = 'Male';
  final _childRace = TextEditingController();
  final _childIdNumber = TextEditingController();
  final _childCitizenship = TextEditingController();
  final _countryOfResidence = TextEditingController();
  final _province = TextEditingController();
  final _childHomeLanguage = TextEditingController();
  final _preferredLanguage = TextEditingController();
  String? _gradeApplyingFor = 'Grade 1';
  String? _prePrimaryEducation = 'No';

  // Step 3: Previous education
  final _previousSchool = TextEditingController();
  final _previousSchoolAddress = TextEditingController();
  final _highestGradePassed = TextEditingController();
  final _yearGradePassed = TextEditingController();
  final _accessionNo = TextEditingController();

  // Step 4: Contact details
  final _physicalAddress = TextEditingController();
  final _cityOrSuburb = TextEditingController();
  final _postalCode = TextEditingController();
  final _emergencyPhone = TextEditingController();
  final _childPhone = TextEditingController();
  final _childEmail = TextEditingController();
  String? _modeOfTransport = 'Walking';

  // Step 5: Medical details
  final _medicalAid = TextEditingController();
  final _medicalAidNumber = TextEditingController();
  final _medicalAidMainMember = TextEditingController();
  final _doctorName = TextEditingController();
  final _doctorAddress = TextEditingController();
  final _doctorPhone = TextEditingController();
  final _medicalCondition = TextEditingController();
  final _specialProblems = TextEditingController();
  final _childDexterity = TextEditingController();

  // Step 6: Supporting documents
  final List<PlatformFile> _selectedFiles = [];

  @override
  void initState() {
    super.initState();
    _loadParentDetails();
  }

  @override
  void dispose() {
    _parentFirstName.dispose();
    _parentLastName.dispose();
    _parentTitle.dispose();
    _parentInitials.dispose();
    _parentIdNumber.dispose();
    _parentPhone.dispose();
    _parentEmail.dispose();
    _parentRace.dispose();
    _parentHomeLanguage.dispose();
    _parentOccupation.dispose();
    _parentEmployer.dispose();

    _childFullName.dispose();
    _childDateOfBirth.dispose();
    _childRace.dispose();
    _childIdNumber.dispose();
    _childCitizenship.dispose();
    _countryOfResidence.dispose();
    _province.dispose();
    _childHomeLanguage.dispose();
    _preferredLanguage.dispose();

    _previousSchool.dispose();
    _previousSchoolAddress.dispose();
    _highestGradePassed.dispose();
    _yearGradePassed.dispose();
    _accessionNo.dispose();

    _physicalAddress.dispose();
    _cityOrSuburb.dispose();
    _postalCode.dispose();
    _emergencyPhone.dispose();
    _childPhone.dispose();
    _childEmail.dispose();

    _medicalAid.dispose();
    _medicalAidNumber.dispose();
    _medicalAidMainMember.dispose();
    _doctorName.dispose();
    _doctorAddress.dispose();
    _doctorPhone.dispose();
    _medicalCondition.dispose();
    _specialProblems.dispose();
    _childDexterity.dispose();

    super.dispose();
  }

  Future<void> _loadParentDetails() async {
    final parent = await _supabaseService.getParentProfile();

    if (!mounted) return;

    if (parent != null) {
      setState(() {
        _parentFirstName.text = parent['first_name'] ?? '';
        _parentLastName.text = parent['last_name'] ?? '';
      });
    }
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() => _selectedFiles.addAll(result.files));
      }
    } catch (e) {
      debugPrint('FilePicker error: $e');
    }
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < 5) {
        setState(() => _currentStep++);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all required fields before continuing.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _parentFirstName.text.trim().isNotEmpty &&
            _parentLastName.text.trim().isNotEmpty &&
            _parentPhone.text.trim().isNotEmpty &&
            _parentEmail.text.trim().isNotEmpty &&
            _parentRelationship != null;
      case 1:
        return _childFullName.text.trim().isNotEmpty &&
            _childGender != null &&
            _gradeApplyingFor != null &&
            _childIdNumber.text.trim().isNotEmpty;
      case 2:
        return true;
      case 3:
        return _physicalAddress.text.trim().isNotEmpty;
      case 4:
      case 5:
      default:
        return true;
    }
  }

  Future<void> _submitApplication() async {
    if (!_validateCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final parent = await _supabaseService.getParentProfile();

      if (parent == null) {
        throw Exception('Parent profile not found');
      }

      final app = Application(
        parentId: parent['parent_id'],
        parentFirstName: _parentFirstName.text,
        parentLastName: _parentLastName.text,
        parentTitle: _parentTitle.text,
        parentInitials: _parentInitials.text,
        parentIdNumber: _parentIdNumber.text,
        parentPhone: _parentPhone.text,
        parentEmail: _parentEmail.text,
        parentAddress: _physicalAddress.text,
        parentRelationship: _parentRelationship!,
        parentRace: _parentRace.text,
        parentHomeLanguage: _parentHomeLanguage.text,
        parentOccupation: _parentOccupation.text,
        parentEmployer: _parentEmployer.text,
        childFullName: _childFullName.text,
        childDateOfBirth: _childDateOfBirth.text,
        childGender: _childGender!,
        childRace: _childRace.text,
        childIdNumber: _childIdNumber.text,
        childCitizenship: _childCitizenship.text,
        countryOfResidence: _countryOfResidence.text,
        province: _province.text,
        childHomeLanguage: _childHomeLanguage.text,
        preferredLanguage: _preferredLanguage.text,
        gradeApplyingFor: _gradeApplyingFor!,
        prePrimaryEducation: _prePrimaryEducation!,
        previousSchool: _previousSchool.text,
        previousSchoolAddress: _previousSchoolAddress.text,
        highestGradePassed: _highestGradePassed.text,
        yearGradePassed: _yearGradePassed.text,
        accessionNo: _accessionNo.text,
        physicalAddress: _physicalAddress.text,
        cityOrSuburb: _cityOrSuburb.text,
        postalCode: _postalCode.text,
        emergencyPhone: _emergencyPhone.text,
        childPhone: _childPhone.text,
        childEmail: _childEmail.text,
        modeOfTransport: _modeOfTransport!,
        medicalAid: _medicalAid.text,
        medicalAidNumber: _medicalAidNumber.text,
        medicalAidMainMember: _medicalAidMainMember.text,
        doctorName: _doctorName.text,
        doctorAddress: _doctorAddress.text,
        doctorPhone: _doctorPhone.text,
        medicalCondition: _medicalCondition.text,
        specialProblems: _specialProblems.text,
        childDexterity: _childDexterity.text,
      );

      final appId = await _supabaseService.submitApplication(app);

      if (appId == null) {
        throw Exception('Failed to save application');
      }

      for (final file in _selectedFiles) {
        if (file.bytes != null) {
          await _supabaseService.uploadDocumentBytes(
            appId,
            file.bytes!,
            file.name,
          );
        }
      }

      if (!mounted) return;

      Provider.of<ParentHomeViewModel>(
        context,
        listen: false,
      ).loadData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'New Application',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: _wizardDarkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress indicator and step labels
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (_currentStep + 1) / 6,
                    backgroundColor: Colors.grey.shade200,
                    color: _wizardGreen,
                    minHeight: 7,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _stepLabel('1. Parent', 0),
                    _stepLabel('2. Child', 1),
                    _stepLabel('3. Education', 2),
                    _stepLabel('4. Contact', 3),
                    _stepLabel('5. Medical', 4),
                    _stepLabel('6. Documents', 5),
                  ],
                ),
              ],
            ),
          ),

          // Current form step
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: _buildCurrentStep(),
            ),
          ),

          // Previous / Next / Submit controls
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: _wizardBorder),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  OutlinedButton(
                    onPressed: _previousStep,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _wizardDarkGreen,
                      side: const BorderSide(color: _wizardDarkGreen),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('← Previous'),
                  )
                else
                  const SizedBox(width: 100),
                if (_currentStep < 5)
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _wizardGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Next →'),
                  )
                else
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitApplication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _wizardGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('✓ Submit Application'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepLabel(String label, int stepIndex) {
    final isActive = stepIndex <= _currentStep;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? _wizardGreen : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      case 4:
        return _buildStep5();
      case 5:
        return _buildStep6();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1() {
    return _buildFormSection(
      title: 'Parent / Guardian Details',
      subtitle: 'Enter your contact and personal information.',
      children: [
        _buildField('First Name *', _parentFirstName),
        _buildField('Last Name *', _parentLastName),
        _buildField('Title', _parentTitle),
        _buildField('Initials', _parentInitials),
        _buildField(
          'ID Number',
          _parentIdNumber,
          keyboardType: TextInputType.number,
        ),
        _buildField(
          'Phone *',
          _parentPhone,
          keyboardType: TextInputType.phone,
        ),
        _buildField(
          'Email *',
          _parentEmail,
          keyboardType: TextInputType.emailAddress,
        ),
        _buildDropdown(
          label: 'Relationship *',
          value: _parentRelationship,
          items: ['Mother', 'Father', 'Guardian'],
          onChanged: (val) => setState(() => _parentRelationship = val),
        ),
        _buildField('Race', _parentRace),
        _buildField('Home Language', _parentHomeLanguage),
        _buildField('Occupation', _parentOccupation),
        _buildField('Employer', _parentEmployer),
      ],
    );
  }

  Widget _buildStep2() {
    return _buildFormSection(
      title: 'Child Details',
      subtitle: 'Enter the details of the child applying for admission.',
      children: [
        _buildField('Full Name *', _childFullName),
        _buildField('Date of Birth (YYYY-MM-DD)', _childDateOfBirth),
        _buildDropdown(
          label: 'Gender *',
          value: _childGender,
          items: ['Male', 'Female', 'Other'],
          onChanged: (val) => setState(() => _childGender = val),
        ),
        _buildField('Race', _childRace),
        _buildField('ID / Birth Certificate *', _childIdNumber),
        _buildField('Citizenship', _childCitizenship),
        _buildField('Country of Residence', _countryOfResidence),
        _buildField('Province', _province),
        _buildField('Home Language', _childHomeLanguage),
        _buildField('Preferred Language', _preferredLanguage),
        _buildDropdown(
          label: 'Grade Applying For *',
          value: _gradeApplyingFor,
          items: [
            'Grade R',
            'Grade 1',
            'Grade 2',
            'Grade 3',
            'Grade 4',
            'Grade 5',
            'Grade 6',
            'Grade 7',
          ],
          onChanged: (val) => setState(() => _gradeApplyingFor = val),
        ),
        _buildDropdown(
          label: 'Pre-Primary Education',
          value: _prePrimaryEducation,
          items: ['Yes', 'No'],
          onChanged: (val) => setState(() => _prePrimaryEducation = val),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return _buildFormSection(
      title: 'Previous Education',
      subtitle: 'Provide information about the child’s previous schooling.',
      children: [
        _buildField('Previous School', _previousSchool),
        _buildField('Previous School Address', _previousSchoolAddress),
        _buildField('Highest Grade Passed', _highestGradePassed),
        _buildField('Year Grade Passed', _yearGradePassed),
        _buildField('Accession No.', _accessionNo),
      ],
    );
  }

  Widget _buildStep4() {
    return _buildFormSection(
      title: 'Contact and Address',
      subtitle: 'Provide the child’s residential and contact information.',
      children: [
        _buildField('Physical Address *', _physicalAddress),
        _buildField('City / Suburb', _cityOrSuburb),
        _buildField('Postal Code', _postalCode),
        _buildField(
          'Emergency Phone',
          _emergencyPhone,
          keyboardType: TextInputType.phone,
        ),
        _buildField(
          'Child Phone',
          _childPhone,
          keyboardType: TextInputType.phone,
        ),
        _buildField(
          'Child Email',
          _childEmail,
          keyboardType: TextInputType.emailAddress,
        ),
        _buildDropdown(
          label: 'Mode of Transport',
          value: _modeOfTransport,
          items: [
            'Walking',
            'Private Vehicle',
            'School Bus',
            'Public Transport',
            'Other',
          ],
          onChanged: (val) => setState(() => _modeOfTransport = val),
        ),
      ],
    );
  }

  Widget _buildStep5() {
    return _buildFormSection(
      title: 'Medical Information',
      subtitle: 'Enter any relevant medical and healthcare details.',
      children: [
        _buildField('Medical Aid', _medicalAid),
        _buildField('Medical Aid Number', _medicalAidNumber),
        _buildField('Main Member', _medicalAidMainMember),
        _buildField('Doctor Name', _doctorName),
        _buildField('Doctor Address', _doctorAddress),
        _buildField(
          'Doctor Phone',
          _doctorPhone,
          keyboardType: TextInputType.phone,
        ),
        _buildField('Medical Conditions', _medicalCondition, maxLines: 3),
        _buildField('Special Problems', _specialProblems, maxLines: 3),
        _buildField('Child Dexterity', _childDexterity),
      ],
    );
  }

  Widget _buildStep6() {
    return _buildFormSection(
      title: 'Supporting Documents',
      subtitle: 'Upload supporting documents in PDF, JPG, or PNG format.',
      children: [
        OutlinedButton.icon(
          onPressed: _pickFiles,
          style: OutlinedButton.styleFrom(
            foregroundColor: _wizardDarkGreen,
            side: const BorderSide(color: _wizardGreen),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.upload_file),
          label: const Text('Select Files'),
        ),
        const SizedBox(height: 12),
        if (_selectedFiles.isNotEmpty)
          ..._selectedFiles.map(
            (file) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: _wizardLightGreen.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _wizardBorder),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.insert_drive_file_outlined,
                  color: _wizardDarkGreen,
                ),
                title: Text(
                  file.name,
                  style: const TextStyle(fontSize: 13),
                ),
                trailing: IconButton(
                  tooltip: 'Remove file',
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() => _selectedFiles.remove(file));
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFormSection({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _wizardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _wizardDarkGreen,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: _wizardDarkGreen),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _wizardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _wizardBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: _wizardGreen,
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: _wizardDarkGreen),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _wizardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _wizardBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: _wizardGreen,
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
