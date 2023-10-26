import 'package:cisco_szabadulas/helpers/globals.dart' as globals;
import 'package:dart_ping/dart_ping.dart';

class PingSuccess {
  final int successRate;
  final List<String> errors;

  const PingSuccess({
    required int this.successRate,
    required List<String> this.errors,
  });
}

Future<PingSuccess> pingCheck(String address, {int count = 5}) async {
  if (globals.override_ping_check) {
    return PingSuccess(
      errors: [],
      successRate: 100,
    );
  }

  int successful = 0;
  List<String> errors = [];

  for (int i = 0; i < count; i++) {
    final result = await Ping(
      address,
      count: 1,
      forceCodepage: true,
    ).stream.first;
    if (result.error == null) {
      successful++;
    } else {
      errors.add(
        (result.error!.message ?? result.error!.error.message) ??
            // ignore: dead_null_aware_expression
            'Unknown error',
      );
    }
  }

  return PingSuccess(
    errors: errors,
    successRate: successful * 100 ~/ count,
  );
}
