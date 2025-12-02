// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mq2_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$Mq2StateImpl _$$Mq2StateImplFromJson(Map<String, dynamic> json) =>
    _$Mq2StateImpl(
      espIp: json['espIp'] as String? ?? '',
      ppm: (json['ppm'] as num?)?.toInt() ?? 0,
      autoOn: json['autoOn'] as bool? ?? false,
      alarmOn: json['alarmOn'] as bool? ?? false,
      lowTh: (json['lowTh'] as num?)?.toInt() ?? 200,
      highTh: (json['highTh'] as num?)?.toInt() ?? 500,
      sensingOn: json['sensingOn'] as bool? ?? true,
      isLoading: json['isLoading'] as bool? ?? false,
      isSaving: json['isSaving'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$Mq2StateImplToJson(_$Mq2StateImpl instance) =>
    <String, dynamic>{
      'espIp': instance.espIp,
      'ppm': instance.ppm,
      'autoOn': instance.autoOn,
      'alarmOn': instance.alarmOn,
      'lowTh': instance.lowTh,
      'highTh': instance.highTh,
      'sensingOn': instance.sensingOn,
      'isLoading': instance.isLoading,
      'isSaving': instance.isSaving,
      'error': instance.error,
    };
