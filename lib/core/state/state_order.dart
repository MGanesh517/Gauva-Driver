import 'package:freezed_annotation/freezed_annotation.dart';

part 'state_order.freezed.dart';

@freezed
class AppStateOrder<T> with _$AppStateOrder<T> {
  const factory AppStateOrder.loading() = _Loading<T>;
  const factory AppStateOrder.success(T data) = _Success<T>;
}