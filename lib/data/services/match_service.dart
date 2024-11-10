import 'package:dio/dio.dart';
import '../core/dio_client.dart';
import '../models/match_model.dart';

class MatchService {
  final Dio _dio = DioClient.instance;

  Future<List<MatchModel>> getMatches() async {
    try {
      final response = await _dio.get('/games', queryParameters: {
        'matchType': 'all'
      });
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => MatchModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          message: '매치 데이터를 가져오는데 실패했습니다.',
        );
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception('연결 시간이 초과되었습니다.');
        case DioExceptionType.receiveTimeout:
          throw Exception('서버 응답 시간이 초과되었습니다.');
        case DioExceptionType.connectionError:
          throw Exception('네트워크 연결을 확인해주세요.');
        case DioExceptionType.badResponse:
          throw Exception('서버 응답 오류: ${e.response?.statusCode}');
        default:
          throw Exception('네트워크 오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('예상치 못한 오류가 발생했습니다: $e');
    }
  }
} 