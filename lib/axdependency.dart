part of 'axmvvm.dart';

/// An object that contains information about resolving an dependency.
class AxDependency {
  Type _dependencyType;
  Lifestyle _registrationLifestyle;
  Object _registeredInstance;
  Function _lazySingletonInstance;
  Function _factoryMethod;

  /// The type of object to create.
  Type get typeRegistered => _dependencyType;

  /// The lifestyle of registration, always get the same instance or new instance per type.
  Lifestyle get registrationType => _registrationLifestyle;

  /// A reference to the object for instance registration.
  Object get registeredInstance => _registeredInstance;

  /// A function to create an instance of a lazy singleton registration.
  Function get lazySingletonInstance => _lazySingletonInstance;

  /// A function to create an instance of an object for type registrations.
  Function get factoryMethod => _factoryMethod;

  AxDependency(Type dependencyType, Lifestyle registrationLifestyle, {Object registerSingleton, Function registerLazySingleton, Function registerTransient}){
    if (registrationLifestyle == null)
      throw ArgumentError('Registration lifestyle cannot be null.');

    if (registrationLifestyle == Lifestyle.singletonRegistration && registerSingleton == null)
      throw StateError('The registered instance cannot be null when the registration lifestyle is an singleton registration.');

    if (registrationLifestyle == Lifestyle.lazySingletonRegistration && registerLazySingleton == null)
      throw StateError('The singleton creation method cannot be null when the registration lifestyle is a lazy singleton registration.');
    
    if (registrationLifestyle == Lifestyle.transientRegistration && registerTransient == null)
      throw StateError('The factory method cannot be null when the registration lifestyle is a transient registration.');

    _dependencyType = dependencyType;
    _registrationLifestyle = registrationLifestyle;
    _registeredInstance = registerSingleton;
    _lazySingletonInstance = registerLazySingleton;
    _factoryMethod = registerTransient;
  }
}