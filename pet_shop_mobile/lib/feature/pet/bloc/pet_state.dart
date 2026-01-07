import 'package:equatable/equatable.dart';
import 'package:pet_shop_app/feature/pet/models/pet_model.dart';

abstract class PetState extends Equatable {
  const PetState();

  @override
  List<Object?> get props => [];
}

class PetInitial extends PetState {
  const PetInitial();
}

class PetLoading extends PetState {
  const PetLoading();
}

class PetLoaded extends PetState {
  const PetLoaded({
    required this.pets,
    this.totalCount,
    this.currentPage,
    this.totalPages,
  });
  final List<PetModel> pets;
  final int? totalCount;
  final int? currentPage;
  final int? totalPages;

  @override
  List<Object?> get props => [pets, totalCount, currentPage, totalPages];
}

class PetDetailLoaded extends PetState {
  const PetDetailLoaded({required this.pet});
  final PetModel pet;

  @override
  List<Object?> get props => [pet];
}

class PetError extends PetState {
  const PetError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class PetCreated extends PetState {
  const PetCreated({required this.pet});
  final PetModel pet;

  @override
  List<Object?> get props => [pet];
}

class PetUpdated extends PetState {
  const PetUpdated({required this.pet});
  final PetModel pet;

  @override
  List<Object?> get props => [pet];
}

class PetDeleted extends PetState {
  const PetDeleted();
}
