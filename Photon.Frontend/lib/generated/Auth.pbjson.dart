//
//  Generated code. Do not modify.
//  source: Auth.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use loginTypeDescriptor instead')
const LoginType$json = {
  '1': 'LoginType',
  '2': [
    {'1': 'GOOGLE', '2': 0},
    {'1': 'GITHUB', '2': 1},
    {'1': 'DISCORD', '2': 2},
  ],
};

/// Descriptor for `LoginType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List loginTypeDescriptor = $convert.base64Decode(
    'CglMb2dpblR5cGUSCgoGR09PR0xFEAASCgoGR0lUSFVCEAESCwoHRElTQ09SRBAC');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'loginType', '3': 2, '4': 1, '5': 14, '6': '.Photon.Backend.Protos.LoginType', '10': 'loginType'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSFAoFdG9rZW4YASABKAlSBXRva2VuEj4KCWxvZ2luVHlwZRgCIAEoDj'
    'IgLlBob3Rvbi5CYWNrZW5kLlByb3Rvcy5Mb2dpblR5cGVSCWxvZ2luVHlwZQ==');

