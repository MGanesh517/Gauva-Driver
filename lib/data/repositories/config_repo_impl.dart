import 'package:dartz/dartz.dart';
import 'package:gauva_driver/core/errors/failure.dart';
import 'package:gauva_driver/data/models/car_color_response/car_color_response.dart';
import 'package:gauva_driver/data/models/car_model_response/car_model_response.dart';
import 'package:gauva_driver/data/repositories/base_repository.dart';
import 'package:gauva_driver/data/repositories/interfaces/config_repo_interface.dart';
import 'package:gauva_driver/domain/interfaces/config_service_interface.dart';

class ConfigRepoImpl extends BaseRepository implements IConfigRepository {
  final IConfigService configService;
  ConfigRepoImpl({required this.configService});
  @override
  Future<Either<Failure, CarColorResponse>> getCarColors() async => await safeApiCall(() async {
    final response = await configService.getCarColors();
    return CarColorResponse.fromMap(response.data);
  });

  @override
  Future<Either<Failure, CarModelResponse>> getCarModels() async => await safeApiCall(() async {
    final response = await configService.getCarModels();
    return CarModelResponse.fromMap(response.data);
  });
}
