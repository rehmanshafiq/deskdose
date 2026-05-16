import 'package:deskdose/features/home/domain/usecases/get_daily_stats_usecase.dart';
import 'package:deskdose/features/home/presentation/bloc/home_event.dart';
import 'package:deskdose/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required GetDailyStatsUseCase getDailyStats})
      : _getDailyStats = getDailyStats,
        super(const HomeInitial()) {
    on<LoadDailyStatsEvent>(_onLoad);
  }

  final GetDailyStatsUseCase _getDailyStats;

  Future<void> _onLoad(
    LoadDailyStatsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    final result = await _getDailyStats(const GetDailyStatsParams());
    result.fold(
      (f) => emit(HomeError(message: f.message)),
      (stats) => emit(HomeLoaded(stats: stats)),
    );
  }
}
