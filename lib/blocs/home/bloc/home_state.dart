part of 'home_bloc.dart';

class HomeState<T> {
  final String? error;
  final ApiStatus? apiStatus;
  final T? response;
  final String? textChange;

  const HomeState({
    this.error = "",
    this.textChange = "",
    this.apiStatus = ApiStatus.LOADING,
    this.response,
  });

  HomeState copyWith({
    String? error,
    String? textChange,
    ApiStatus? apiStatus,
    T? response,
  }) {
    return HomeState(
      error: error ?? this.error,
      textChange: textChange ?? this.textChange,
      apiStatus: apiStatus ?? this.apiStatus,
      response: response ?? this.response,
    );
  }

}

class HomeInitial extends HomeState {}
class HomeSuccess extends HomeState {

}
class HomeFail extends HomeState {}


