class ApplicationModel {
  final String? applicationId;
  final String parentId;
  final String parentSurname;
  final String parentName;
  final String parentIdNumber;
  final String parentPhone;
  final String parentEmail;
  final String parentAddress;
  final String relationshipToChild;
  final String childName;
  final String childGender;
  final String childRace;
  final String childIDNumber;
  final String childCitizenship;
  final String countryOfBirth;
  final String province;
  final String childHomeLanguage;
  final String preferredLanguage;
  final String gradeApplyingFor;
  final String prePrimarySchool;
  final String highestGradeCompleted;
  final String yearCompleted;
  final String accessionNumber;
  final String previousSchool;
  final String previousSchoolAddress;
  final String physicalAddress;
  final String city;
  final String postalCode;
  final String emergencyContactName;
  final String emergencyContactNumber;
  final String? childPhone;
  final String? childEmail;
  final String? modeOfTransport;
  final String? transportDetails;
  final String? medicalAidNumber;
  final String? medicalAidName;
  final String? medicalAidMemberName;
  final String? doctorName;
  final String? doctorAddress;
  final String? medicalConditions;
  final String? specialNeeds;
  final String childDexterity;
  final String applicationStatus;

  final DateTime createdAt;

  const ApplicationModel({
    this.applicationId,
    required this.parentId,
    required this.parentSurname,
    required this.parentName,
    required this.parentIdNumber,
    required this.parentPhone,
    required this.parentEmail,
    required this.parentAddress,
    required this.relationshipToChild,
    required this.childName,
    required this.childGender,
    required this.childRace,
    required this.childIDNumber,
    required this.childCitizenship,
    required this.countryOfBirth,
    required this.province,
    required this.childHomeLanguage,
    required this.preferredLanguage,
    required this.gradeApplyingFor,
    required this.prePrimarySchool,
    required this.highestGradeCompleted,
    required this.yearCompleted,
    required this.accessionNumber,
    required this.previousSchool,
    required this.previousSchoolAddress,
    required this.physicalAddress,
    required this.city,
    required this.postalCode,
    required this.emergencyContactName,
    required this.emergencyContactNumber,
    this.childPhone,
    this.childEmail,
    this.modeOfTransport,
    this.transportDetails,
    this.medicalAidNumber,
    this.medicalAidName,
    this.medicalAidMemberName,
    this.doctorName,
    this.doctorAddress,
    this.medicalConditions,
    this.specialNeeds,
    required this.childDexterity,
    required this.applicationStatus,
    required this.createdAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      applicationId: json['applicationId'],
      parentId: json['parentId'],
      parentSurname: json['parentSurname'],
      parentName: json['parentName'],
      parentIdNumber: json['parentIdNumber'],
      parentPhone: json['parentPhone'],
      parentEmail: json['parentEmail'],
      parentAddress: json['parentAddress'],
      relationshipToChild: json['relationshipToChild'],
      childName: json['childName'],
      childGender: json['childGender'],
      childRace: json['childRace'],
      childIDNumber: json['childIDNumber'],
      childCitizenship: json['childCitizenship'],
      countryOfBirth: json['countryOfBirth'],
      province: json['province'],
      childHomeLanguage: json['childHomeLanguage'],
      preferredLanguage: json['preferredLanguage'],
      gradeApplyingFor: json['gradeApplyingFor'],
      prePrimarySchool: json['prePrimarySchool'],
      highestGradeCompleted: json['highestGradeCompleted'],
      yearCompleted: json['yearCompleted'],
      accessionNumber: json['accessionNumber'],
      previousSchool: json['previousSchool'],
      previousSchoolAddress: json['previousSchoolAddress'],
      physicalAddress: json['physicalAddress'],
      city: json['city'],
      postalCode: json['postalCode'],
      emergencyContactName: json['emergencyContactName'],
      emergencyContactNumber: json['emergencyContactNumber'],
      childPhone: json['childPhone'],
      childEmail: json['childEmail'],
      modeOfTransport: json['modeOfTransport'],
      transportDetails: json['transportDetails'],
      medicalAidNumber: json['medicalAidNumber'],
      medicalAidName: json['medicalAidName'],
      medicalAidMemberName: json['medicalAidMemberName'],
      doctorName: json['doctorName'],
      doctorAddress: json['doctorAddress'],
      medicalConditions: json['medicalConditions'] ?? '',
      specialNeeds: json['specialNeeds'] ?? '',
      childDexterity: json['childDexterity'] ?? '',
      applicationStatus:
          (json.containsKey('applicationStatus') &&
              (json["applicationStatus"] != null))
          ? (json["applicationStatus"] as String)
          : 'pending',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'applicationId': applicationId,
      'parentId': parentId,
      'parentSurname': parentSurname,
      'parentName': parentName,
      'parentIdNumber': parentIdNumber,
      'parentPhone': parentPhone,
      'parentEmail': parentEmail,
      'parentAddress': parentAddress,
      'relationshipToChild': relationshipToChild,
      'childName': childName,
      'childGender': childGender,
      'childRace': childRace,
      'childIDNumber': childIDNumber,
      'childCitizenship': childCitizenship,
      'countryOfBirth': countryOfBirth,
      'province': province,
      'childHomeLanguage': childHomeLanguage,
      'preferredLanguage': preferredLanguage,
      'gradeApplyingFor': gradeApplyingFor,
      'prePrimarySchool': prePrimarySchool,
      'highestGradeCompleted': highestGradeCompleted,
      'yearCompleted': yearCompleted,
      'accessionNumber': accessionNumber,
      'previousSchool': previousSchool,
      'previousSchoolAddress': previousSchoolAddress,
      'physicalAddress': physicalAddress,
      'city': city,
      'postalCode': postalCode,
      'emergencyContactName': emergencyContactName,
      'emergencyContactNumber': emergencyContactNumber,
      'childPhone': childPhone,
      'childEmail': childEmail,
      'modeOfTransport': modeOfTransport,
      'transportDetails': transportDetails,
      'medicalAidNumber': medicalAidNumber,
      'medicalAidName': medicalAidName,
      'medicalAidMemberName': medicalAidMemberName,
      'doctorName': doctorName,
      'doctorAddress': doctorAddress,
      'medicalConditions': medicalConditions,
      'specialNeeds': specialNeeds,
      'childDexterity': childDexterity,
      'applicationStatus': applicationStatus,
    };
    if (medicalAidNumber != null) data['medicalAidNumber'] = medicalAidNumber;
    if (medicalAidName != null) data['medicalAidName'] = medicalAidName;
    if (medicalAidMemberName != null)
      data['medicalAidMemberName'] = medicalAidMemberName;
    if (doctorName != null) data['doctorName'] = doctorName;
    if (doctorAddress != null) data['doctorAddress'] = doctorAddress;
    if (medicalConditions != null)
      data['medicalConditions'] = medicalConditions;
    if (specialNeeds != null) data['specialNeeds'] = specialNeeds;
    if (transportDetails != null) data['transportDetails'] = transportDetails;
    if (modeOfTransport != null) data['modeOfTransport'] = modeOfTransport;

    return data;
  }

  ApplicationModel copyWith({
    String? applicationId,
    String? parentId,
    String? parentSurname,
    String? parentName,
    String? parentIdNumber,
    String? parentPhone,
    String? parentEmail,
    String? parentAddress,
    String? relationshipToChild,
    String? childName,
    String? childGender,
    String? childRace,
    String? childIDNumber,
    String? childCitizenship,
    String? countryOfBirth,
    String? province,
    String? childHomeLanguage,
    String? preferredLanguage,
    String? gradeApplyingFor,
    String? prePrimarySchool,
    String? highestGradeCompleted,
    String? yearCompleted,
    String? accessionNumber,
    String? previousSchool,
    String? previousSchoolAddress,
    String? physicalAddress,
    String? city,
    String? postalCode,
    String? emergencyContactName,
    String? emergencyContactNumber,
    String? childPhone,
    String? childEmail,
    String? modeOfTransport,
    String? transportDetails,
    String? medicalAidNumber,
    String? medicalAidName,
    String? medicalAidMemberName,
    String? doctorName,
    String? doctorAddress,
    String? medicalConditions,
    String? specialNeeds,
    String? applicationStatus,
  }) {
    return ApplicationModel(
      applicationId: applicationId ?? this.applicationId,
      parentId: parentId ?? this.parentId,
      parentSurname: parentSurname ?? this.parentSurname,
      parentName: parentName ?? this.parentName,
      parentIdNumber: parentIdNumber ?? this.parentIdNumber,
      parentPhone: parentPhone ?? this.parentPhone,
      parentEmail: parentEmail ?? this.parentEmail,
      parentAddress: parentAddress ?? this.parentAddress,
      relationshipToChild: relationshipToChild ?? this.relationshipToChild,
      childName: childName ?? this.childName,
      childGender: childGender ?? this.childGender,
      childRace: childRace ?? this.childRace,
      childIDNumber: childIDNumber ?? this.childIDNumber,
      childCitizenship: childCitizenship ?? this.childCitizenship,
      countryOfBirth: countryOfBirth ?? this.countryOfBirth,
      province: province ?? this.province,
      childHomeLanguage: childHomeLanguage ?? this.childHomeLanguage,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      gradeApplyingFor: gradeApplyingFor ?? this.gradeApplyingFor,
      prePrimarySchool: prePrimarySchool ?? this.prePrimarySchool,
      highestGradeCompleted:
          highestGradeCompleted ?? this.highestGradeCompleted,
      yearCompleted: yearCompleted ?? this.yearCompleted,
      accessionNumber: accessionNumber ?? this.accessionNumber,
      previousSchool: previousSchool ?? this.previousSchool,
      previousSchoolAddress:
          previousSchoolAddress ?? this.previousSchoolAddress,
      physicalAddress: physicalAddress ?? this.physicalAddress,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactNumber:
          emergencyContactNumber ?? this.emergencyContactNumber,
      childPhone: childPhone ?? this.childPhone,
      childEmail: childEmail ?? this.childEmail,
      modeOfTransport: modeOfTransport ?? this.modeOfTransport,
      transportDetails: transportDetails ?? this.transportDetails,
      medicalAidNumber: medicalAidNumber ?? this.medicalAidNumber,
      medicalAidName: medicalAidName ?? this.medicalAidName,
      medicalAidMemberName: medicalAidMemberName ?? this.medicalAidMemberName,
      doctorName: doctorName ?? this.doctorName,
      doctorAddress: doctorAddress ?? this.doctorAddress,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      specialNeeds: specialNeeds ?? this.specialNeeds,
      childDexterity: childDexterity,
      applicationStatus: applicationStatus ?? this.applicationStatus,
      createdAt: createdAt,
    );
  }
}
