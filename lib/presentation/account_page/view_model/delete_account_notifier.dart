import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/presentation/booking/provider/home_providers.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/state/app_state.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/common_response.dart';
import '../../../data/repositories/interfaces/delete_repo_interface.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/navigation_service.dart';
import '../../booking/provider/pusher_provider.dart';

class DeleteAccountNotifier extends StateNotifier<AppState<CommonResponse>> {
  final IDeleteAccountRepo _deleteAccountRepo;
  final Ref ref;
  DeleteAccountNotifier({required IDeleteAccountRepo deleteAccountRepo, required this.ref})
    : _deleteAccountRepo = deleteAccountRepo,
      super(const AppState.initial());

  Future<void> deleteAccount() async {
    state = const AppState.loading();
    final result = await _deleteAccountRepo.deleteAccount();

    result.fold(
      (failure) {
        showNotification(message: failure.message);
        state = AppState.error(failure);
      },
      (data) async {
        showNotification(message: data.message, isSuccess: data.success ?? true);
        state = AppState.success(data);
        await LocalStorageService().destroyAll();
        await ref.read(bookingNotifierProvider.notifier).resetState();
        await ref.read(pusherNotifierProvider.notifier).disconnect();
        NavigationService.pushNamedAndRemoveUntil(AppRoutes.login);
      },
    );
  }
}
