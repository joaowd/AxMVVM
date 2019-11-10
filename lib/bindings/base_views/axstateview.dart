part of axmvvm.bindings;

/// State object to be used with binding for StatefulViews.
///
/// This class must be exended whenever data binding is desired for a StatelfulView.
/// Intended to be used in conjenction with the AxStatefulView class.
abstract class AxStateView<T extends StatefulWidget, V extends ViewModel>
    extends State<T> implements ViewModelHolder<V> {

  final V _viewModel;
  final bool _isBottomNavigationView;
  bool _viewDidLoad = false;
  bool _isDeviceInPortrait;
  MediaQueryData _mediaQueryData;
  double _deviceWidth;
  double _deviceHeight;

  @mustCallSuper
  AxStateView(this._viewModel, [this._isBottomNavigationView]) {
    if (_viewModel is! ViewModel)
      throw ArgumentError('AxStateView Objects must be of type ViewModel');
  }

  /// The class's viewmodel reference.
  @override
  V get viewModel => _viewModel;

  bool get isDeviceInPortrait => _isDeviceInPortrait;
  bool get isDeviceApple => Platform.isIOS || Platform.isMacOS;
  bool get isDeviceSmartPhone => SmartphoneDetector.isSmartPhone(_mediaQueryData);
  String get deviceOS => Platform.operatingSystem;
  double get deviceWidth => _deviceWidth;
  double get deviceHeight => _deviceHeight;
  MediaQueryData get deviceDataQuery => _mediaQueryData;


  /// This method is only called once when the view is built for the first time.
  /// 
  /// Context of the view is available.
  void viewDidLoad() {
    _mediaQueryData = MediaQuery.of(context);
    _isDeviceInPortrait = _mediaQueryData.orientation == Orientation.portrait;
    _deviceWidth = _mediaQueryData.size.width;
    _deviceHeight = _mediaQueryData.size.height;
    _viewModel.appeared();
    _viewDidLoad = true;
  }

  @override
  void initState(){
    super.initState();
    if(_isBottomNavigationView ?? false)
      _viewModel.initialize(null);
  }
    
  // Creates viewDidLoad functionality
  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!_viewDidLoad)
      viewDidLoad();
  }

  /// Builds the presentaiton for the widget.
  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    AxCore.container.getInstance<IMessageService>().publish(Message(Constants.buildContext, context));
    return null;
  }
}