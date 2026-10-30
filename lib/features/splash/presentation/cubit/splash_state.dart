import 'package:equatable/equatable.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

final class SplashInitial extends SplashState {
  const SplashInitial();
}

final class SplashAnimating extends SplashState {
  const SplashAnimating();
}

final class SplashCompleted extends SplashState {
  final String destinationRoute;

  const SplashCompleted({required this.destinationRoute});

  @override
  List<Object?> get props => [destinationRoute];
}

final class SplashFailure extends SplashState {
  final String message;

  const SplashFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

