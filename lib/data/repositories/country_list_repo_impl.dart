import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../../domain/interfaces/country_list_service_interface.dart';
import '../models/country_code_model/country_code_model.dart';
import 'base_repository.dart';
import 'interfaces/country_list_repo_interface.dart';


class CountryListRepoImpl extends BaseRepository implements ICountryListRepo {
  final ICountryListService service;

  CountryListRepoImpl(this.service);
  @override
  Future<Either<Failure, CountryCodeModel>> getCountryList() async => await safeApiCall(() async {
    final response = await service.getCountryList();
    return CountryCodeModel.fromJson(response.data);
  });
}
