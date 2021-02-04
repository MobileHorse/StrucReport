import 'package:flutter_bloc/flutter_bloc.dart';

class BlocInspector extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print("---------- Bloc Inspector -> onEvent ----------");
    print(event.toString());
    print("-----------------------------------------------");
    super.onEvent(bloc, event);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print("---------- Bloc Inspector -> onError ----------");
    print(error);
    print("-----------------------------------------------");
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print("---------- Bloc Inspector -> onTransition ----------");
    print("Event: ${transition.event.toString()}");
    print("Current State: ${transition.currentState.toString()}");
    print("Next State: ${transition.nextState.toString()}");
    print("----------------------------------------------------");
    super.onTransition(bloc, transition);
  }
}