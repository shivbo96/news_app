part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class GetNewsByLocation extends HomeEvent {
  final String location;
  final bool? isCountryChange;

  const GetNewsByLocation(this.location,{this.isCountryChange=false});
}

class GetChangeLocation extends HomeEvent {
  final String location;

  const GetChangeLocation(this.location);
}

class GetSearchNewsList extends HomeEvent {
  final String query;
  final String? sortBy;

  const GetSearchNewsList(this.query, {this.sortBy=''});
}

class GetNewsBySourceFilter extends HomeEvent {
  final String sources;

  const GetNewsBySourceFilter(this.sources);
}

