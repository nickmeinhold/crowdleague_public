import 'package:crowdleague/models/actions/navigation/add_route_info.dart';
import 'package:crowdleague/models/actions/navigation/remove_route_info.dart';
import 'package:crowdleague/models/actions/navigation/replace_route_info.dart';
import 'package:crowdleague/models/actions/store_nav_index.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app_state.dart';

/// Reducers specify how the application"s state changes in response to actions
/// sent to the store.
///
/// Each reducer returns a new [AppState].
final navigationReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, StoreNavIndex>(_storeNavIndex),
  TypedReducer<AppState, AddRouteInfo>(_addRouteInfo),
  TypedReducer<AppState, RemoveRouteInfo>(_removeRouteInfo),
  TypedReducer<AppState, ReplaceRouteInfo>(_replaceRouteInfo),
];

AppState _addRouteInfo(AppState state, AddRouteInfo action) {
  return state.rebuild((b) => b..routes.add(action.info));
}

AppState _removeRouteInfo(AppState state, RemoveRouteInfo action) {
  return state.rebuild((b) => b..routes.remove(action.info));
}

AppState _replaceRouteInfo(AppState state, ReplaceRouteInfo action) {
  return state.rebuild((b) => b
    ..routes.remove(action.oldInfo)
    ..routes.add(action.newInfo));
}

AppState _storeNavIndex(AppState state, StoreNavIndex action) {
  return state.rebuild((b) => b..navIndex = action.index);
}
