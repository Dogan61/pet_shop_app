import 'package:equatable/equatable.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {
  const AdminInitial();
}

class AdminLoading extends AdminState {
  const AdminLoading();
}

class AdminChecked extends AdminState {
  const AdminChecked({required this.isAdmin});
  final bool isAdmin;

  @override
  List<Object?> get props => [isAdmin];
}

class AdminError extends AdminState {
  const AdminError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
