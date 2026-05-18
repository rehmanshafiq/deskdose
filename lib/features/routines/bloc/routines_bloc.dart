import 'package:deskdose/data/models/routine.dart';
import 'package:deskdose/data/repositories/routine_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'routines_event.dart';
part 'routines_state.dart';

class RoutinesBloc extends Bloc<RoutinesEvent, RoutinesState> {
  RoutinesBloc({required RoutineRepository routineRepository})
      : _routineRepository = routineRepository,
        super(const RoutinesInitial()) {
    on<RoutinesLoadRequested>(_onLoadRequested);
    on<RoutinesCategoryFilterChanged>(_onCategoryFilterChanged);
    on<RoutinesShowFreeOnlyToggled>(_onShowFreeOnlyToggled);
  }

  final RoutineRepository _routineRepository;
  List<Routine> _allRoutines = [];
  String? _selectedCategory;
  bool _showFreeOnly = false;

  Future<void> _onLoadRequested(
    RoutinesLoadRequested event,
    Emitter<RoutinesState> emit,
  ) async {
    emit(const RoutinesLoading());

    if (event.initialCategory != null) {
      _selectedCategory = event.initialCategory;
    }

    try {
      _allRoutines = await _routineRepository.fetchRoutines();
      emit(_buildLoaded());
    } catch (e) {
      emit(RoutinesError(message: e.toString()));
    }
  }

  void _onCategoryFilterChanged(
    RoutinesCategoryFilterChanged event,
    Emitter<RoutinesState> emit,
  ) {
    _selectedCategory = event.category;
    if (state is RoutinesLoaded || _allRoutines.isNotEmpty) {
      emit(_buildLoaded());
    }
  }

  void _onShowFreeOnlyToggled(
    RoutinesShowFreeOnlyToggled event,
    Emitter<RoutinesState> emit,
  ) {
    _showFreeOnly = !_showFreeOnly;
    if (state is RoutinesLoaded || _allRoutines.isNotEmpty) {
      emit(_buildLoaded());
    }
  }

  RoutinesLoaded _buildLoaded() {
    return RoutinesLoaded(
      routines: _applyFilters(),
      selectedCategory: _selectedCategory,
      showFreeOnly: _showFreeOnly,
    );
  }

  List<Routine> _applyFilters() {
    var list = List<Routine>.from(_allRoutines);

    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      list = list.where((r) => r.category == _selectedCategory).toList();
    }

    if (_showFreeOnly) {
      list = list.where((r) => !r.isPremium).toList();
    }

    return list;
  }
}
