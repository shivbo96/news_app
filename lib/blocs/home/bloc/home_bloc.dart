import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injector/injector.dart';
import 'package:news_app/api/api_response.dart';
import 'package:news_app/models/news_list_response.dart';
import 'package:news_app/repositories/home_repository.dart';

import '../../../api/api_service.dart';
import '../../../models/generic_response.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final _homeRepository = Injector.appInstance.get<HomeRepository>();

  HomeBloc() : super(const HomeState());


@override
Stream<HomeState> mapEventToState(HomeEvent event) async* {
  if (event is GetNewsByLocation) {
    yield* _mapGetNewsByLocationToState(event, state);
  }if (event is GetChangeLocation) {
    yield* _mapGetChangeLocationToState(event, state);
  }else  if (event is GetSearchNewsList) {
    yield* _mapGetSearchNewsListToState(event, state);
  }else  if (event is GetNewsBySourceFilter) {
    yield* _mapGetNewsBySourceFilterToState(event, state);
  }
}

  Stream<HomeState> _mapGetNewsByLocationToState( GetNewsByLocation event, HomeState state) async* {
    yield HomeInitial();
    try {
      final result = await _homeRepository.newsList(country: event.location, isCountryChange:event.isCountryChange!);
      if (result?.status.toString().toLowerCase()=='ok'.toLowerCase()) {
        yield HomeSuccess();
        yield state.copyWith(apiStatus: ApiStatus.SUCCESS,response: result);
      } else {
        yield HomeFail();
        yield state.copyWith(apiStatus: ApiStatus.ERROR, error: 'Something went Wrong');
      }
    } on Exception catch (_) {
      yield HomeFail();
      yield state.copyWith(apiStatus: ApiStatus.ERROR, error: "Something went Wrong");
    }
  }


  Stream<HomeState> _mapGetSearchNewsListToState( GetSearchNewsList event, HomeState state) async* {
    yield HomeInitial();
    try {
      final result = await _homeRepository.searchNewsList(query: event.query,sortBy: event.sortBy.toString());
      if (result?.status.toString().toLowerCase()=='ok'.toLowerCase()) {
        yield HomeSuccess();
        yield state.copyWith(apiStatus: ApiStatus.SUCCESS,response: result);
      } else {
        yield HomeFail();
        yield state.copyWith(apiStatus: ApiStatus.ERROR, error: 'Something went Wrong');
      }
    } on Exception catch (_) {
      yield HomeFail();
      yield state.copyWith(apiStatus: ApiStatus.ERROR, error: "Something went Wrong");
    }
  }


  Stream<HomeState> _mapGetNewsBySourceFilterToState( GetNewsBySourceFilter event, HomeState state) async* {
    yield HomeInitial();
    try {
      final result = await _homeRepository.newsBySourceFilter(sources: event.sources);
      if (result?.status.toString().toLowerCase()=='ok'.toLowerCase()) {
        yield HomeSuccess();
        yield state.copyWith(apiStatus: ApiStatus.SUCCESS,response: result);
      } else {
        yield HomeFail();
        yield state.copyWith(apiStatus: ApiStatus.ERROR, error: 'Something went Wrong');
      }
    } on Exception catch (_) {
      yield HomeFail();
      yield state.copyWith(apiStatus: ApiStatus.ERROR, error: "Something went Wrong");
    }
  }


  Stream<HomeState> _mapGetChangeLocationToState( GetChangeLocation event, HomeState state) async* {
    yield HomeInitial();
    try {

        yield HomeSuccess();
        yield state.copyWith(textChange: event.location);

    } on Exception catch (_) {
      yield HomeFail();
      yield state.copyWith(apiStatus: ApiStatus.ERROR, error: "Something went Wrong");
    }
  }




}
