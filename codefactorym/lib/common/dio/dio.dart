import 'package:codefactorym/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });
  // 1) 요청 보낼때
  // 요청이 보내질때마다 만약에 요청의 Header에 accessToke: true라는 값이 있다면
  // 실제 토큰을 가져와서 (storage에서) authorization: bearer $token으로 헤더를 변경한다.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO: implement onRequest
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }
    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }
    return super.onRequest(options, handler);
  }
  // 2) 응답을 받을때
  // 3) 에러가 났을때
}