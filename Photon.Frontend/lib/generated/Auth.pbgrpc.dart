//
//  Generated code. Do not modify.
//  source: Auth.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'Auth.pb.dart' as $0;
import 'google/protobuf/empty.pb.dart' as $1;

export 'Auth.pb.dart';

@$pb.GrpcServiceName('Photon.Backend.Protos.Auth')
class AuthClient extends $grpc.Client {
  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $1.Empty>(
      '/Photon.Backend.Protos.Auth/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));

  AuthClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$1.Empty> login($0.LoginRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$login, request, options: options);
  }
}

@$pb.GrpcServiceName('Photon.Backend.Protos.Auth')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'Photon.Backend.Protos.Auth';

  AuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $1.Empty>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$1.Empty> login_Pre($grpc.ServiceCall call, $async.Future<$0.LoginRequest> request) async {
    return login(call, await request);
  }

  $async.Future<$1.Empty> login($grpc.ServiceCall call, $0.LoginRequest request);
}
