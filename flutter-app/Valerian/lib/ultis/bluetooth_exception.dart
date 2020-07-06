class BluetoothException implements Exception {
  final String message;

  BluetoothException({this.message = 'Something went wrong!'});

  @override
  String toString() => message;
}