import 'package:document_scanner/core/lib/logger.dart';
import 'package:document_scanner/core/widgets/goroute/route.dart';
import 'package:document_scanner/scanner/data/datasources/file_source.dart';
import 'package:document_scanner/scanner/data/datasources/hive_store/initialize.dart';
import 'package:document_scanner/scanner/data/datasources/native.dart';
import 'package:document_scanner/scanner/data/datasources/ocr.dart';
import 'package:document_scanner/scanner/data/repositories/convert.dart';
import 'package:document_scanner/scanner/data/repositories/disk_source.dart';
import 'package:document_scanner/scanner/data/repositories/key_values.dart';
import 'package:document_scanner/scanner/data/repositories/media_store.dart';
import 'package:document_scanner/scanner/data/repositories/pdf.dart';
import 'package:document_scanner/scanner/domain/repositories/convert.dart';
import 'package:document_scanner/scanner/domain/repositories/disk_source.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/repositories/media_store.dart';
import 'package:document_scanner/scanner/domain/repositories/pdf.dart';
import 'package:document_scanner/scanner/domain/usecases/create_pdf_file.dart';
import 'package:document_scanner/scanner/domain/usecases/export_attachment.dart';
import 'package:document_scanner/scanner/domain/usecases/export_database.dart';
import 'package:document_scanner/scanner/domain/usecases/load_list_items.dart';
import 'package:document_scanner/scanner/domain/usecases/read_files.dart';
import 'package:document_scanner/scanner/domain/usecases/store_list_items.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<GetIt> initServiceLocator() async {
  try {
    // data broker
    sl.registerSingleton<Native>(Native());
    sl.registerSingletonAsync<Ocr>(() async => Ocr());
    sl.registerSingletonAsync<FileSource>(() async => FileSource());

    // repositories
    sl.registerSingletonAsync<KeyValues>(
        () async => KeyValuesImpl(await initHive(await sl<Native>().getAppConfigurationDir())));
    sl.registerSingletonAsync<DiskSource>(() async => DiskSourceImpl());
    sl.registerSingletonAsync<PdfCreator>(() async => PdfCreatorImpl());
    sl.registerSingletonAsync<MediaStore>(() async => MediaStoreImpl());
    sl.registerSingletonAsync<ImageConverter>(() async => ImageConverterImpl());

    // use cases
    sl.registerLazySingleton<ReadFiles>(() => ReadFilesUseCase());
    sl.registerLazySingleton<CreatePdfFile>(() => CreatePdfFileUseCase());
    sl.registerLazySingleton<LoadListItems>(() => LoadListItemsUseCase());
    sl.registerLazySingleton<ExportDatabase>(() => ExportDatabaseUseCase());
    sl.registerLazySingleton<StoreListItems>(() => StoreListItemsUseCase());
    sl.registerLazySingleton<ExportAttachment>(() => ExportAttachmentUseCase());

    // others
    sl.registerSingleton<GoRouterObserver>(GoRouterObserver());

    // wait to ready
    return sl.allReady().then((value) => sl).whenComplete(() => Log.less("service locator ready"));
  } on Exception catch (err, stack) {
    Log.high("sl", error: err, stackTrace: stack);
    rethrow;
  }
}
