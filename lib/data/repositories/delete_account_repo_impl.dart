import 'package:dartz/dartz.dart';
import 'package:gauva_driver/core/errors/failure.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/data/repositories/base_repository.dart';
import 'package:gauva_driver/data/repositories/interfaces/delete_repo_interface.dart';
import 'package:gauva_driver/domain/interfaces/delete_account_service.dart';

class DeleteAccountRepoImpl extends BaseRepository implements IDeleteAccountRepo {
  final IDeleteAccountService _deleteAccountService;

  DeleteAccountRepoImpl(this._deleteAccountService);
  @override
  Future<Either<Failure, CommonResponse>> deleteAccount() async {
    final data = await safeApiCall(() async {
      final response = await _deleteAccountService.deleteAccount();
      return CommonResponse.fromJson(response.data);
    });
    data.fold((l) => l, (r) => r);
    return data;
  }
}
