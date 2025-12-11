import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/state/app_state.dart';
import 'package:gauva_driver/data/models/car_color_response/car_color_response.dart';
import 'package:gauva_driver/data/models/car_model_response/car_model_response.dart';
import 'package:gauva_driver/data/repositories/interfaces/config_repo_interface.dart';

class CarModelNotifier extends StateNotifier<AppState<CarModelResponse>> {
  final IConfigRepository configRepo;

  CarModelNotifier(this.configRepo) : super(const AppState.initial());

  Future<void> getCarModels() async {
    state = const AppState.loading();
    final response = await configRepo.getCarModels();
    state = response.fold(
      (failure) => AppState.error(failure),
      (carModelResponse) => AppState.success(carModelResponse),
    );
  }
}

class CarColorNotifier extends StateNotifier<AppState<CarColorResponse>> {
  final IConfigRepository configRepo;

  CarColorNotifier(this.configRepo) : super(const AppState.initial());

  Future<void> getCarColors() async {
    state = const AppState.loading();
    final response = await configRepo.getCarColors();
    state = response.fold(
      (failure) => AppState.error(failure),
      (carModelResponse) => AppState.success(carModelResponse),
    );
  }
}
