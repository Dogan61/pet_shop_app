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
  final List<PetModel> pets;
  final int? totalCount;
  final int? currentPage;
  final int? totalPages;

  const PetLoaded({
    required this.pets,
    this.totalCount,
    this.currentPage,
    this.totalPages,
  });

  @override
  List<Object?> get props => [pets, totalCount, currentPage, totalPages];
}

class PetDetailLoaded extends PetState {
  final PetModel pet;

  const PetDetailLoaded({required this.pet});

  @override
  List<Object?> get props => [pet];
}

class PetError extends PetState {
  final String message;

  const PetError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PetCreated extends PetState {
  final PetModel pet;

  const PetCreated({required this.pet});

  @override
  List<Object?> get props => [pet];
}

class PetUpdated extends PetState {
  final PetModel pet;

  const PetUpdated({required this.pet});

  @override
  List<Object?> get props => [pet];
}

class PetDeleted extends PetState {
  const PetDeleted();
}

