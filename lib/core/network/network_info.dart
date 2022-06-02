// creating contracts

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo{
  Future<bool> get isConnected;
}


class NetworkInfoImpl implements NetworkInfo{
  final Connectivity  connectivity;
  NetworkInfoImpl(this.connectivity);

  Future<bool> _checkConnectivity()async{
    ConnectivityResult result = await   connectivity.checkConnectivity(); 
    if(result == ConnectivityResult.wifi || result == ConnectivityResult.wifi){
      return true;
    }else{
      return false;
    }
  }



  @override
  Future<bool> get isConnected =>  _checkConnectivity();

}