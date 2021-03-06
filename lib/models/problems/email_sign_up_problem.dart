library email_sign_up_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'email_sign_up_problem.g.dart';

abstract class EmailSignUpProblem
    implements
        ProblemBase,
        Built<EmailSignUpProblem, EmailSignUpProblemBuilder> {
  EmailSignUpProblem._();

  factory EmailSignUpProblem(
      {String message,
      String trace,
      BuiltMap<String, Object> info}) = _$EmailSignUpProblem._;

  factory EmailSignUpProblem.by(
          [void Function(EmailSignUpProblemBuilder) updates]) =
      _$EmailSignUpProblem;

  Object toJson() =>
      serializers.serializeWith(EmailSignUpProblem.serializer, this);

  static EmailSignUpProblem fromJson(String jsonString) => serializers
      .deserializeWith(EmailSignUpProblem.serializer, json.decode(jsonString));

  static Serializer<EmailSignUpProblem> get serializer =>
      _$emailSignUpProblemSerializer;
}
