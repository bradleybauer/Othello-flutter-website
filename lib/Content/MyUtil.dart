import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Timer sleep(seconds, callback) => Timer(Duration(seconds: seconds), callback);

double mix(double a, double b, double m) => a + (b - a) * m;

// Checks if ls1 contains the list ls2
bool containsList(List ls1, List ls2) => ls1.any((x) => listEquals(x, ls2));

double dp2px(double dp, MediaQueryData mqd) => dp * mqd.devicePixelRatio;

const RomanNumerals = {
  0: " ",
  1: "I",
  2: "II",
  3: "III",
  4: "IV",
  5: "V",
  6: "VI",
  7: "VII",
  8: "VIII",
  9: "IX",
  10: "X",
  11: "XI",
  12: "XII",
  13: "XIII",
  14: "XIV",
  15: "XV",
  16: "XVI",
  17: "XVII",
  18: "XVIII",
  19: "XIX",
  20: "XX",
  21: "XXI",
  22: "XXII",
  23: "XXIII",
  24: "XXIV",
  25: "XXV",
  26: "XXVI",
  27: "XXVII",
  28: "XXVIII",
  29: "XXIX",
  30: "XXX",
  31: "XXXI",
  32: "XXXII",
  33: "XXXIII",
  34: "XXXIV",
  35: "XXXV",
  36: "XXXVI",
  37: "XXXVII",
  38: "XXXVIII",
  39: "XXXIX",
  40: "XL",
  41: "XLI",
  42: "XLII",
  43: "XLIII",
  44: "XLIV",
  45: "XLV",
  46: "XLVI",
  47: "XLVII",
  48: "XLVIII",
  49: "XLIX",
  50: "L",
  51: "LI",
  52: "LII",
  53: "LIII",
  54: "LIV",
  55: "LV",
  56: "LVI",
  57: "LVII",
  58: "LVIII",
  59: "LIX",
  60: "LX",
  61: "LXI",
  62: "LXII",
  63: "LXIII",
  64: "LXIV"
};
