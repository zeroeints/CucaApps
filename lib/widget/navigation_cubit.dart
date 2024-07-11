import 'package:bloc/bloc.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(index: 0));

  void navigateTo(int index) {
    emit(NavigationState(index: index));
  }
}
