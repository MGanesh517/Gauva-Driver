import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../models/country_code_model/country_code_model.dart';

abstract class ICountryListRepo {
  Future<Either<Failure, CountryCodeModel>> getCountryList();
}
