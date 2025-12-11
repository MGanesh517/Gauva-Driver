import 'package:dartz/dartz.dart';
import 'package:gauva_driver/data/models/payment_methods_model/payment_methods_model.dart';
import 'package:gauva_driver/data/repositories/interfaces/payment_methods_repo_interface.dart';
import 'package:gauva_driver/domain/interfaces/payment_method_service_interface.dart';
import '../../core/errors/failure.dart';
import 'base_repository.dart';

class PaymentMethodsRepoImpl extends BaseRepository implements IPaymentMethodsRepo {
  final IPaymentMethodsService paymentMethodsService;

  PaymentMethodsRepoImpl({required this.paymentMethodsService});
  @override
  Future<Either<Failure, PaymentMethodsModel>> getPaymentMethods() async => await safeApiCall(() async {
    final response = await paymentMethodsService.getPaymentMethods();
    return PaymentMethodsModel.fromJson(response.data);
  });
}
