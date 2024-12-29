
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grpc/grpc.dart';
import 'package:photon/services.dart';

class CookieInterceptor extends ClientInterceptor {
  @override
  ResponseFuture<R> interceptUnary<Q, R>(
      ClientMethod<Q, R> method,
      Q request,
      CallOptions options,
      ClientUnaryInvoker<Q, R> invoker,
      ) {
    if (Services.cookie.isNotEmpty) {
      print("Adding cookie to request");
      options = options.mergedWith(CallOptions(metadata: {'Cookie': "Photon.Auth=${Services.cookie};"}));
    }

    final call = invoker(method, request, options);

    // Handle metadata after the response
    call.headers.then((headers) {
      _processCookies(headers);
    });

    call.trailers.then((trailers) {
      _processCookies(trailers);
    });

    return call;
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
      ClientMethod<Q, R> method,
      Stream<Q> requests,
      CallOptions options,
      ClientStreamingInvoker<Q, R> invoker,
      ) {
    if (Services.cookie.isNotEmpty) {
      print("Adding cookie to request");
      options = options.mergedWith(CallOptions(metadata: {'Cookie': "Photon.Auth=${Services.cookie};"}));
    }

    final call = invoker(method, requests, options);

    call.headers.then((headers) {
      _processCookies(headers);
    });

    call.trailers.then((trailers) {
      _processCookies(trailers);
    });

    return call;
  }

  void _processCookies(Map<String, String> metadata) {
    final setCookieHeader = metadata['set-cookie'];
    if (setCookieHeader != null) {
      // Process your cookies here
      print('Received cookies: $setCookieHeader');

      // Example: Parse and store cookies
      final cookies = setCookieHeader.split(',').map((cookie) => cookie.trim());
      for (final cookie in cookies) {
        _storeCookie(cookie);
      }
    }
  }

  Future<void> _storeCookie(String cookieString) async {
    // Parse cookie string
    final parts = cookieString.split(';')[0].split('=');
    if (parts.length == 2) {
      final name = parts[0].trim();
      final value = parts[1].trim();

      print('Storing cookie: $name=$value');
      Services.cookie = value;
      const storage = FlutterSecureStorage();
      await storage.write(key: "cookie", value: value);
    }
  }
}