//
//  Generated code. Do not modify.
//  source: Auth.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class LoginType extends $pb.ProtobufEnum {
  static const LoginType GOOGLE = LoginType._(0, _omitEnumNames ? '' : 'GOOGLE');
  static const LoginType GITHUB = LoginType._(1, _omitEnumNames ? '' : 'GITHUB');
  static const LoginType DISCORD = LoginType._(2, _omitEnumNames ? '' : 'DISCORD');

  static const $core.List<LoginType> values = <LoginType> [
    GOOGLE,
    GITHUB,
    DISCORD,
  ];

  static final $core.Map<$core.int, LoginType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LoginType? valueOf($core.int value) => _byValue[value];

  const LoginType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
