
import 'package:party_player/bloc/BlocInterface.dart';

class ApplicationBloc extends BlocInterface{


  @override
  void dispose() {
    print( 'Application bloc dispose ');
  }

}