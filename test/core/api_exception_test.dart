import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindvibe_app/core/error/app_failure.dart';
import 'package:mindvibe_app/core/network/api_exception.dart';

void main() {
  test('mapeia 409 DEVICE_HAS_ACCOUNT com e-mail mascarado', () {
    final failure = mapDioException(
      DioException(
        requestOptions: RequestOptions(path: '/auth/register'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/register'),
          statusCode: 409,
          data: {
            'message': 'Este aparelho já possui uma conta cadastrada.',
            'code': 'DEVICE_HAS_ACCOUNT',
            'masked_email': 'c***@gmail.com',
          },
        ),
        type: DioExceptionType.badResponse,
      ),
    );

    expect(failure.type, AppFailureType.deviceHasAccount);
    expect(failure.maskedEmail, 'c***@gmail.com');
    expect(failure.isDeviceHasAccount, isTrue);
  });

  test('mapeia falha de conexão como offline', () {
    final failure = mapDioException(
      DioException(
        requestOptions: RequestOptions(path: '/me'),
        type: DioExceptionType.connectionError,
      ),
    );
    expect(failure.type, AppFailureType.offline);
  });
}
