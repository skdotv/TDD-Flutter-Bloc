import 'package:clean_arch/core/network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity{
} 


void main(){
late NetworkInfoImpl networkInfoImpl;
 late  MockConnectivity mockConnectivity;

  
  setUp((){

    mockConnectivity = MockConnectivity();
    networkInfoImpl = NetworkInfoImpl(mockConnectivity);

  });

  group("isConnected", (){

      test("should forward the call to DataConnectionChecker.hasConnection", ()async{
        const  tConnectivityResult = ConnectivityResult.wifi;
          // arrange 

          when(() => mockConnectivity.checkConnectivity()).thenAnswer((_) async => Future.value(tConnectivityResult));
          
          
          // action 
        
          final result = await networkInfoImpl.isConnected;
          late ConnectivityResult connectionStatus;
          if(result){
          connectionStatus = ConnectivityResult.wifi;
          }else{
            connectionStatus = ConnectivityResult.none;
          }
           
          // assert 
          verify(() => mockConnectivity.checkConnectivity());
          expect(connectionStatus, tConnectivityResult);
          
          


      });

  });



}

