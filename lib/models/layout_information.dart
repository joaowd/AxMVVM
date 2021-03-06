part of axmvvm.models;

/// Information about the visible view.
class LayoutInformation {
  Size _deviceSize;
  bool _isDeviceInPortrait;
  MediaQueryData _deviceMediaQuery;
  ThemeData _theme;

  LayoutInformation(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    _isDeviceInPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    _theme = Theme.of(context);
    _deviceMediaQuery = MediaQuery.of(context);
  }

  bool get isDeviceInPortrait => _isDeviceInPortrait;
  bool get isDeviceApple => Platform.isIOS || Platform.isMacOS;
  bool get isDeviceSmartPhone => SmartphoneDetector.isSmartPhone(_deviceMediaQuery);
  String get deviceOS => Platform.operatingSystem;
  Size get deviceSize => _deviceSize;
  MediaQueryData get deviceMediaQuery => _deviceMediaQuery;
  ThemeData get theme => _theme;
}