import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';

export 'call.dart';

class StoreListItemsParam {
  final List<String> items;
  final KeyValueNames key;

  StoreListItemsParam(this.key, this.items);
}

typedef StoreListItems = UseCase<bool, StoreListItemsParam>;

class StoreListItemsUseCase implements UseCase<bool, StoreListItemsParam> {
  @override
  Future<Optional<bool>> call(StoreListItemsParam param) async {
    try {
      sl<KeyValues>().setItems(param.key, param.items);
      return Optional.newValue(true);
    } on Exception catch (e, st) {
      return Optional.newError(e, st);
    }
  }
}
