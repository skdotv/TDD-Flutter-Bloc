import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
    // 
    // list of fields in failure abstract class 
    // 
  const Failure([List properties = const<dynamic>[]]):super();
}


// General Failures 
class ServerFailure extends Failure{


  @override
  List<Object?> get props => [];
  
}

class CacheFailure extends Failure{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

