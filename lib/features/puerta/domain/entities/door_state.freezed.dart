// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'door_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DoorState {
  String get espIp =>
      throw _privateConstructorUsedError; // Lectura de luz (0–100 %)
  double get lux =>
      throw _privateConstructorUsedError; // Umbral de cambio día/noche
  int get threshold =>
      throw _privateConstructorUsedError; // "idle", "opening", "closing"
  String get state =>
      throw _privateConstructorUsedError; // 0/1 desde el ESP pero aquí como bool
  bool get autoEnabled => throw _privateConstructorUsedError;
  bool get fullyOpen => throw _privateConstructorUsedError;
  bool get fullyClosed => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of DoorState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DoorStateCopyWith<DoorState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DoorStateCopyWith<$Res> {
  factory $DoorStateCopyWith(DoorState value, $Res Function(DoorState) then) =
      _$DoorStateCopyWithImpl<$Res, DoorState>;
  @useResult
  $Res call({
    String espIp,
    double lux,
    int threshold,
    String state,
    bool autoEnabled,
    bool fullyOpen,
    bool fullyClosed,
    bool isLoading,
    String? error,
  });
}

/// @nodoc
class _$DoorStateCopyWithImpl<$Res, $Val extends DoorState>
    implements $DoorStateCopyWith<$Res> {
  _$DoorStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DoorState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? espIp = null,
    Object? lux = null,
    Object? threshold = null,
    Object? state = null,
    Object? autoEnabled = null,
    Object? fullyOpen = null,
    Object? fullyClosed = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            espIp: null == espIp
                ? _value.espIp
                : espIp // ignore: cast_nullable_to_non_nullable
                      as String,
            lux: null == lux
                ? _value.lux
                : lux // ignore: cast_nullable_to_non_nullable
                      as double,
            threshold: null == threshold
                ? _value.threshold
                : threshold // ignore: cast_nullable_to_non_nullable
                      as int,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String,
            autoEnabled: null == autoEnabled
                ? _value.autoEnabled
                : autoEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            fullyOpen: null == fullyOpen
                ? _value.fullyOpen
                : fullyOpen // ignore: cast_nullable_to_non_nullable
                      as bool,
            fullyClosed: null == fullyClosed
                ? _value.fullyClosed
                : fullyClosed // ignore: cast_nullable_to_non_nullable
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
abstract class _$$DoorStateImplCopyWith<$Res>
    implements $DoorStateCopyWith<$Res> {
  factory _$$DoorStateImplCopyWith(
    _$DoorStateImpl value,
    $Res Function(_$DoorStateImpl) then,
  ) = __$$DoorStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String espIp,
    double lux,
    int threshold,
    String state,
    bool autoEnabled,
    bool fullyOpen,
    bool fullyClosed,
    bool isLoading,
    String? error,
  });
}

/// @nodoc
class __$$DoorStateImplCopyWithImpl<$Res>
    extends _$DoorStateCopyWithImpl<$Res, _$DoorStateImpl>
    implements _$$DoorStateImplCopyWith<$Res> {
  __$$DoorStateImplCopyWithImpl(
    _$DoorStateImpl _value,
    $Res Function(_$DoorStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DoorState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? espIp = null,
    Object? lux = null,
    Object? threshold = null,
    Object? state = null,
    Object? autoEnabled = null,
    Object? fullyOpen = null,
    Object? fullyClosed = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _$DoorStateImpl(
        espIp: null == espIp
            ? _value.espIp
            : espIp // ignore: cast_nullable_to_non_nullable
                  as String,
        lux: null == lux
            ? _value.lux
            : lux // ignore: cast_nullable_to_non_nullable
                  as double,
        threshold: null == threshold
            ? _value.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as int,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String,
        autoEnabled: null == autoEnabled
            ? _value.autoEnabled
            : autoEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        fullyOpen: null == fullyOpen
            ? _value.fullyOpen
            : fullyOpen // ignore: cast_nullable_to_non_nullable
                  as bool,
        fullyClosed: null == fullyClosed
            ? _value.fullyClosed
            : fullyClosed // ignore: cast_nullable_to_non_nullable
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

class _$DoorStateImpl implements _DoorState {
  const _$DoorStateImpl({
    this.espIp = '',
    this.lux = 0.0,
    this.threshold = 40,
    this.state = 'idle',
    this.autoEnabled = false,
    this.fullyOpen = false,
    this.fullyClosed = false,
    this.isLoading = false,
    this.error,
  });

  @override
  @JsonKey()
  final String espIp;
  // Lectura de luz (0–100 %)
  @override
  @JsonKey()
  final double lux;
  // Umbral de cambio día/noche
  @override
  @JsonKey()
  final int threshold;
  // "idle", "opening", "closing"
  @override
  @JsonKey()
  final String state;
  // 0/1 desde el ESP pero aquí como bool
  @override
  @JsonKey()
  final bool autoEnabled;
  @override
  @JsonKey()
  final bool fullyOpen;
  @override
  @JsonKey()
  final bool fullyClosed;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'DoorState(espIp: $espIp, lux: $lux, threshold: $threshold, state: $state, autoEnabled: $autoEnabled, fullyOpen: $fullyOpen, fullyClosed: $fullyClosed, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoorStateImpl &&
            (identical(other.espIp, espIp) || other.espIp == espIp) &&
            (identical(other.lux, lux) || other.lux == lux) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.autoEnabled, autoEnabled) ||
                other.autoEnabled == autoEnabled) &&
            (identical(other.fullyOpen, fullyOpen) ||
                other.fullyOpen == fullyOpen) &&
            (identical(other.fullyClosed, fullyClosed) ||
                other.fullyClosed == fullyClosed) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    espIp,
    lux,
    threshold,
    state,
    autoEnabled,
    fullyOpen,
    fullyClosed,
    isLoading,
    error,
  );

  /// Create a copy of DoorState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DoorStateImplCopyWith<_$DoorStateImpl> get copyWith =>
      __$$DoorStateImplCopyWithImpl<_$DoorStateImpl>(this, _$identity);
}

abstract class _DoorState implements DoorState {
  const factory _DoorState({
    final String espIp,
    final double lux,
    final int threshold,
    final String state,
    final bool autoEnabled,
    final bool fullyOpen,
    final bool fullyClosed,
    final bool isLoading,
    final String? error,
  }) = _$DoorStateImpl;

  @override
  String get espIp; // Lectura de luz (0–100 %)
  @override
  double get lux; // Umbral de cambio día/noche
  @override
  int get threshold; // "idle", "opening", "closing"
  @override
  String get state; // 0/1 desde el ESP pero aquí como bool
  @override
  bool get autoEnabled;
  @override
  bool get fullyOpen;
  @override
  bool get fullyClosed;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of DoorState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DoorStateImplCopyWith<_$DoorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
