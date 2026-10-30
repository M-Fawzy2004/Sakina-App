import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/maladh/domain/usecases/get_maladh_header_data_usecase.dart';
import 'package:sakina_app/features/maladh/presentation/cubit/maladh_state.dart';

class MaladhCubit extends Cubit<MaladhState> {
  final GetMaladhHeaderDataUseCase getMaladhHeaderDataUseCase;

  MaladhCubit({required this.getMaladhHeaderDataUseCase}) : super(const MaladhInitial());

  Future<void> loadSanctuaryData() async {
    emit(const MaladhLoading());

    final result = await getMaladhHeaderDataUseCase(const NoParams());

    result.fold(
      (failure) => emit(MaladhError(message: failure.message)),
      (headerData) => emit(MaladhLoaded(headerData: headerData)),
    );
  }

  Future<void> refreshSanctuaryData() async {
    final result = await getMaladhHeaderDataUseCase(const NoParams());

    result.fold(
      (failure) => emit(MaladhError(message: failure.message)),
      (headerData) => emit(MaladhLoaded(headerData: headerData)),
    );
  }
}

