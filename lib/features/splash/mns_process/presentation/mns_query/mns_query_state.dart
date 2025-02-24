import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SplashMNSQueryState with EquatableMixin {
  bool isRegistered = false;
  String? errorText;

  @override
  List<Object?> get props => [
        isRegistered,
        errorText,
      ];
}
