// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vent_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VentStateImpl _$$VentStateImplFromJson(Map<String, dynamic> json) =>
    _$VentStateImpl(
      espIp: json['espIp'] as String? ?? '',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      mode: json['mode'] as String? ?? "off",
      manualTarget: (json['manualTarget'] as num?)?.toDouble() ?? 28.0,
      rangeMin: (json['rangeMin'] as num?)?.toDouble() ?? 24.0,
      rangeMax: (json['rangeMax'] as num?)?.toDouble() ?? 28.0,
      fanOn: json['fanOn'] as bool? ?? false,
      isLoading: json['isLoading'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$VentStateImplToJson(_$VentStateImpl instance) =>
    <String, dynamic>{
      'espIp': instance.espIp,
      'temperature': instance.temperature,
      'mode': instance.mode,
      'manualTarget': instance.manualTarget,
      'rangeMin': instance.rangeMin,
      'rangeMax': instance.rangeMax,
      'fanOn': instance.fanOn,
      'isLoading': instance.isLoading,
      'error': instance.error,
    };
