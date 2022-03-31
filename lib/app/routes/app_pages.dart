import 'package:get/get.dart';

import '../modules/barcode/bindings/barcode_binding.dart';
import '../modules/barcode/views/barcode_view.dart';
import '../modules/config/bindings/config_binding.dart';
import '../modules/config/views/config_view.dart';
import '../modules/distribute/bindings/distribute_binding.dart';
import '../modules/distribute/views/distribute_view.dart';
import '../modules/edit/bindings/edit_binding.dart';
import '../modules/edit/views/edit_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/list/bindings/list_binding.dart';
import '../modules/list/views/list_view.dart';
import '../modules/orders/bindings/orders_binding.dart';
import '../modules/orders/views/orders_view.dart';
import '../modules/prepare/bindings/prepare_binding.dart';
import '../modules/prepare/views/prepare_view.dart';
import '../modules/prepareConfig/bindings/prepare_config_binding.dart';
import '../modules/prepareConfig/views/prepare_config_view.dart';
import '../modules/products/bindings/products_binding.dart';
import '../modules/products/views/products_view.dart';
import '../modules/serverdown/bindings/serverdown_binding.dart';
import '../modules/serverdown/views/serverdown_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/trolley/bindings/trolley_binding.dart';
import '../modules/trolley/views/trolley_view.dart';
import '../modules/unauthorized/bindings/unauthorized_binding.dart';
import '../modules/unauthorized/views/unauthorized_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LIST,
      page: () => ListView(),
      binding: ListBinding(),
    ),
    GetPage(
      name: _Paths.CONFIG,
      page: () => ConfigView(),
      binding: ConfigBinding(),
    ),
    GetPage(
      name: _Paths.EDIT,
      page: () => EditView(),
      binding: EditBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.TROLLEY,
      page: () => TrolleyView(),
      binding: TrolleyBinding(),
    ),
    GetPage(
      name: _Paths.PREPARE,
      page: () => PrepareView(),
      binding: PrepareBinding(),
    ),
    GetPage(
      name: _Paths.PREPARE_CONFIG,
      page: () => PrepareConfigView(),
      binding: PrepareConfigBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS,
      page: () => OrdersView(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: _Paths.UNAUTHORIZED,
      page: () => UnauthorizedView(),
      binding: UnauthorizedBinding(),
    ),
    GetPage(
      name: _Paths.SERVERDOWN,
      page: () => ServerdownView(),
      binding: ServerdownBinding(),
    ),
    GetPage(
      name: _Paths.DISTRIBUTE,
      page: () => DistributeView(),
      binding: DistributeBinding(),
    ),
    GetPage(
      name: _Paths.BARCODE,
      page: () => BarcodeView(),
      binding: BarcodeBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCTS,
      page: () => ProductsView(),
      binding: ProductsBinding(),
    ),
  ];
}
