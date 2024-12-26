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

import 'Users.pb.dart' as $2;
import 'google/protobuf/empty.pb.dart' as $1;

export 'Users.pb.dart';

@$pb.GrpcServiceName('Photon.Backend.Protos.Users')
class UsersClient extends $grpc.Client {
  static final _$me = $grpc.ClientMethod<$1.Empty, $2.User>(
      '/Photon.Backend.Protos.Users/Me',
      ($1.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.User.fromBuffer(value));

  UsersClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$2.User> me($1.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$me, request, options: options);
  }
}

@$pb.GrpcServiceName('Photon.Backend.Protos.Users')
abstract class UsersServiceBase extends $grpc.Service {
  $core.String get $name => 'Photon.Backend.Protos.Users';

  UsersServiceBase() {
    $addMethod($grpc.ServiceMethod<$1.Empty, $2.User>(
        'Me',
        me_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
        ($2.User value) => value.writeToBuffer()));
  }

  $async.Future<$2.User> me_Pre($grpc.ServiceCall call, $async.Future<$1.Empty> request) async {
    return me(call, await request);
  }

  $async.Future<$2.User> me($grpc.ServiceCall call, $1.Empty request);
}
