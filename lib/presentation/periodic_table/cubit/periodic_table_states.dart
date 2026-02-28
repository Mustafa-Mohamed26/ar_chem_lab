import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';

abstract class PeriodicTableState {}

class PeriodicTableInitial extends PeriodicTableState {}

class PeriodicTableLoading extends PeriodicTableState {}

class PeriodicTableSuccess extends PeriodicTableState {
  final List<PeriodicTableResponse> elements;
  PeriodicTableSuccess({required this.elements});
}

class PeriodicTableError extends PeriodicTableState {
  final String message;
  PeriodicTableError({required this.message});
}
