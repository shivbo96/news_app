import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/error_response.dart';
import '../views/widgets/common_widget.dart';
import 'api_service.dart';
import 'environment.dart';

InterceptorsWrapper requestInterceptor(Dio dio, Environment env) =>
    InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler requestHandler) {
        final uri = options.uri.toString();

        if (ApiService().isInDebugMode) {
          // debugPrint("Api - URL: ${uri.toString()}");
          // debugPrint("Api - Request Body: ${options.data}");
          // debugPrint("Api - Request header: ${options.headers}");
        }
        return requestHandler.next(options);
      },
      onResponse: (Response<dynamic> response,
          ResponseInterceptorHandler requestHandler) {
        // debugPrint("Api - Response statusCode: ${response.statusCode}");
        if (ApiService().isInDebugMode) {
          // debugPrint("Api - Response: ${response.data}");
        }

        // debugPrint('response $response');
        if (response.statusCode == 200) {
          return requestHandler.next(response);
        }
        handleErrorStatus(response);
        return;
      },
    );

void handleErrorStatus(Response response) {

  switch (response.statusCode) {
    case 500:
      CommonWidget.toast('oops, something went wrong. Please try again later.');
      break;
    default:
      final message = ErrorResponse.fromJson(response.data);
      CommonWidget.toast(message.message.toString());
      break;
  }
  return;
}
