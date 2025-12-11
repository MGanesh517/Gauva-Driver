import 'package:package_info_plus/package_info_plus.dart';

Future<String> getVersion() async {
  final info = await PackageInfo.fromPlatform();
    return 'Version: ${info.version}'; // (Build ${info.buildNumber})
}