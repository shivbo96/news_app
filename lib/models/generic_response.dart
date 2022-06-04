class GenericResponse {
  dynamic response;
  String? error;
  bool status = false;

  GenericResponse({this.response, this.error, this.status = false});
}
