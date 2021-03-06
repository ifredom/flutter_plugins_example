import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers.dart';

part 'user.g.dart';

abstract class User implements Built<User, UserBuilder> {
  @nullable
  String get id;
  @nullable
  String get token;

  @nullable
  String get mobile;

  @nullable
  String get nickName;

  @nullable
  int get gender;

  @nullable
  String get age;

  @nullable
  String get provice;

  @nullable
  String get city;

  @nullable
  String get area;

  @nullable
  int get vipFlag;

  @nullable
  String get userType;

  @nullable
  int get validFlag;

  @nullable
  int get deleteFlag;

  @nullable
  String get createBy;

  @nullable
  String get createTime;

  @nullable
  String get updateBy;

  @nullable
  int get updateTime;

  @nullable
  String get proviceId;

  @nullable
  String get cityId;

  @nullable
  String get regionId;

  @nullable
  String get realName;

  @nullable
  String get levelCode;

  @nullable
  String get pwd;

  @nullable
  String get birthday;

  @nullable
  String get firstTeachingDate;

  @nullable
  String get detailAddress;

  @nullable
  String get description;

  @nullable
  String get userImageId;

  @nullable
  String get openId;

  @nullable
  String get vipExpireDate;

  @nullable
  bool get isNewUser;

  @nullable
  int get isSetPwd;

  @nullable
  String get countryId;

  @nullable
  String get country;

  @nullable
  String get teamName;

  @nullable
  String get headImageUrl;

  @nullable
  int get accountBalance;

  @nullable
  int get musicNoteNum;

  @nullable
  int get musicStoneNum;

  @nullable
  int get studentNum;

  @nullable
  int get teachingNum;

  @nullable
  String get alipayAccount;

  // Future<void> setUserType(String type);

  String toJson() {
    return json.encode(serializers.serializeWith(User.serializer, this));
  }

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(User.serializer, this);
  }

  factory User.fromJson(String jsonString) {
    return serializers.deserializeWith(
      User.serializer,
      json.decode(jsonString),
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(
      User.serializer,
      map,
    );
  }

  User._();
  static Serializer<User> get serializer => _$userSerializer;
  factory User([updates(UserBuilder b)]) = _$User;
}
