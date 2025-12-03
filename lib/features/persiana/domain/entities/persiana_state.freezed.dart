// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'persiana_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PersianaState {
  String get espIp => throw _privateConstructorUsedError;
  double get temperature =>
      throw _privateConstructorUsedError; // Rango automático de temperatura
  double get rangeMin => throw _privateConstructorUsedError;
  double get rangeMax => throw _privateConstructorUsedError; // PWM (0–255)
  int get pwm =>
      throw _privateConstructorUsedError; // Tiempos para modo AUTO (ms)
  int get timeOpenMs => throw _privateConstructorUsedError;
  int get timeCloseMs =>
      throw _privateConstructorUsedError; // Estado del motor segun ESP: "idle", "opening", "closing"
  String get motorState =>
      throw _privateConstructorUsedError; // "none", "opened", "closed"
  String get lastAction =>
      throw _privateConstructorUsedError; // Modo automático ON/OFF
  bool get autoEnabled =>
      throw _privateConstructorUsedError; // Loading opcional
  bool get isLoading => throw _privateConstructorUsedError; // Error opcional
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of PersianaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersianaStateCopyWith<PersianaState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersianaStateCopyWith<$Res> {
  factory $PersianaStateCopyWith(
    PersianaState value,
    $Res Function(PersianaState) then,
  ) = _$PersianaStateCopyWithImpl<$Res, PersianaState>;
  @useResult
  $Res call({
    String espIp,
    double temperature,
    double rangeMin,
    double rangeMax,
    int pwm,
    int timeOpenMs,
    int timeCloseMs,
    String motorState,
    String lastAction,
    bool autoEnabled,
    bool isLoading,
    String? error,
  });
}

/// @nodoc
class _$PersianaStateCopyWithImpl<$Res, $Val extends PersianaState>
    implements $PersianaStateCopyWith<$Res> {
  _$PersianaStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersianaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? espIp = null,
    Object? temperature = null,
    Object? rangeMin = null,
    Object? rangeMax = null,
    Object? pwm = null,
    Object? timeOpenMs = null,
    Object? timeCloseMs = null,
    Object? motorState = null,
    Object? lastAction = null,
    Object? autoEnabled = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            espIp: null == espIp
                ? _value.espIp
                : espIp // ignore: cast_nullable_to_non_nullable
                      as String,
            temperature: null == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                      as double,
            rangeMin: null == rangeMin
                ? _value.rangeMin
                : rangeMin // ignore: cast_nullable_to_non_nullable
                      as double,
            rangeMax: null == rangeMax
                ? _value.rangeMax
                : rangeMax // ignore: cast_nullable_to_non_nullable
                      as double,
            pwm: null == pwm
                ? _value.pwm
                : pwm // ignore: cast_nullable_to_non_nullable
                      as int,
            timeOpenMs: null == timeOpenMs
                ? _value.timeOpenMs
                : timeOpenMs // ignore: cast_nullable_to_non_nullable
                      as int,
            timeCloseMs: null == timeCloseMs
                ? _value.timeCloseMs
                : timeCloseMs // ignore: cast_nullable_to_non_nullable
                      as int,
            motorState: null == motorState
                ? _value.motorState
                : motorState // ignore: cast_nullable_to_non_nullable
                      as String,
            lastAction: null == lastAction
                ? _value.lastAction
                : lastAction // ignore: cast_nullable_to_non_nullable
                      as String,
            autoEnabled: null == autoEnabled
                ? _value.autoEnabled
                : autoEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PersianaStateImplCopyWith<$Res>
    implements $PersianaStateCopyWith<$Res> {
  factory _$$PersianaStateImplCopyWith(
    _$PersianaStateImpl value,
    $Res Function(_$PersianaStateImpl) then,
  ) = __$$PersianaStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String espIp,
    double temperature,
    double rangeMin,
    double rangeMax,
    int pwm,
    int timeOpenMs,
    int timeCloseMs,
    String motorState,
    String lastAction,
    bool autoEnabled,
    bool isLoading,
    String? error,
  });
}

/// @nodoc
class __$$PersianaStateImplCopyWithImpl<$Res>
    extends _$PersianaStateCopyWithImpl<$Res, _$PersianaStateImpl>
    implements _$$PersianaStateImplCopyWith<$Res> {
  __$$PersianaStateImplCopyWithImpl(
    _$PersianaStateImpl _value,
    $Res Function(_$PersianaStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PersianaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? espIp = null,
    Object? temperature = null,
    Object? rangeMin = null,
    Object? rangeMax = null,
    Object? pwm = null,
    Object? timeOpenMs = null,
    Object? timeCloseMs = null,
    Object? motorState = null,
    Object? lastAction = null,
    Object? autoEnabled = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _$PersianaStateImpl(
        espIp: null == espIp
            ? _value.espIp
            : espIp // ignore: cast_nullable_to_non_nullable
                  as String,
        temperature: null == temperature
            ? _value.temperature
            : temperature // ignore: cast_nullable_to_non_nullable
                  as double,
        rangeMin: null == rangeMin
            ? _value.rangeMin
            : rangeMin // ignore: cast_nullable_to_non_nullable
                  as double,
        rangeMax: null == rangeMax
            ? _value.rangeMax
            : rangeMax // ignore: cast_nullable_to_non_nullable
                  as double,
        pwm: null == pwm
            ? _value.pwm
            : pwm // ignore: cast_nullable_to_non_nullable
                  as int,
        timeOpenMs: null == timeOpenMs
            ? _value.timeOpenMs
            : timeOpenMs // ignore: cast_nullable_to_non_nullable
                  as int,
        timeCloseMs: null == timeCloseMs
            ? _value.timeCloseMs
            : timeCloseMs // ignore: cast_nullable_to_non_nullable
                  as int,
        motorState: null == motorState
            ? _value.motorState
            : motorState // ignore: cast_nullable_to_non_nullable
                  as String,
        lastAction: null == lastAction
            ? _value.lastAction
            : lastAction // ignore: cast_nullable_to_non_nullable
                  as String,
        autoEnabled: null == autoEnabled
            ? _value.autoEnabled
            : autoEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PersianaStateImpl implements _PersianaState {
  const _$PersianaStateImpl({
    this.espIp = '',
    this.temperature = 0.0,
    this.rangeMin = 24.0,
    this.rangeMax = 28.0,
    this.pwm = 180,
    this.timeOpenMs = 1500,
    this.timeCloseMs = 1500,
    this.motorState = 'idle',
    this.lastAction = 'none',
    this.autoEnabled = false,
    this.isLoading = false,
    this.error,
  });

  @override
  @JsonKey()
  final String espIp;
  @override
  @JsonKey()
  final double temperature;
  // Rango automático de temperatura
  @override
  @JsonKey()
  final double rangeMin;
  @override
  @JsonKey()
  final double rangeMax;
  // PWM (0–255)
  @override
  @JsonKey()
  final int pwm;
  // Tiempos para modo AUTO (ms)
  @override
  @JsonKey()
  final int timeOpenMs;
  @override
  @JsonKey()
  final int timeCloseMs;
  // Estado del motor segun ESP: "idle", "opening", "closing"
  @override
  @JsonKey()
  final String motorState;
  // "none", "opened", "closed"
  @override
  @JsonKey()
  final String lastAction;
  // Modo automático ON/OFF
  @override
  @JsonKey()
  final bool autoEnabled;
  // Loading opcional
  @override
  @JsonKey()
  final bool isLoading;
  // Error opcional
  @override
  final String? error;

  @override
  String toString() {
    return 'PersianaState(espIp: $espIp, temperature: $temperature, rangeMin: $rangeMin, rangeMax: $rangeMax, pwm: $pwm, timeOpenMs: $timeOpenMs, timeCloseMs: $timeCloseMs, motorState: $motorState, lastAction: $lastAction, autoEnabled: $autoEnabled, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersianaStateImpl &&
            (identical(other.espIp, espIp) || other.espIp == espIp) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.rangeMin, rangeMin) ||
                other.rangeMin == rangeMin) &&
            (identical(other.rangeMax, rangeMax) ||
                other.rangeMax == rangeMax) &&
            (identical(other.pwm, pwm) || other.pwm == pwm) &&
            (identical(other.timeOpenMs, timeOpenMs) ||
                other.timeOpenMs == timeOpenMs) &&
            (identical(other.timeCloseMs, timeCloseMs) ||
                other.timeCloseMs == timeCloseMs) &&
            (identical(other.motorState, motorState) ||
                other.motorState == motorState) &&
            (identical(other.lastAction, lastAction) ||
                other.lastAction == lastAction) &&
            (identical(other.autoEnabled, autoEnabled) ||
                other.autoEnabled == autoEnabled) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    espIp,
    temperature,
    rangeMin,
    rangeMax,
    pwm,
    timeOpenMs,
    timeCloseMs,
    motorState,
    lastAction,
    autoEnabled,
    isLoading,
    error,
  );

  /// Create a copy of PersianaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersianaStateImplCopyWith<_$PersianaStateImpl> get copyWith =>
      __$$PersianaStateImplCopyWithImpl<_$PersianaStateImpl>(this, _$identity);
}

abstract class _PersianaState implements PersianaState {
  const factory _PersianaState({
    final String espIp,
    final double temperature,
    final double rangeMin,
    final double rangeMax,
    final int pwm,
    final int timeOpenMs,
    final int timeCloseMs,
    final String motorState,
    final String lastAction,
    final bool autoEnabled,
    final bool isLoading,
    final String? error,
  }) = _$PersianaStateImpl;

  @override
  String get espIp;
  @override
  double get temperature; // Rango automático de temperatura
  @override
  double get rangeMin;
  @override
  double get rangeMax; // PWM (0–255)
  @override
  int get pwm; // Tiempos para modo AUTO (ms)
  @override
  int get timeOpenMs;
  @override
  int get timeCloseMs; // Estado del motor segun ESP: "idle", "opening", "closing"
  @override
  String get motorState; // "none", "opened", "closed"
  @override
  String get lastAction; // Modo automático ON/OFF
  @override
  bool get autoEnabled; // Loading opcional
  @override
  bool get isLoading; // Error opcional
  @override
  String? get error;

  /// Create a copy of PersianaState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersianaStateImplCopyWith<_$PersianaStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
