import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient._internal()
    : _dio = Dio(
        BaseOptions(
          baseUrl:
              "https://api.clarifai.com/v2/users/7z2r47leuvqi/apps/numi-food-recognition/",
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  void setApiKey(String apiKey) {
    _dio.options.headers["Authorization"] = "Key $apiKey";
  }

  //! POST (required for Clarifai)
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
}
