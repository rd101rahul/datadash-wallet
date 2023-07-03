import 'package:datadashwallet/features/home/apps/subfeatures/add_dapp/domain/bookmark_repository.dart';
import 'package:datadashwallet/features/security/security.dart';
import 'package:mxc_logic/internal.dart';
import 'package:datadashwallet/core/core.dart';
import 'package:datadashwallet/features/settings/settings.dart';

/// This is cache related to our entire app
/// It is implied that it should never be changed from outside as a result of any events.
/// (e.g. GlobalCache should not reload its data on different user sign in)
class GlobalCache extends GlobalCacheContainer {
  GlobalCache._(CacheManager cacheManager) : super(cacheManager);

  static Future<GlobalCache> load(CacheManager cacheManager) async {
    final cache = GlobalCache._(cacheManager);
    await cache.loadGlobal();
    return cache;
  }

  final ThemeCacheRepository theme = ThemeCacheRepository();
  final LanguageRepository language = LanguageRepository();
  final PasscodeRepository passcode = PasscodeRepository();
  final BookmarkRepository bookmarks = BookmarkRepository();

  @override
  List<BaseCacheRepository> get repositories => [
        theme,
        language,
        passcode,
        bookmarks,
      ];
}
