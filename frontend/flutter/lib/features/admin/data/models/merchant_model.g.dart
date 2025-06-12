// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MerchantModelImpl _$$MerchantModelImplFromJson(Map<String, dynamic> json) =>
    _$MerchantModelImpl(
      id: json['id'] as String,
      businessName: json['businessName'] as String?,
      businessType: json['businessType'] as String?,
      registrationNumber: json['registrationNumber'] as String?,
      taxId: json['taxId'] as String?,
      contact: json['contact'] == null
          ? null
          : ContactInfo.fromJson(json['contact'] as Map<String, dynamic>),
      address: json['address'] == null
          ? null
          : AddressInfo.fromJson(json['address'] as Map<String, dynamic>),
      businessProfile: json['businessProfile'] == null
          ? null
          : BusinessProfile.fromJson(
              json['businessProfile'] as Map<String, dynamic>),
      nutritionFeatures: json['nutritionFeatures'] == null
          ? null
          : NutritionFeatures.fromJson(
              json['nutritionFeatures'] as Map<String, dynamic>),
      verification: json['verification'] == null
          ? null
          : VerificationInfo.fromJson(
              json['verification'] as Map<String, dynamic>),
      accountStatus: json['accountStatus'] == null
          ? null
          : AccountStatus.fromJson(
              json['accountStatus'] as Map<String, dynamic>),
      stats: json['stats'] == null
          ? null
          : MerchantStats.fromJson(json['stats'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isOpen: json['isOpen'] as bool? ?? false,
    );

Map<String, dynamic> _$$MerchantModelImplToJson(_$MerchantModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      if (instance.businessName case final value?) 'businessName': value,
      if (instance.businessType case final value?) 'businessType': value,
      if (instance.registrationNumber case final value?)
        'registrationNumber': value,
      if (instance.taxId case final value?) 'taxId': value,
      if (instance.contact?.toJson() case final value?) 'contact': value,
      if (instance.address?.toJson() case final value?) 'address': value,
      if (instance.businessProfile?.toJson() case final value?)
        'businessProfile': value,
      if (instance.nutritionFeatures?.toJson() case final value?)
        'nutritionFeatures': value,
      if (instance.verification?.toJson() case final value?)
        'verification': value,
      if (instance.accountStatus?.toJson() case final value?)
        'accountStatus': value,
      if (instance.stats?.toJson() case final value?) 'stats': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
      'isOpen': instance.isOpen,
    };

_$ContactInfoImpl _$$ContactInfoImplFromJson(Map<String, dynamic> json) =>
    _$ContactInfoImpl(
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      alternativePhone: json['alternative_phone'] as String?,
      website: json['website'] as String?,
    );

Map<String, dynamic> _$$ContactInfoImplToJson(_$ContactInfoImpl instance) =>
    <String, dynamic>{
      if (instance.email case final value?) 'email': value,
      if (instance.phone case final value?) 'phone': value,
      if (instance.alternativePhone case final value?)
        'alternative_phone': value,
      if (instance.website case final value?) 'website': value,
    };

_$AddressInfoImpl _$$AddressInfoImplFromJson(Map<String, dynamic> json) =>
    _$AddressInfoImpl(
      line1: json['line1'] as String?,
      line2: json['line2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String? ?? 'China',
      coordinates: json['coordinates'] == null
          ? null
          : Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AddressInfoImplToJson(_$AddressInfoImpl instance) =>
    <String, dynamic>{
      if (instance.line1 case final value?) 'line1': value,
      if (instance.line2 case final value?) 'line2': value,
      if (instance.city case final value?) 'city': value,
      if (instance.state case final value?) 'state': value,
      if (instance.postalCode case final value?) 'postalCode': value,
      'country': instance.country,
      if (instance.coordinates?.toJson() case final value?)
        'coordinates': value,
    };

_$CoordinatesImpl _$$CoordinatesImplFromJson(Map<String, dynamic> json) =>
    _$CoordinatesImpl(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CoordinatesImplToJson(_$CoordinatesImpl instance) =>
    <String, dynamic>{
      if (instance.latitude case final value?) 'latitude': value,
      if (instance.longitude case final value?) 'longitude': value,
    };

_$BusinessProfileImpl _$$BusinessProfileImplFromJson(
        Map<String, dynamic> json) =>
    _$BusinessProfileImpl(
      description: json['description'] as String?,
      establishmentYear: (json['establishmentYear'] as num?)?.toInt(),
      operatingHours: (json['operatingHours'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      cuisineTypes: (json['cuisineTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      facilities: (json['facilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      logoUrl: json['logoUrl'] as String?,
      averagePriceRange: json['averagePriceRange'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$BusinessProfileImplToJson(
        _$BusinessProfileImpl instance) =>
    <String, dynamic>{
      if (instance.description case final value?) 'description': value,
      if (instance.establishmentYear case final value?)
        'establishmentYear': value,
      'operatingHours': instance.operatingHours,
      'cuisineTypes': instance.cuisineTypes,
      'facilities': instance.facilities,
      'images': instance.images,
      if (instance.logoUrl case final value?) 'logoUrl': value,
      if (instance.averagePriceRange case final value?)
        'averagePriceRange': value,
    };

_$NutritionFeaturesImpl _$$NutritionFeaturesImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionFeaturesImpl(
      hasNutritionist: json['hasNutritionist'] as bool? ?? false,
      nutritionCertified: json['nutritionCertified'] as bool? ?? false,
      certificationDetails: json['certificationDetails'] as String?,
      specialtyDiets: (json['specialtyDiets'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$NutritionFeaturesImplToJson(
        _$NutritionFeaturesImpl instance) =>
    <String, dynamic>{
      'hasNutritionist': instance.hasNutritionist,
      'nutritionCertified': instance.nutritionCertified,
      if (instance.certificationDetails case final value?)
        'certificationDetails': value,
      if (instance.specialtyDiets case final value?) 'specialtyDiets': value,
    };

_$VerificationInfoImpl _$$VerificationInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationInfoImpl(
      isVerified: json['isVerified'] as bool? ?? false,
      verificationStatus: json['verificationStatus'] as String? ?? 'pending',
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
      verifiedBy: json['verifiedBy'] as String?,
      verificationNotes: json['verificationNotes'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      verificationDocuments: (json['verificationDocuments'] as List<dynamic>?)
          ?.map((e) => VerificationDocument.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$VerificationInfoImplToJson(
        _$VerificationInfoImpl instance) =>
    <String, dynamic>{
      'isVerified': instance.isVerified,
      'verificationStatus': instance.verificationStatus,
      if (instance.verifiedAt?.toIso8601String() case final value?)
        'verifiedAt': value,
      if (instance.verifiedBy case final value?) 'verifiedBy': value,
      if (instance.verificationNotes case final value?)
        'verificationNotes': value,
      if (instance.rejectionReason case final value?) 'rejectionReason': value,
      if (instance.verificationDocuments?.map((e) => e.toJson()).toList()
          case final value?)
        'verificationDocuments': value,
    };

_$VerificationDocumentImpl _$$VerificationDocumentImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationDocumentImpl(
      documentType: json['documentType'] as String?,
      documentUrl: json['documentUrl'] as String?,
      uploadedAt: json['uploadedAt'] == null
          ? null
          : DateTime.parse(json['uploadedAt'] as String),
      status: json['status'] as String? ?? 'pending',
    );

Map<String, dynamic> _$$VerificationDocumentImplToJson(
        _$VerificationDocumentImpl instance) =>
    <String, dynamic>{
      if (instance.documentType case final value?) 'documentType': value,
      if (instance.documentUrl case final value?) 'documentUrl': value,
      if (instance.uploadedAt?.toIso8601String() case final value?)
        'uploadedAt': value,
      'status': instance.status,
    };

_$AccountStatusImpl _$$AccountStatusImplFromJson(Map<String, dynamic> json) =>
    _$AccountStatusImpl(
      isActive: json['isActive'] as bool? ?? true,
      suspensionReason: json['suspensionReason'] as String?,
      suspendedAt: json['suspendedAt'] == null
          ? null
          : DateTime.parse(json['suspendedAt'] as String),
      suspendedBy: json['suspendedBy'] as String?,
      suspensionEndDate: json['suspensionEndDate'] == null
          ? null
          : DateTime.parse(json['suspensionEndDate'] as String),
    );

Map<String, dynamic> _$$AccountStatusImplToJson(_$AccountStatusImpl instance) =>
    <String, dynamic>{
      'isActive': instance.isActive,
      if (instance.suspensionReason case final value?)
        'suspensionReason': value,
      if (instance.suspendedAt?.toIso8601String() case final value?)
        'suspendedAt': value,
      if (instance.suspendedBy case final value?) 'suspendedBy': value,
      if (instance.suspensionEndDate?.toIso8601String() case final value?)
        'suspensionEndDate': value,
    };

_$MerchantStatsImpl _$$MerchantStatsImplFromJson(Map<String, dynamic> json) =>
    _$MerchantStatsImpl(
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0.0,
      avgOrderValue: (json['avgOrderValue'] as num?)?.toDouble() ?? 0.0,
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      healthScore: (json['healthScore'] as num?)?.toInt() ?? 80,
    );

Map<String, dynamic> _$$MerchantStatsImplToJson(_$MerchantStatsImpl instance) =>
    <String, dynamic>{
      'totalOrders': instance.totalOrders,
      'totalSales': instance.totalSales,
      'avgOrderValue': instance.avgOrderValue,
      'avgRating': instance.avgRating,
      'ratingCount': instance.ratingCount,
      'healthScore': instance.healthScore,
    };
