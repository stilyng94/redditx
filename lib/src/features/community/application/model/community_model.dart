// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class CommunityModel extends Equatable {
  final String id;
  final String name;
  final String banner;
  final String avatarUrl;
  final List<String> members;
  final List<String> mods;

  const CommunityModel({
    required this.id,
    required this.name,
    required this.banner,
    required this.avatarUrl,
    required this.members,
    required this.mods,
  });

  CommunityModel copyWith({
    String? id,
    String? name,
    String? banner,
    String? avatarUrl,
    List<String>? members,
    List<String>? mods,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      banner: banner ?? this.banner,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      members: members ?? this.members,
      mods: mods ?? this.mods,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'banner': banner,
      'avatarUrl': avatarUrl,
      'members': members,
      'mods': mods,
    };
  }

  factory CommunityModel.fromMap(Map<String, dynamic> map) {
    return CommunityModel(
      id: (map['id'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      banner: (map['banner'] ?? '') as String,
      avatarUrl: (map['avatarUrl'] ?? '') as String,
      members: List<String>.from((map['members'] ?? const <String>[])),
      mods: List<String>.from((map['mods'] ?? const <String>[])),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommunityModel.fromJson(String source) =>
      CommunityModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      banner,
      avatarUrl,
      members,
      mods,
    ];
  }
}
