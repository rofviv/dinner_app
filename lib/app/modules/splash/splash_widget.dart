import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/splash_bloc.dart';


class SplashWidget extends StatelessWidget {
  const SplashWidget({super.key, required this.splashBloc});
  static String route = '/';

  final SplashBloc splashBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(50),
                // child: Image.asset(
                //   "assets/images/logo.png",
                // ),
              ),
              const CupertinoActivityIndicator(color: Colors.white),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BlocBuilder<SplashBloc, SplashState>(
              bloc: splashBloc,
              builder: (context, state) {
                return Center(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        state.errorMessage ?? "",
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}