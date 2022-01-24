import 'dart:collection';
import 'dart:io';

import 'package:yaml_modify/yaml_modify.dart';

void concatPubspecYaml() {
  File tenantFile = File("tenant_pubspec.yaml");
  if (tenantFile.existsSync() == false) {
    return;
  }
  File file = File("pubspec.yaml");

  final yaml = loadYaml(file.readAsStringSync());
  final modifiable = getModifiableNode(yaml);

  final tenantYaml = loadYaml(tenantFile.readAsStringSync());
  final tenantModifiable = getModifiableNode(tenantYaml);

  modifiable.putIfAbsent('flutter', () => HashMap());

  if (modifiable['flutter'] == null) {
    modifiable['flutter'] = {
      "fonts": tenantModifiable['flutter']["fonts"]
    };
  } else {
    modifiable['flutter']["fonts"].addAll(tenantModifiable['flutter']["fonts"]);
  }

  final strYaml = toYamlString(modifiable);
  File("pubspec.yaml").writeAsStringSync(strYaml);
}

exec() {
  concatPubspecYaml();
}
