import 'package:crowdleague/actions/auth/sign_up_with_email.dart';
import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/navigation/navigator_pop_all.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/middleware/auth/sign_up_with_email.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../mocks/redux/redux_store_mocks.dart';
import '../../../mocks/services/auth_service_mocks.dart';
import '../../util/testing_utils.dart';

void main() {
  group('SignUpWithEmailMiddleware', () {
    test(
        'on successfull create account in firebase, dispatches correct actions',
        () async {
      // initialize test store/services
      final mockAuthService = MockAuthService();
      final testStore = DispatchVerifyingStore();

      // sign user in successfully
      when(mockAuthService.signUpWithEmail(any, any))
          .thenAnswer((_) async => NavigatorPopAll());

      // setup middleware
      await SignUpWithEmailMiddleware(mockAuthService)(
          testStore, SignUpWithEmail(), testDispatcher);

      // check that correct actions are called in desired order
      verifyInOrder<dynamic>(<dynamic>[
        testStore.dispatch(
            UpdateEmailAuthOptionsPage(step: AuthStep.signingUpWithEmail)),
        testStore.dispatch(NavigatorPopAll()),
        testStore.dispatch(
            UpdateEmailAuthOptionsPage(step: AuthStep.waitingForInput))
      ]);
    });

    test('on error creating account in firebase, dispatches correct actions',
        () async {
      // initialize test store/services
      final mockAuthService = MockAuthService();
      final testStore = DispatchVerifyingStore();
      final problem = AddProblem.from(
        message: '',
        type: ProblemType.emailSignUp,
        traceString: '',
      );

      // create firebase sign in error
      when(mockAuthService.signUpWithEmail(any, any))
          .thenAnswer((_) async => problem);

      // setup middleware
      await SignUpWithEmailMiddleware(mockAuthService)(
          testStore, SignUpWithEmail(), testDispatcher);

      // check that correct actions are called in desired order
      verifyInOrder<dynamic>(<dynamic>[
        testStore.dispatch(
            UpdateEmailAuthOptionsPage(step: AuthStep.signingUpWithEmail)),
        testStore.dispatch(problem),
        testStore.dispatch(
            UpdateEmailAuthOptionsPage(step: AuthStep.waitingForInput))
      ]);
    });
  });
}