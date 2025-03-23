import 'package:flutter/material.dart';

import '../../../../../configurations/strings.dart';
import 'loading_widget.dart';

class LoadingScreen {
  LoadingScreen._();

  static final LoadingScreen _sharedInstance = LoadingScreen._();

  factory LoadingScreen.instance() => _sharedInstance;

  OverlayEntry? _currentOverlay;

  void show({
    required BuildContext context,
    String text = Strings.loading,
  }) {
    if (_currentOverlay != null) return;

    final overlayState = Overlay.of(context);

    _currentOverlay = OverlayEntry(builder: (context) {
      return LoadingScreenWidget();
    });

    overlayState.insert(_currentOverlay!);
  }

  void hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}
