// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceEntityImpl _$$DeviceEntityImplFromJson(Map<String, dynamic> json) =>
    _$DeviceEntityImpl(
      name: json['name'] as String,
      ip: json['ip'] as String,
      type: json['type'] as String? ?? '',
    );

Map<String, dynamic> _$$DeviceEntityImplToJson(_$DeviceEntityImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'ip': instance.ip,
      'type': instance.type,
    };
