import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:practical/constants/status.dart';
import 'package:practical/modules/all_list/model/hobbies_model.dart';
import 'package:practical/modules/all_list/repository/all_hobbies_repository.dart';

part 'all_hobbies_event.dart';

part 'all_hobbies_state.dart';

class AllHobbiesBloc extends Bloc<AllHobbiesEvent, AllHobbiesState> {
  AllHobbiesBloc({required IAllHobbiesRepo allHobbiesRepo})
      : _allHobbiesRepo = allHobbiesRepo, super(const HobbiesListState.isInitial()) {
    on<GetAllHobbiesEvent>(getAllHobbies);
  }
  final IAllHobbiesRepo _allHobbiesRepo;
  Future<void> getAllHobbies(GetAllHobbiesEvent event, Emitter<AllHobbiesState> emit) async {

    try {
      emit(const HobbiesListState.isLoading());
      final response = await _allHobbiesRepo.getHobbies();
      if (response?.isNotEmpty ?? true) {
        emit(HobbiesListState.isSuccess(listAllHobbies: response));
      } else {
        emit(const HobbiesListState.isFailed(errorMessage: 'Please enter valid address.'));
      }
    } catch (e) {
      emit(HobbiesListState.isError(errorMessage: e.toString()));
    }
  }
}
