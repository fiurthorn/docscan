import 'package:document_scanner/core/lib/snapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Snapper', () {
    test('snapped should start at false', () {
      expect(Snapper().snapped, false);
    });

    test('snapped should be true after first call', () {
      final snapper = Snapper();
      expect(snapper.snapped, false);
      expect(snapper.snapped, true);
    });

    test('snapped should be true after second call', () {
      final snapper = Snapper();
      expect(snapper.snapped, false);
      expect(snapper.snapped, true);
      expect(snapper.snapped, true);
    });
  });

  group('Lock', () {
    test('isLocked should start at false', () {
      expect(Lock().isLocked, false);
    });

    test('isLocked should be true after lock call', () {
      final lock = Lock();
      expect(lock.isLocked, false);
      lock.lock;
      expect(lock.isLocked, true);
    });

    test('isLocked should be true after second call', () {
      final lock = Lock();
      expect(lock.isLocked, false);
      lock.lock;
      expect(lock.isLocked, true);
      lock.lock;
      expect(lock.isLocked, true);
    });
  });
}
