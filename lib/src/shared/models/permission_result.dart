class PermissionResult {
  final bool isGranted;
  final bool isPermanentlyDenied;

  const PermissionResult({
    required this.isGranted,
    required this.isPermanentlyDenied,
  });
}
