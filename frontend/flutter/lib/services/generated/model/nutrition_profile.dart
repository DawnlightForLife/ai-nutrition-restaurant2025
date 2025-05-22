//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class NutritionProfile {
  /// Returns a new [NutritionProfile] instance.
  NutritionProfile({
    this.id,
    this.profileName,
    this.gender,
    this.ageGroup,
    this.height,
    this.weight,
    this.nutritionGoals = const [],
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? profileName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? gender;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? ageGroup;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? height;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? weight;

  List<String> nutritionGoals;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NutritionProfile &&
    other.id == id &&
    other.profileName == profileName &&
    other.gender == gender &&
    other.ageGroup == ageGroup &&
    other.height == height &&
    other.weight == weight &&
    _deepEquality.equals(other.nutritionGoals, nutritionGoals);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (profileName == null ? 0 : profileName!.hashCode) +
    (gender == null ? 0 : gender!.hashCode) +
    (ageGroup == null ? 0 : ageGroup!.hashCode) +
    (height == null ? 0 : height!.hashCode) +
    (weight == null ? 0 : weight!.hashCode) +
    (nutritionGoals.hashCode);

  @override
  String toString() => 'NutritionProfile[id=$id, profileName=$profileName, gender=$gender, ageGroup=$ageGroup, height=$height, weight=$weight, nutritionGoals=$nutritionGoals]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.profileName != null) {
      json[r'profileName'] = this.profileName;
    } else {
      json[r'profileName'] = null;
    }
    if (this.gender != null) {
      json[r'gender'] = this.gender;
    } else {
      json[r'gender'] = null;
    }
    if (this.ageGroup != null) {
      json[r'ageGroup'] = this.ageGroup;
    } else {
      json[r'ageGroup'] = null;
    }
    if (this.height != null) {
      json[r'height'] = this.height;
    } else {
      json[r'height'] = null;
    }
    if (this.weight != null) {
      json[r'weight'] = this.weight;
    } else {
      json[r'weight'] = null;
    }
      json[r'nutritionGoals'] = this.nutritionGoals;
    return json;
  }

  /// Returns a new [NutritionProfile] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static NutritionProfile? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "NutritionProfile[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "NutritionProfile[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return NutritionProfile(
        id: mapValueOfType<String>(json, r'id'),
        profileName: mapValueOfType<String>(json, r'profileName'),
        gender: mapValueOfType<String>(json, r'gender'),
        ageGroup: mapValueOfType<String>(json, r'ageGroup'),
        height: num.parse('${json[r'height']}'),
        weight: num.parse('${json[r'weight']}'),
        nutritionGoals: json[r'nutritionGoals'] is Iterable
            ? (json[r'nutritionGoals'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<NutritionProfile> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NutritionProfile>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NutritionProfile.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NutritionProfile> mapFromJson(dynamic json) {
    final map = <String, NutritionProfile>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = NutritionProfile.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NutritionProfile-objects as value to a dart map
  static Map<String, List<NutritionProfile>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NutritionProfile>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NutritionProfile.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

