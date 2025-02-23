// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:pub/src/validator.dart';
import 'package:pub/src/validator/deprecated_fields.dart';
import 'package:test/test.dart';

import '../descriptor.dart' as d;
import '../test_pub.dart';
import 'utils.dart';

Validator deprecatedFields() => DeprecatedFieldsValidator();

void main() {
  setUp(d.validPackage.create);

  test(
    'should not warn if neither transformers or web is included',
    () => expectValidationDeprecated(deprecatedFields),
  );

  test('should warn if pubspec has a transformers section', () async {
    await d.dir(appPath, [
      d.pubspec({
        'transformers': ['some_transformer']
      })
    ]).create();

    await expectValidationDeprecated(deprecatedFields, warnings: isNotEmpty);
  });

  test('should warn if pubspec has a web section', () async {
    await d.dir(appPath, [
      d.pubspec({
        'web': {'compiler': 'dartdevc'}
      })
    ]).create();

    await expectValidationDeprecated(deprecatedFields, warnings: isNotEmpty);
  });

  test('should warn if pubspec has an author', () async {
    await d.dir(appPath, [
      d.pubspec({'author': 'Ronald <ronald@example.com>'})
    ]).create();

    await expectValidationDeprecated(deprecatedFields, warnings: isNotEmpty);
  });

  test('should warn if pubspec has a list of authors', () async {
    await d.dir(appPath, [
      d.pubspec({
        'authors': ['Ronald <ronald@example.com>', 'Joe <joe@example.com>']
      })
    ]).create();

    await expectValidationDeprecated(deprecatedFields, warnings: isNotEmpty);
  });
}
