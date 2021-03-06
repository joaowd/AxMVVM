part of axmvvm;

class AxContainer {
  /// Container of dependency objects.
  static final List<AxDependency> _dependencyContainer = <AxDependency>[];

  /// Get the instance of an object previously registered in the container.
  T getInstance<T>() {
    final Type targetType = Utilities.typeOf<T>();
  
    if (!_dependencyContainer.any((AxDependency dr) => identical(dr.typeRegistered, targetType)))
      throw StateError('The type ' + targetType.toString() + ' is not registered with the IoC container.');

    final AxDependency dependency = _dependencyContainer.singleWhere(
      (AxDependency dr) => identical(dr.typeRegistered, targetType));

    if (dependency.registrationType == Lifestyle.singletonRegistration)
      return dependency.registeredInstance;
    else if (dependency.registrationType == Lifestyle.lazySingletonRegistration){
      _dependencyContainer.removeWhere((AxDependency d) => d == dependency);
      registerSingleton<T>(dependency.lazySingletonInstance());
      
      final AxDependency newDependency = _dependencyContainer.singleWhere(
        (AxDependency dr) => identical(dr.typeRegistered, targetType));
      
      return newDependency.registeredInstance;
    }
    else
      return dependency.factoryMethod();
  }

  /// Registers an [instance] of an object of the generic type.
  ///
  /// All calls to resolve based on this type will always return the registered instance (singleton).
  void registerSingleton<T>(T instance) {
    _checkDependencyRegistration<T>();
    _dependencyContainer.add(AxDependency(T, Lifestyle.singletonRegistration, registerSingleton: instance));
  }

  /// Registers a type that can be resolved.
  ///
  /// The [singletonCreationMethod] is a reference to a function that should create an instance of this type.
  void registerLazySingleton<T>(Function singletonCreationMethod){
    _checkDependencyRegistration<T>();
    _dependencyContainer.add(AxDependency(T, Lifestyle.lazySingletonRegistration, registerLazySingleton: singletonCreationMethod));
  }

  /// Registers a type that can be resolved.
  ///
  /// The [factoryMethod] is a reference to a function that should create an instance of this type.
  void registerTransient<T>(Function factoryMethod){
    _checkDependencyRegistration<T>();
    _dependencyContainer.add(AxDependency(T, Lifestyle.transientRegistration, registerTransient: factoryMethod));
  }

  /// Removes all registrations from the dependency injection container.
  void cleanContainer() {
    _dependencyContainer.clear();
  }

  /// Check if the dependency has already been registered.
  void _checkDependencyRegistration<T>() {
    if(_dependencyContainer.any((AxDependency dr) => identical(dr.typeRegistered, Utilities.typeOf<T>())))
      throw StateError('The same type cannot be registered twice.');
  }
}