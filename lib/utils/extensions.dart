import 'package:flutter/material.dart';

extension SelectedFormatterBackgroundColor on bool {
  Color get color => this ? Colors.grey : Colors.white;
}

extension ColorCompare on Color? {
  bool compare(Color? other) {
    return this?.alpha == other?.alpha &&
        this?.blue == other?.blue &&
        this?.green == other?.green &&
        this?.red == other?.red &&
        this?.opacity == other?.opacity;
  }
}

extension TextCopyWithFormat on Text {
  Text copyWith({
    String? text,
    Locale? tLocale,
    int? tMaxLines,
    TextOverflow? tOverflow,
    Color? tSelectionColor,
    bool? tSoftWrap,
    StrutStyle? tStructStyle,
    TextAlign? tTextAlign,
    String? tSemanticLabel,
    TextDirection? tTextDirection,
    TextHeightBehavior? tTextHeightBehaviour,
    double? tTextScaleFactor,
    TextWidthBasis? tTextWidthBasis,
    TextStyle? textStyle,
  }) {
    return Text(
      text ?? data ?? '',
      locale: tLocale ?? locale,
      maxLines: tMaxLines ?? maxLines,
      overflow: tOverflow ?? overflow,
      selectionColor: tSelectionColor ?? selectionColor,
      softWrap: tSoftWrap ?? softWrap,
      strutStyle: tStructStyle ?? strutStyle,
      textAlign: tTextAlign ?? textAlign,
      textDirection: tTextDirection ?? textDirection,
      semanticsLabel: tSemanticLabel ?? semanticsLabel,
      textHeightBehavior: tTextHeightBehaviour ?? textHeightBehavior,
      textScaleFactor: tTextScaleFactor ?? textScaleFactor,
      textWidthBasis: tTextWidthBasis ?? textWidthBasis,
      style: textStyle ?? style,
    );
  }
}
