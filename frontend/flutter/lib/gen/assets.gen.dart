/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsI18nGen {
  const $AssetsI18nGen();

  /// File path: assets/i18n/en.arb
  String get en => 'assets/i18n/en.arb';

  /// File path: assets/i18n/zh.arb
  String get zh => 'assets/i18n/zh.arb';

  /// List of all assets
  List<String> get values => [en, zh];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/alipay.png
  AssetGenImage get alipay => const AssetGenImage('assets/icons/alipay.png');

  /// File path: assets/icons/wechat.png
  AssetGenImage get wechat => const AssetGenImage('assets/icons/wechat.png');

  /// List of all assets
  List<AssetGenImage> get values => [alipay, wechat];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/README.md
  String get readme => 'assets/images/README.md';

  /// File path: assets/images/default_avatar_1.png
  AssetGenImage get defaultAvatar1 =>
      const AssetGenImage('assets/images/default_avatar_1.png');

  /// File path: assets/images/default_avatar_2.png
  AssetGenImage get defaultAvatar2 =>
      const AssetGenImage('assets/images/default_avatar_2.png');

  /// File path: assets/images/default_avatar_3.png
  AssetGenImage get defaultAvatar3 =>
      const AssetGenImage('assets/images/default_avatar_3.png');

  /// File path: assets/images/default_avatar_4.png
  AssetGenImage get defaultAvatar4 =>
      const AssetGenImage('assets/images/default_avatar_4.png');

  /// File path: assets/images/default_avatar_5.png
  AssetGenImage get defaultAvatar5 =>
      const AssetGenImage('assets/images/default_avatar_5.png');

  /// File path: assets/images/forum1.jpg
  AssetGenImage get forum1 => const AssetGenImage('assets/images/forum1.jpg');

  /// File path: assets/images/forum2.jpg
  AssetGenImage get forum2 => const AssetGenImage('assets/images/forum2.jpg');

  /// File path: assets/images/forum3.jpg
  AssetGenImage get forum3 => const AssetGenImage('assets/images/forum3.jpg');

  /// File path: assets/images/forum4.jpg
  AssetGenImage get forum4 => const AssetGenImage('assets/images/forum4.jpg');

  /// File path: assets/images/forum5.jpg
  AssetGenImage get forum5 => const AssetGenImage('assets/images/forum5.jpg');

  /// File path: assets/images/healthy_food.jpg
  AssetGenImage get healthyFood =>
      const AssetGenImage('assets/images/healthy_food.jpg');

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// File path: assets/images/intro1.png
  AssetGenImage get intro1 => const AssetGenImage('assets/images/intro1.png');

  /// File path: assets/images/intro2.png
  AssetGenImage get intro2 => const AssetGenImage('assets/images/intro2.png');

  /// File path: assets/images/intro3.png
  AssetGenImage get intro3 => const AssetGenImage('assets/images/intro3.png');

  /// List of all assets
  List<dynamic> get values => [
        readme,
        defaultAvatar1,
        defaultAvatar2,
        defaultAvatar3,
        defaultAvatar4,
        defaultAvatar5,
        forum1,
        forum2,
        forum3,
        forum4,
        forum5,
        healthyFood,
        logo,
        intro1,
        intro2,
        intro3
      ];
}

class Assets {
  const Assets._();

  static const $AssetsI18nGen i18n = $AssetsI18nGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
