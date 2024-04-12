part of 'all_hobbies_bloc.dart';

@immutable
abstract class AllHobbiesState {
  const AllHobbiesState();
}

class HobbiesListState extends AllHobbiesState {
  final Status status;
  final String? errorMessage;
  final bool? isReg;
  final List<AllHobbiesModel>? listAllHobbies;

  const HobbiesListState._({
    required this.status,
    this.errorMessage,
    this.isReg,
    this.listAllHobbies,
  });

  const HobbiesListState.isInitial() : this._(status: Status.isInitial);

  const HobbiesListState.isSuccess({required List<AllHobbiesModel>? listAllHobbies})
      : this._(status: Status.isSuccess, listAllHobbies: listAllHobbies);

  const HobbiesListState.isFailed({required String? errorMessage})
      : this._(status: Status.isFailed, errorMessage: errorMessage);

  const HobbiesListState.isLoading() : this._(status: Status.isLoading);

  const HobbiesListState.isError({required String? errorMessage})
      : this._(status: Status.isError, errorMessage: errorMessage);
}
