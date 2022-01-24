import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pubspec_modifier/pubspec_modifier.dart';
import 'package:yaml_modify/yaml_modify.dart';

void main() {
  test('yamilicious', () {
    concatPubspecYaml();

    File file = File("pubspec.yaml");
    final yaml = loadYaml(file.readAsStringSync());
    final modifiable = getModifiableNode(yaml);
    expect(modifiable['flutter']["fonts"][1]["family"], "FontFamily2");
    expect(modifiable['flutter']["fonts"][2]["family"], "FontFamily3");
  });
}
