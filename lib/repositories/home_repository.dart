import 'package:injector/injector.dart';
import 'package:news_app/models/news_list_response.dart';
import 'package:news_app/provider/home_provider.dart';

class HomeRepository {
  final _homeProvider = Injector.appInstance.get<HomeProvider>();

  NewsListResponse? _newsList;

  Future<NewsListResponse?> newsList({required String country, required bool isCountryChange}) async {
    final response = await _homeProvider.getAllNewsByLocation(country: country);
    if (!isCountryChange) {
      if (_newsList != null) {
        return _newsList;
      }
    }
    if (response.success) {
      NewsListResponse _response = NewsListResponse.fromJson(response.body);
      _newsList = _response;
      return _response;
    } else {
      return NewsListResponse(status: "", totalResults: 0, articles: []);
    }
  }

  Future<NewsListResponse?> searchNewsList(
      {required String query, required String sortBy}) async {
    final response =
        await _homeProvider.getNewsBySearch(query: query, sortBy: sortBy);
    if (response.success) {

      NewsListResponse _response = NewsListResponse.fromJson(response.body);
      return _response;
    } else {
      return NewsListResponse(status: "", totalResults: 0, articles: []);
    }
  }

  Future<NewsListResponse?> newsBySourceFilter(
      {required String sources}) async {
    final response =
        await _homeProvider.getNewsBySourceFilter(sources: sources);
    if (response.success) {
      NewsListResponse _response = NewsListResponse.fromJson(response.body);
      return _response;
    } else {
      return NewsListResponse(status: "", totalResults: 0, articles: []);
    }
  }
}
