class Canceler {
  bool _canceled;
  String _message = "";

  Canceler() : _canceled = false;

  cancel([String message = ""]) {
    _canceled = true;
    _message = message;
  }

  String get message => _message;
  bool get hasNotCanceled => !_canceled;
  bool get hasCanceled => _canceled;
}
