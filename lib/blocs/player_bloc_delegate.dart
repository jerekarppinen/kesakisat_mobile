import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerBlocDelegate extends BlocDelegate {

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print("event: $event");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print("transition: $transition");
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print("error: $error");
  }
}