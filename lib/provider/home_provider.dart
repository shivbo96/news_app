import 'dart:convert';

import 'package:dio/dio.dart';

import '../api/api_constants.dart';
import '../api/api_response.dart';
import '../api/api_service.dart';

class HomeProvider{
  HomeProvider({required this.api});

  ApiService api;


  //  //https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=API_KEY



  Future<ApiResponse> getAllNewsByLocation({required String country}) async {
    try {
      Map<String,dynamic> data={"country":country,"apiKey":ApiConstants.newsApiKey};
      final response = await api.dio.get(ApiConstants.topHeadLine,
          queryParameters: data,
          options: Options(
              method: 'GET',
              contentType: "application/json"
          ));
      return ApiResponse.success(response);
    } on DioError catch (e) {
      return ApiResponse.failure(e);
    }
  }

  //https://newsapi.org/v2/everything?q=apple&apiKey=API_KEY

  Future<ApiResponse> getNewsBySearch({required String query,required String sortBy}) async {
    try {
      Map<String,dynamic> data={"q":query,'sortBy':sortBy,"apiKey":ApiConstants.newsApiKey};
      final response = await api.dio.get(ApiConstants.everything,
          queryParameters: data,
          options: Options(
              method: 'GET',
              contentType: "application/json"
          ));

      return ApiResponse.success(response);
    } on DioError catch (e) {
      return ApiResponse.failure(e);
    }
  }

  //https://newsapi.org/v2/top-headlines?sources=Engadget&apiKey=API_KEY

  Future<ApiResponse> getNewsBySourceFilter({required String sources}) async {
    try {
      Map<String,dynamic> data={"sources":sources,"apiKey":ApiConstants.newsApiKey};
      final response = await api.dio.get(ApiConstants.topHeadLine,
          queryParameters: data,
          options: Options(
              method: 'GET',
              contentType: "application/json"
          ));

      return ApiResponse.success(response);
    } on DioError catch (e) {
      return ApiResponse.failure(e);
    }
  }
}