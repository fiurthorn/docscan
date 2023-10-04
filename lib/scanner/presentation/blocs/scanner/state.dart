part of 'bloc.dart';

class StateParameter extends Equatable {
  final bool showCropper;
  final bool showScanner;

  final List<I18nLabel> areaItems;
  final List<String> senderItems;
  final List<I18nLabel> receiverItems;
  final List<I18nLabel> docTypeItems;

  final String? cropperFilename;
  final Uint8List? cropperImage;
  final List<Tuple2<String, Uint8List>> scannedImages;
  final List<Uint8List?> cachedImages;

  final double amount;
  final double threshold;
  final int currentScannedImage;

  const StateParameter({
    this.showCropper = false,
    this.showScanner = false,
    this.areaItems = const [],
    this.senderItems = const [],
    this.receiverItems = const [],
    this.docTypeItems = const [],
    this.cropperFilename,
    this.cropperImage,
    this.scannedImages = const [],
    this.cachedImages = const [],
    this.amount = 1.0,
    this.threshold = 0.5,
    this.currentScannedImage = 0,
  });

  StateParameter copyWith({
    bool? showCropper,
    bool? showScanner,
    List<I18nLabel>? areaItems,
    List<String>? senderItems,
    List<I18nLabel>? receiverItems,
    List<I18nLabel>? docTypeItems,
    String? cropperFilename,
    Uint8List? cropperImage,
    List<Tuple2<String, Uint8List>>? scannedImages,
    List<Uint8List?>? cachedImages,
    double? amount,
    double? threshold,
    int? currentScannedImage,
  }) {
    return StateParameter(
      showCropper: showCropper ?? this.showCropper,
      showScanner: showScanner ?? this.showScanner,
      areaItems: areaItems ?? this.areaItems,
      senderItems: senderItems ?? this.senderItems,
      receiverItems: receiverItems ?? this.receiverItems,
      docTypeItems: docTypeItems ?? this.docTypeItems,
      cropperFilename: cropperFilename ?? this.cropperFilename,
      cropperImage: cropperImage ?? this.cropperImage,
      scannedImages: scannedImages ?? this.scannedImages,
      cachedImages: cachedImages ?? this.cachedImages,
      amount: amount ?? this.amount,
      threshold: threshold ?? this.threshold,
      currentScannedImage: currentScannedImage ?? this.currentScannedImage,
    );
  }

  @override
  List<Object?> get props => [
        showCropper,
        showScanner,
        areaItems,
        senderItems,
        receiverItems,
        docTypeItems,
        cropperFilename,
        cropperImage,
        cachedImages,
        scannedImages,
        amount,
        threshold,
        currentScannedImage,
      ];

  List<String> filterSenderItems(String text) {
    if (text.isEmpty) {
      return senderItems;
    } else {
      return senderItems.where((element) => element.toLowerCase().contains(text.toLowerCase())).toList();
    }
  }
}

class FileAttachment extends Equatable {
  final String name;
  final Uint8List data;
  final int size;

  const FileAttachment(this.name, this.data, this.size);

  @override
  List<Object?> get props => [
        name,
        data,
        size,
      ];
}
