import 'package:crowdleague/actions/problems/remove_problem.dart';
import 'package:crowdleague/actions/problems/add_problem.dart';
import 'package:crowdleague/actions/problems/display_problem.dart';
import 'package:crowdleague/actions/problems/set_displaying_problem.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

typedef AddProblemMiddleware = void Function(
    Store<AppState> store, AddProblem action, NextDispatcher next);
typedef DisplayProblemMiddleware = void Function(
    Store<AppState> store, DisplayProblem action, NextDispatcher next);
typedef RemoveProblemMiddleware = void Function(
    Store<AppState> store, RemoveProblem action, NextDispatcher next);

/// Middleware is used for a variety of things:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createProblemsMiddleware(
    {NavigationService navigationService}) {
  return [
    TypedMiddleware<AppState, AddProblem>(
      _displayAddedProblem(navigationService),
    ),
    TypedMiddleware<AppState, DisplayProblem>(
      _displayProblem(navigationService),
    ),
    TypedMiddleware<AppState, RemoveProblem>(
      _removeProblem(),
    ),
  ];
}

/// [AddProblem] actions trigger a call to display the problem, we then wait for
/// the display to be dismissed and dispatch the awaited action.
///
/// Unlike [DisplayProblem] actions, [AddProblem] actions will go on to add the
/// [Problem] to the app state.
AddProblemMiddleware _displayAddedProblem(
        NavigationService navigationService) =>
    (store, action, next) async {
      next(action); // add the problem to the store

      // if there is not already a problem beign displayed, display this problem
      if (!store.state.displayingProblem) {
        // set the state to indicate a problem is being displayed
        store.dispatch(SetDisplayingProblem((b) => b..displaying = true));

        // display the problem then remove from store when alert is dismissed
        final nextAction = await navigationService.display(action.problem);

        store.dispatch(SetDisplayingProblem((b) => b..displaying = false));
        store.dispatch(nextAction);
      }
    };

/// [DisplayProblem] actions trigger a call to display the problem, we then wait
///  for the display to be dismissed and dispatch the awaited action.
DisplayProblemMiddleware _displayProblem(NavigationService navigationService) =>
    (store, action, next) async {
      next(action); // currently nothing else uses the action but good practice

      // if there is not already a problem beign displayed, display this problem
      if (!store.state.displayingProblem) {
        // set the state to indicate a problem is being displayed
        store.dispatch(SetDisplayingProblem((b) => b..displaying = true));

        // display the problem then remove from store when alert is dismissed
        final nextAction = await navigationService.display(action.problem);

        store.dispatch(SetDisplayingProblem((b) => b..displaying = false));
        store.dispatch(nextAction);
      }
    };

/// On [RemoveProblem] action, after reducer has removed the problem from the
/// list, if there is a problem in the list disatch an action to display it.
RemoveProblemMiddleware _removeProblem() => (store, action, next) async {
      next(action); // let the action continue so reducer can remove the problem

      if (store.state.problems.isNotEmpty) {
        store.dispatch(
          DisplayProblem(
            (b) => b..problem.replace(store.state.problems.last),
          ),
        );
      }
    };
