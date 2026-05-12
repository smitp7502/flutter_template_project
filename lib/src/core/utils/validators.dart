class Validators {
  final List<String? Function(String?)> _validators = [];

  Validators empty({String message = "Field is required"}) {
    _validators.add((value) {
      if (value == null || value.trim().isEmpty) {
        return message;
      }
      return null;
    });

    return this;
  }

  Validators email({String message = "Invalid email"}) {
    _validators.add((value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');

      if (!emailRegex.hasMatch(value.trim())) {
        return message;
      }

      return null;
    });

    return this;
  }

  Validators minLength(int length, {String? message}) {
    _validators.add((value) {
      if (value == null || value.isEmpty) {
        return null;
      }

      if (value.length < length) {
        return message ?? "Minimum $length characters required";
      }

      return null;
    });

    return this;
  }

  Validators maxLength(int length, {String? message}) {
    _validators.add((value) {
      if (value == null || value.isEmpty) {
        return null;
      }

      if (value.length > length) {
        return message ?? "Maximum $length characters allowed";
      }

      return null;
    });

    return this;
  }

  Validators match(
    String otherValue, {
    String message = "Values do not match",
  }) {
    _validators.add((value) {
      if (value != otherValue) {
        return message;
      }

      return null;
    });

    return this;
  }

  String? validate(String? value) {
    for (final validator in _validators) {
      final result = validator(value);

      if (result != null) {
        return result;
      }
    }

    return null;
  }
}
