import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/maladh/domain/entities/maladh_header_data.dart';

/// Exhaustive state union for Al-Maladh Sanctuary feature.
sealed class MaladhState extends Equatable {
  const MaladhState();

  @override
  List<Object?> get props => [];
}

final class MaladhInitial extends MaladhState {
  const MaladhInitial();
}

final class MaladhLoading extends MaladhState {
  const MaladhLoading();
}

final class MaladhLoaded extends MaladhState {
  final MaladhHeaderData headerData;

  const MaladhLoaded({required this.headerData});

  @override
  List<Object?> get props => [headerData];
}

final class MaladhError extends MaladhState {
  final String message;

  const MaladhError({required this.message});

  @override
  List<Object?> get props => [message];
}

