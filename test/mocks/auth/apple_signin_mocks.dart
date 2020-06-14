import 'package:mockito/mockito.dart';
import 'package:crowdleague/utils/apple_signin_object.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FakeAppleSignIn extends Fake implements AppleSignInObject {
  @override
  Future<AuthorizationCredentialAppleID> getAppleIDCredential() {
    final result = AuthorizationCredentialAppleID(
        authorizationCode: 'code',
        identityToken: 'token',
        familyName: 'fname',
        givenName: 'gname',
        email: 'email',
        state: 'state',
        userIdentifier: 'id');
    return Future.value(result);
  }
}

// When the user cancels during the signin process, startAuth throws AuthorizationErrorCode
class FakeAppleSignInCancels extends Fake implements AppleSignInObject {
  @override
  Future<AuthorizationCredentialAppleID> getAppleIDCredential() {
    throw SignInWithAppleAuthorizationException(
        code: AuthorizationErrorCode.canceled, message: 'message');
  }
}

class FakeAppleSignInThrows extends Fake implements AppleSignInObject {
  @override
  Future<AuthorizationCredentialAppleID> getAppleIDCredential() {
    throw Exception('AppleSignIn.signIn');
  }
}