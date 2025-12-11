import 'package:dartz/dartz.dart';
import 'package:gauva_driver/data/models/payment_methods_model/payment_methods_model.dart';
import '../../../core/errors/failure.dart';

abstract class IPaymentMethodsRepo {
  Future<Either<Failure, PaymentMethodsModel>> getPaymentMethods();
}
