import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_response_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponseModel<T> extends Equatable {

  const ApiResponseModel({
    required this.success,
    this.message,
    this.data,
    this.pagination,
    this.count,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseModelFromJson(json, fromJsonT);
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? pagination;
  final int? count;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseModelToJson(this, toJsonT);

  @override
  List<Object?> get props => [success, message, data, pagination, count];
}

@JsonSerializable()
class PaginationModel extends Equatable {

  const PaginationModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
  final int page;
  final int limit;
  final int total;
  final int pages;

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);

  @override
  List<Object?> get props => [page, limit, total, pages];
}
