import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_app/cubit/auth_cubit.dart';
import 'package:pokemon_app/ui/screens/home_screen.dart';
import 'package:pokemon_app/ui/screens/auth/login_screen.dart';
import 'package:slide_action/slide_action.dart';

class SlideActionBtn extends StatelessWidget {
  const SlideActionBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SlideAction(
        thumbWidth: 60,
        trackBuilder: (context, state) {
          return Container(
            width: 50,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              color: Colors.white54,
            ),
            child: Center(
              child: Text(
                // Show loading if async operation is being performed
                state.isPerformingAction
                    ? "Loading..."
                    : "Slide to Get Started",
                style: GoogleFonts.pressStart2p(
                  fontSize: 8,
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),
          );
        },
        thumbBuilder: (context, state) {
          return Container(
            margin: const EdgeInsets.all(10),
            decoration: ShapeDecoration(
              color: Colors.orange,
              shape: CircleBorder(),
            ),
            child: Center(
              child: state.isPerformingAction
                  ? const CupertinoActivityIndicator(
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
            ),
          );
        },
        action: () {
          final authState = BlocProvider.of<AuthCubit>(context).state;
          if (authState is AuthLoggedInState) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else if (authState is AuthLoggedOutState) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          }
          print('tapped');
        },
      ),
    );
  }
}
