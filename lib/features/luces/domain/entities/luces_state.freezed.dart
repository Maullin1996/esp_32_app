// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'luces_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LucesState {
  String get espIp => throw _privateConstructorUsedError;
  List<bool> get relays => throw _privateConstructorUsedError;
  bool get isSending => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of LucesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LucesStateCopyWith<LucesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LucesStateCopyWith<$Res> {
  factory $LucesStateCopyWith(
    LucesState value,
    $Res Function(LucesState) then,
  ) = _$LucesStateCopyWithImpl<$Res, LucesState>;
  @useResult
  $Res call({String espIp, List<bool> relays, bool isSending, String? error});
}

/// @nodoc
class _$LucesStateCopyWithImpl<$Res, $Val extends LucesState>
    implements $LucesStateCopyWith<$Res> {
  _$LucesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LucesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? espIp = null,
    Object? relays = null,
    Object? isSending = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            espIp: null == espIp
                ? _value.espIp
                : espIp // ignore: cast_nullable_to_non_nullable
                      as String,
            relays: null == relays
                ? _value.relays
                : relays // ignore: cast_nullable_to_non_nullable
                      as List<bool>,
            isSending: null == isSending
                ? _value.isSending
                : isSending // ignore: cast_nullable_to_non_nullable
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
abstract class _$$LucesStateImplCopyWith<$Res>
    implements $LucesStateCopyWith<$Res> {
  factory _$$LucesStateImplCopyWith(
    _$LucesStateImpl value,
    $Res Function(_$LucesStateImpl) then,
  ) = __$$LucesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String espIp, List<bool> relays, bool isSending, String? error});
}

/// @nodoc
class __$$LucesStateImplCopyWithImpl<$Res>
    extends _$LucesStateCopyWithImpl<$Res, _$LucesStateImpl>
    implements _$$LucesStateImplCopyWith<$Res> {
  __$$LucesStateImplCopyWithImpl(
    _$LucesStateImpl _value,
    $Res Function(_$LucesStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LucesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? espIp = null,
    Object? relays = null,
    Object? isSending = null,
    Object? error = freezed,
  }) {
    return _then(
      _$LucesStateImpl(
        espIp: null == espIp
            ? _value.espIp
            : espIp // ignore: cast_nullable_to_non_nullable
                  as String,
        relays: null == relays
            ? _value._relays
            : relays // ignore: cast_nullable_to_non_nullable
                  as List<bool>,
        isSending: null == isSending
            ? _value.isSending
            : isSending // ignore: cast_nullable_to_non_nullable
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

class _$LucesStateImpl implements _LucesState {
  const _$LucesStateImpl({
    required this.espIp,
    required final List<bool> relays,
    required this.isSending,
    this.error,
  }) : _relays = relays;

  @override
  final String espIp;
  final List<bool> _relays;
  @override
  List<bool> get relays {
    if (_relays is EqualUnmodifiableListView) return _relays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relays);
  }

  @override
  final bool isSending;
  @override
  final String? error;

  @override
  String toString() {
    return 'LucesState(espIp: $espIp, relays: $relays, isSending: $isSending, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LucesStateImpl &&
            (identical(other.espIp, espIp) || other.espIp == espIp) &&
            const DeepCollectionEquality().equals(other._relays, _relays) &&
            (identical(other.isSending, isSending) ||
                other.isSending == isSending) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    espIp,
    const DeepCollectionEquality().hash(_relays),
    isSending,
    error,
  );

  /// Create a copy of LucesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LucesStateImplCopyWith<_$LucesStateImpl> get copyWith =>
      __$$LucesStateImplCopyWithImpl<_$LucesStateImpl>(this, _$identity);
}

abstract class _LucesState implements LucesState {
  const factory _LucesState({
    required final String espIp,
    required final List<bool> relays,
    required final bool isSending,
    final String? error,
  }) = _$LucesStateImpl;

  @override
  String get espIp;
  @override
  List<bool> get relays;
  @override
  bool get isSending;
  @override
  String? get error;

  /// Create a copy of LucesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LucesStateImplCopyWith<_$LucesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
