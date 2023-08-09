class Snapper {
  bool _snapped = false;

  bool get snapped {
    if (!_snapped) {
      _snapped = true;
      return false;
    }
    return true;
  }
}

class Lock {
  bool _locked = false;

  void get lock {
    _locked = true;
    return;
  }

  bool get isLocked {
    return _locked;
  }
}
