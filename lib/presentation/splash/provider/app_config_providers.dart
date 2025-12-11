import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/config_repo_impl.dart';
import '../../../data/repositories/interfaces/config_repo_interface.dart';
import '../../../data/services/config_service.dart';
import '../../../domain/interfaces/config_service_interface.dart';
import '../../auth/provider/auth_providers.dart';

final configServiceProvider =
    Provider<IConfigService>((ref) => ConfigServiceImpl(dioClient: ref.read(dioClientProvider)));

final configRepoProvider =
    Provider<IConfigRepository>((ref) => ConfigRepoImpl(configService: ref.read(configServiceProvider)));
