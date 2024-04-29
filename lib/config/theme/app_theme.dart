

import 'package:flutter/material.dart';

const Color _customColor = Color(0xFF053F93);
const List<Color> _colorThemes =[

_customColor,
Color.fromARGB(92, 33, 149, 243)

];


class AppTheme{
final int selectedColor;

  AppTheme({required this.selectedColor}) 
  : assert(selectedColor >= 0 && selectedColor <= _colorThemes.length -1, 'Colors must be between 0 and ${_colorThemes.length}');

  ThemeData theme() {
    return ThemeData(colorSchemeSeed: _colorThemes[selectedColor],
    //brightness: Brightness.dark,
    );
  }
}