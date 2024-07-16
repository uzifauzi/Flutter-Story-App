import 'package:flutter/material.dart';

import 'utils/flavor_config.dart';
import 'my_app.dart';

void main() {
  FlavorConfig(
    flavor: FlavorType.free,
  );

  runApp(const MyApp());
}
