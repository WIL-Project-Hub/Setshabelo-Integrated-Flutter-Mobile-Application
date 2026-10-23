class Application {
  final String? applicationId;
  final String parentId;
  final String parentFirstName;
  final String parentLastName;
  final String? parentTitle;
  final String? parentInitials;
  final String? parentIdNumber;
  final String parentPhone;
  final String parentEmail;
  final String? parentAddress;
  final String? parentRelationship;
  final String? parentRace;
  final String? parentHomeLanguage;
  final String? parentOccupation;
  final String? parentEmployer;

  final String childFullName;
  final String? childDateOfBirth;
  final String? childGender;
  final String? childRace;
  final String? childIdNumber;
  final String? childCitizenship;
  final String? countryOfResidence;
  final String? province;
  final String? childHomeLanguage;
  final String? preferredLanguage;
  final String gradeApplyingFor;
  final String? prePrimaryEducation;
  final String? highestGradePassed;
  final String? yearGradePassed;
  final String? accessionNo;
  final String? previousSchool;
  final String? previousSchoolAddress;

  final String? physicalAddress;
  final String? cityOrSuburb;
  final String? postalCode;
  final String? emergencyPhone;
  final String? childPhone;
  final String? childEmail;
  final String? modeOfTransport;

  final String? medicalAidNumber;
  final String? medicalAid;
  final String? medicalAidMainMember;
  final String? doctorName;
  final String? doctorAddress;
  final String? doctorPhone;
  final String? medicalCondition;
  final String? specialProblems;
  final String? childDexterity;

  final String applicationStatus;
  final DateTime? submissionDate;
  final String? reviewedBy;
  final DateTime? reviewedDate;

  Application({
    this.applicationId,
    required this.parentId,
    required this.parentFirstName,
    required this.parentLastName,
    this.parentTitle,
    this.parentInitials,
    this.parentIdNumber,
    required this.parentPhone,
    required this.parentEmail,
    this.parentAddress,
    this.parentRelationship,
    this.parentRace,
    this.parentHomeLanguage,
    this.parentOccupation,
    this.parentEmployer,
    required this.childFullName,
    this.childDateOfBirth,
    this.childGender,
    this.childRace,
    this.childIdNumber,
    this.childCitizenship,
    this.countryOfResidence,
    this.province,
    this.childHomeLanguage,
    this.preferredLanguage,
    required this.gradeApplyingFor,
    this.prePrimaryEducation,
    this.highestGradePassed,
    this.yearGradePassed,
    this.accessionNo,
    this.previousSchool,
    this.previousSchoolAddress,
    this.physicalAddress,
    this.cityOrSuburb,
    this.postalCode,
    this.emergencyPhone,
    this.childPhone,
    this.childEmail,
    this.modeOfTransport,
    this.medicalAidNumber,
    this.medicalAid,
    this.medicalAidMainMember,
    this.doctorName,
    this.doctorAddress,
    this.doctorPhone,
    this.medicalCondition,
    this.specialProblems,
    this.childDexterity,
    this.applicationStatus = 'Pending',
    this.submissionDate,
    this.reviewedBy,
    this.reviewedDate,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      applicationId: json['application_id'],
      parentId: json['parent_id'],
      parentFirstName: json['parent_first_name'] ?? '',
      parentLastName: json['parent_last_name'] ?? '',
      parentTitle: json['parent_title'],
      parentInitials: json['parent_initials'],
      parentIdNumber: json['parent_id_number'],
      parentPhone: json['parent_phone'] ?? '',
      parentEmail: json['parent_email'] ?? '',
      parentAddress: json['parent_address'],
      parentRelationship: json['parent_relationship'],
      parentRace: json['parent_race'],
      parentHomeLanguage: json['parent_home_language'],
      parentOccupation: json['parent_occupation'],
      parentEmployer: json['parent_employer'],
      childFullName: json['child_full_name'] ?? '',
      childDateOfBirth: json['child_date_of_birth'],
      childGender: json['child_gender'],
      childRace: json['child_race'],
      childIdNumber: json['child_id_number'],
      childCitizenship: json['child_citizenship'],
      countryOfResidence: json['country_of_residence'],
      province: json['province'],
      childHomeLanguage: json['child_home_language'],
      preferredLanguage: json['preferred_language'],
      gradeApplyingFor: json['grade_applying_for'] ?? '',
      prePrimaryEducation: json['pre_primary_education'],
      highestGradePassed: json['highest_grade_passed'],
      yearGradePassed: json['year_grade_passed'],
      accessionNo: json['accession_no'],
      previousSchool: json['previous_school'],
      previousSchoolAddress: json['previous_school_address'],
      physicalAddress: json['physical_address'],
      cityOrSuburb: json['city_or_suburb'],
      postalCode: json['postal_code'],
      emergencyPhone: json['emergency_phone'],
      childPhone: json['child_phone'],
      childEmail: json['child_email'],
      modeOfTransport: json['mode_of_transport'],
      medicalAidNumber: json['medical_aid_number'],
      medicalAid: json['medical_aid'],
      medicalAidMainMember: json['medical_aid_main_member'],
      doctorName: json['doctor_name'],
      doctorAddress: json['doctor_address'],
      doctorPhone: json['doctor_phone'],
      medicalCondition: json['medical_condition'],
      specialProblems: json['special_problems'],
      childDexterity: json['child_dexterity'],
      applicationStatus: json['application_status'] ?? 'Pending',
      submissionDate: json['submission_date'] != null
          ? DateTime.parse(json['submission_date'])
          : null,
      reviewedBy: json['reviewed_by'],
      reviewedDate: json['reviewed_date'] != null
          ? DateTime.parse(json['reviewed_date'])
          : null,
    );
  }

  // For sending to Supabase
  Map<String, dynamic> toJson() {
    return {
      if (applicationId != null) 'application_id': applicationId,
      'parent_id': parentId,
      'parent_first_name': parentFirstName,
      'parent_last_name': parentLastName,
      'parent_title': parentTitle,
      'parent_initials': parentInitials,
      'parent_id_number': parentIdNumber,
      'parent_phone': parentPhone,
      'parent_email': parentEmail,
      'parent_address': parentAddress,
      'parent_relationship': parentRelationship,
      'parent_race': parentRace,
      'parent_home_language': parentHomeLanguage,
      'parent_occupation': parentOccupation,
      'parent_employer': parentEmployer,
      'child_full_name': childFullName,
      'child_date_of_birth': childDateOfBirth,
      'child_gender': childGender,
      'child_race': childRace,
      'child_id_number': childIdNumber,
      'child_citizenship': childCitizenship,
      'country_of_residence': countryOfResidence,
      'province': province,
      'child_home_language': childHomeLanguage,
      'preferred_language': preferredLanguage,
      'grade_applying_for': gradeApplyingFor,
      'pre_primary_education': prePrimaryEducation,
      'highest_grade_passed': highestGradePassed,
      'year_grade_passed': yearGradePassed,
      'accession_no': accessionNo,
      'previous_school': previousSchool,
      'previous_school_address': previousSchoolAddress,
      'physical_address': physicalAddress,
      'city_or_suburb': cityOrSuburb,
      'postal_code': postalCode,
      'emergency_phone': emergencyPhone,
      'child_phone': childPhone,
      'child_email': childEmail,
      'mode_of_transport': modeOfTransport,
      'medical_aid_number': medicalAidNumber,
      'medical_aid': medicalAid,
      'medical_aid_main_member': medicalAidMainMember,
      'doctor_name': doctorName,
      'doctor_address': doctorAddress,
      'doctor_phone': doctorPhone,
      'medical_condition': medicalCondition,
      'special_problems': specialProblems,
      'child_dexterity': childDexterity,
      'application_status': applicationStatus,
    };
  }
}
