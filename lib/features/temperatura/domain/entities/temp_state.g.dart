// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temp_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TempStateImpl _$$TempStateImplFromJson(Map<String, dynamic> json) =>
    _$TempStateImpl(
      espIp: json['espIp'] as String? ?? '',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      rangeMin: (json['rangeMin'] as num?)?.toDouble() ?? 30.0,
      rangeMax: (json['rangeMax'] as num?)?.toDouble() ?? 35.0,
      autoEnabled: json['autoEnabled'] as bool? ?? false,
      forcedOff: json['forcedOff'] as bool? ?? false,
      heaterOn: json['heaterOn'] as bool? ?? false,
      isLoading: json['isLoading'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$TempStateImplToJson(_$TempStateImpl instance) =>
    <String, dynamic>{
      'espIp': instance.espIp,
      'temperature': instance.temperature,
      'rangeMin': instance.rangeMin,
      'rangeMax': instance.rangeMax,
      'autoEnabled': instance.autoEnabled,
      'forcedOff': instance.forcedOff,
      'heaterOn': instance.heaterOn,
      'isLoading': instance.isLoading,
      'error': instance.error,
    };
