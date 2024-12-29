import 'package:app_links/src/app_links.dart';
import 'package:credential_manager/credential_manager.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:grpc/grpc.dart';
import 'package:photon/constants.dart';
import 'package:photon/cookie_interceptor.dart';
import 'package:photon/generated/Auth.pbgrpc.dart';
import 'package:photon/generated/Avatar.pbgrpc.dart';
import 'package:photon/generated/Users.pb.dart' as users;
import 'package:photon/generated/Users.pbgrpc.dart';

class Services {
  static final CredentialManager credentialManager = CredentialManager();

  static late users.User user;
  static String cookie = "";

  static final ClientChannel channel = ClientChannel(apiUrl,
      options: const ChannelOptions(credentials: ChannelCredentials.secure()));
  static final AuthClient authClient = AuthClient(channel, interceptors: [CookieInterceptor()]);
  static final UsersClient usersClient = UsersClient(channel, interceptors: [CookieInterceptor()]);
  static final AvatarsClient avatarsClient = AvatarsClient(channel, interceptors: [CookieInterceptor()]);

  static AppLinks appLinks = AppLinks();

  static FlutterBackgroundService bgService = FlutterBackgroundService();
}
