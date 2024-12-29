//
//  Generated code. Do not modify.
//  source: Users.proto
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

import 'Users.pb.dart' as $3;
import 'google/protobuf/empty.pb.dart' as $1;

export 'Users.pb.dart';

@$pb.GrpcServiceName('Photon.Backend.Protos.Users')
class UsersClient extends $grpc.Client {
  static final _$me = $grpc.ClientMethod<$1.Empty, $3.User>(
      '/Photon.Backend.Protos.Users/Me',
      ($1.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.User.fromBuffer(value));
  static final _$updateUsername = $grpc.ClientMethod<$3.UpdateUsernameRequest, $1.Empty>(
      '/Photon.Backend.Protos.Users/UpdateUsername',
      ($3.UpdateUsernameRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$getUser = $grpc.ClientMethod<$3.GetUserRequest, $3.User>(
      '/Photon.Backend.Protos.Users/GetUser',
      ($3.GetUserRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.User.fromBuffer(value));
  static final _$updateFCMToken = $grpc.ClientMethod<$3.UpdateFCMTokenRequest, $1.Empty>(
      '/Photon.Backend.Protos.Users/UpdateFCMToken',
      ($3.UpdateFCMTokenRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));

  UsersClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$3.User> me($1.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$me, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> updateUsername($3.UpdateUsernameRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateUsername, request, options: options);
  }

  $grpc.ResponseFuture<$3.User> getUser($3.GetUserRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getUser, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> updateFCMToken($3.UpdateFCMTokenRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateFCMToken, request, options: options);
  }
}

@$pb.GrpcServiceName('Photon.Backend.Protos.Users')
abstract class UsersServiceBase extends $grpc.Service {
  $core.String get $name => 'Photon.Backend.Protos.Users';

  UsersServiceBase() {
    $addMethod($grpc.ServiceMethod<$1.Empty, $3.User>(
        'Me',
        me_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
        ($3.User value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.UpdateUsernameRequest, $1.Empty>(
        'UpdateUsername',
        updateUsername_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.UpdateUsernameRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.GetUserRequest, $3.User>(
        'GetUser',
        getUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.GetUserRequest.fromBuffer(value),
        ($3.User value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.UpdateFCMTokenRequest, $1.Empty>(
        'UpdateFCMToken',
        updateFCMToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.UpdateFCMTokenRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$3.User> me_Pre($grpc.ServiceCall call, $async.Future<$1.Empty> request) async {
    return me(call, await request);
  }

  $async.Future<$1.Empty> updateUsername_Pre($grpc.ServiceCall call, $async.Future<$3.UpdateUsernameRequest> request) async {
    return updateUsername(call, await request);
  }

  $async.Future<$3.User> getUser_Pre($grpc.ServiceCall call, $async.Future<$3.GetUserRequest> request) async {
    return getUser(call, await request);
  }

  $async.Future<$1.Empty> updateFCMToken_Pre($grpc.ServiceCall call, $async.Future<$3.UpdateFCMTokenRequest> request) async {
    return updateFCMToken(call, await request);
  }

  $async.Future<$3.User> me($grpc.ServiceCall call, $1.Empty request);
  $async.Future<$1.Empty> updateUsername($grpc.ServiceCall call, $3.UpdateUsernameRequest request);
  $async.Future<$3.User> getUser($grpc.ServiceCall call, $3.GetUserRequest request);
  $async.Future<$1.Empty> updateFCMToken($grpc.ServiceCall call, $3.UpdateFCMTokenRequest request);
}
