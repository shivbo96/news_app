import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String location;

  const User(this.id,this.name,this.location);

  @override
  List<Object> get props {
    return [id,name,location];
  }

  static const empty = User('-','unkown','unkown');
}
