import 'dart:collection';
import 'dart:io';

import 'package:yaml_modify/yaml_modify.dart';

void concatPubspecYaml({required String fileName}) {
  File tenantFile = File("$fileName.yaml");
  if (tenantFile.existsSync() == false) {
    return;
  }
  File file = File("pubspec.yaml");

  final yaml = loadYaml(file.readAsStringSync());
  final modifiable = getModifiableNode(yaml);

  final tenantYaml = loadYaml(tenantFile.readAsStringSync());
  final tenantModifiable = getModifiableNode(tenantYaml);

  modifiable.putIfAbsent('flutter', () => HashMap());

  if (tenantModifiable['flutter'] != null &&
      tenantModifiable['flutter']["fonts"] != null) {
    if (modifiable['flutter'] == null) {
      modifiable['flutter'] = {"fonts": tenantModifiable['flutter']["fonts"]};
    } else if (modifiable['flutter']["fonts"] == null) {
      modifiable['flutter']["fonts"] = tenantModifiable['flutter']["fonts"];
    } else {
      for (var font in tenantModifiable['flutter']["fonts"]) {
        modifiable['flutter']["fonts"].add(font);
      }
    }
  }

  modifiable.removeWhere((key, value) => value == null);

  final strYaml = toYamlString(modifiable);
  File("pubspec.yaml").writeAsStringSync(strYaml);
}

exec() {
  concatPubspecYaml(fileName: "tenant_pubspec");
}
