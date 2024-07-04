import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._authenticationRepository) : super(const HomeState());

  final AuthenticationRepository _authenticationRepository;

  void setTab(HomeTab tab) {
    emit(HomeState(tab: tab));

    if (tab == HomeTab.logout) {
      _authenticationRepository.logOut();
    }
  }
}
