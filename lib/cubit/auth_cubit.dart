import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitialState()) {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      emit(AuthLoggedInState(currentUser));
    } else {
      emit(AuthLoggedOutState());
    }
  }
  void loginWithEmailPassword(String email, String password) async {
    emit(AuthLoadingState());

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        emit(AuthLoggedInState(userCredential.user!));
      } else {
        emit(AuthErrorState('Failed to login'));
      }
    } catch (ex) {
      emit(AuthErrorState(ex.toString()));
    }
  }

  void signUpWithEmailPassword(String email, String password) async {
    emit(AuthLoadingState());

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        emit(AuthLoggedInState(userCredential.user!));
      } else {
        emit(AuthErrorState('Failed to sign up'));
      }
    } catch (ex) {
      emit(AuthErrorState(ex.toString()));
    }
  }

  void logOut() async {
    await _auth.signOut();
    emit(AuthLoggedOutState());
  }
}
