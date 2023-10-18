import 'package:document_scanner/core/lib/either.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';

export 'call.dart';

class StoreListItemsParam {
  final List<String> items;
  final KeyValueNames key;

  StoreListItemsParam(this.key, this.items);
}

typedef StoreListItemsResult = bool;
typedef StoreListItems = UseCase<StoreListItemsResult, StoreListItemsParam>;

class StoreListItemsUseCase implements StoreListItems {
  @override
  Future<Either<StoreListItemsResult>> call(StoreListItemsParam param) async {
    try {
      return sl<KeyValues>().setItems(param.key, param.items).then((_) => const Either.value(true));
    } on Exception catch (e, st) {
      return Either.failure(e, st);
    }
  }
}
