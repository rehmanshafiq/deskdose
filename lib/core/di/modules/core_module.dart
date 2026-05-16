import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:deskdose/core/network/network_info.dart';
import 'package:get_it/get_it.dart';

abstract final class CoreModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(sl<Connectivity>()),
    );
  }
}
