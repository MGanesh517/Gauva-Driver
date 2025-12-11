import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/app_state.dart';
import '../../../data/models/common_response.dart';
import '../../../data/repositories/delete_account_repo_impl.dart';
import '../../../data/repositories/interfaces/delete_repo_interface.dart';
import '../../../data/services/delete_account_service.dart';
import '../../../domain/interfaces/delete_account_service.dart';
import '../../auth/provider/auth_providers.dart';
import '../view_model/delete_account_notifier.dart';


final deleteAccountServiceProvider =
Provider<IDeleteAccountService>((ref) => DeleteAccountService(dioClient: ref.read(dioClientProvider)));

// Repo Provider
final deleteAccountRepoProvider = Provider<IDeleteAccountRepo>((ref) => DeleteAccountRepoImpl(ref.read(deleteAccountServiceProvider)));

// View Model Providers
final deleteAccountProvider = StateNotifierProvider<DeleteAccountNotifier, AppState<CommonResponse>>(
        (ref) => DeleteAccountNotifier(ref: ref, deleteAccountRepo: ref.read(deleteAccountRepoProvider)));
