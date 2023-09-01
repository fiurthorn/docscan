import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';

export 'call.dart';

class LoadListItemsParam {
  final KeyValueNames key;

  LoadListItemsParam(this.key);
}

typedef LoadListItems = UseCase<List<String>, LoadListItemsParam>;

class LoadListItemsUseCase implements LoadListItems {
  @override
  Future<Optional<List<String>>> call(LoadListItemsParam param) async {
    try {
      return Optional.newValue(await sl<KeyValues>().getItems(param.key));
    } on Exception catch (e, st) {
      return Optional.newError(e, st);
    }
  }
}
