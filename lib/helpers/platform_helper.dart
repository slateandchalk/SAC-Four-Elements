import 'package:universal_platform/universal_platform.dart';

PlatformHelper getPlatformHelper() => PlatformHelper();

class PlatformHelper {
  bool get isWeb => UniversalPlatform.isWeb;
}
