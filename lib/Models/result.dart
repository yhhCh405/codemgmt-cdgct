class Result<T> {
  bool get success => _success;
  String? get errorCode => _errorCode;
  String? get errorMessage => _errorMessage;
  T? get data => _data;

  final bool _success;
  String? _errorMessage;
  T? _data;
  String? _errorCode;

  Result.success({T? data}) : _success = true {
    _errorMessage = null;
    _data = data;
    _errorCode = null;
  }

  Result.error(this._errorMessage, {T? result, String? errorCode})
      : _success = false {
    _data = result;
    _errorCode = errorCode;
  }
}
