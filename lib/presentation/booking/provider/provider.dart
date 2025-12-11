import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/data/repositories/interfaces/status_repo_interface.dart';
import 'package:gauva_driver/domain/interfaces/status_service_interface.dart';

import '../../../data/repositories/status_repo_impl.dart';
import '../../../data/services/status_service.dart';
import '../../auth/provider/auth_providers.dart';

final statusServiceProvider = Provider<IStatusService>((ref) => StatusService(dioClient: ref.read(dioClientProvider)));

final statusRepoProvider = Provider<IStatusRepo>(
  (ref) => StatusRepoImpl(statusService: ref.read(statusServiceProvider)),
);
