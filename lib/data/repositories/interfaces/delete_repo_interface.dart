import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../models/common_response.dart';

abstract class IDeleteAccountRepo {
  Future<Either<Failure, CommonResponse>> deleteAccount();
}
