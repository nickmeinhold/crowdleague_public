library signin_with_apple;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/serializers.dart';

part 'sign_in_with_apple.g.dart';

abstract class SignInWithApple extends Object
    with ReduxAction
    implements Built<SignInWithApple, SignInWithAppleBuilder> {
  SignInWithApple._();

  factory SignInWithApple([void Function(SignInWithAppleBuilder) updates]) =
      _$SignInWithApple;

  Object toJson() =>
      serializers.serializeWith(SignInWithApple.serializer, this);

  static SignInWithApple fromJson(String jsonString) => serializers
      .deserializeWith(SignInWithApple.serializer, json.decode(jsonString));

  static Serializer<SignInWithApple> get serializer =>
      _$signInWithAppleSerializer;

  @override
  String toString() => 'SIGN_IN_WITH_APPLE';
}
