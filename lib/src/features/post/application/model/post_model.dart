// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class BasePostModel extends Equatable {
  final String title;
  final String id;
  final String communityProfilePic;
  final String? link;
  final String? description;
  final String communityName;
  final String username;
  final String uid;
  final String postType;
  final DateTime createdAt;
  const BasePostModel({
    required this.title,
    required this.communityProfilePic,
    required this.id,
    this.link,
    this.description,
    required this.communityName,
    required this.username,
    required this.uid,
    required this.postType,
    required this.createdAt,
  });

  @override
  List<Object?> get props {
    return [
      title,
      link,
      description,
      communityName,
      username,
      uid,
      postType,
      id,
      communityProfilePic,
      createdAt,
    ];
  }

  BasePostModel copyBaseWith({
    String? title,
    String? link,
    String? description,
    String? communityName,
    String? username,
    String? uid,
    String? postType,
    DateTime? createdAt,
    String? communityProfilePic,
  }) {
    return BasePostModel(
      title: title ?? this.title,
      id: id,
      link: link ?? this.link,
      description: description ?? this.description,
      communityName: communityName ?? this.communityName,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      postType: postType ?? this.postType,
      createdAt: createdAt ?? this.createdAt,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
    );
  }

  Map<String, dynamic> baseToMap() {
    return <String, dynamic>{
      'title': title,
      'link': link,
      'id': id,
      'description': description,
      'communityName': communityName,
      'username': username,
      'uid': uid,
      'postType': postType,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'communityProfilePic': communityProfilePic
    };
  }
}

class PostModel extends BasePostModel with EquatableMixin {
  final List<String> upVotes;
  final List<String> downVotes;
  final int commentCount;
  final List<String> awards;

  const PostModel(
      {required this.upVotes,
      required this.downVotes,
      required this.commentCount,
      required this.awards,
      required super.title,
      required super.communityName,
      required super.username,
      required super.uid,
      required super.postType,
      required super.createdAt,
      required super.id,
      required super.communityProfilePic,
      super.link,
      super.description});

  PostModel copyWith({
    List<String>? upVotes,
    List<String>? downVotes,
    int? commentCount,
    List<String>? awards,
    String? title,
    String? link,
    String? description,
    String? communityName,
    String? username,
    String? uid,
    String? communityProfilePic,
    String? postType,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
      commentCount: commentCount ?? this.commentCount,
      awards: awards ?? this.awards,
      title: title ?? this.title,
      communityName: communityName ?? this.communityName,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      postType: postType ?? this.postType,
      createdAt: createdAt ?? this.createdAt,
      link: link ?? this.link,
      description: description ?? this.description,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'upVotes': upVotes,
      'downVotes': downVotes,
      'commentCount': commentCount,
      'awards': awards,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      communityProfilePic: (map['communityProfilePic'] ?? '') as String,
      upVotes: List<String>.from(
          (map['upVotes'] ?? const <String>[]) as List<dynamic>),
      downVotes: List<String>.from(
          (map['downVotes'] ?? const <String>[]) as List<dynamic>),
      commentCount: (map['commentCount'] ?? 0) as int,
      awards: List<String>.from(
          (map['awards'] ?? const <String>[]) as List<dynamic>),
      title: (map['title'] ?? '') as String,
      link: map['link'] != null ? map['link'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      communityName: (map['communityName'] ?? '') as String,
      username: (map['username'] ?? '') as String,
      uid: (map['uid'] ?? '') as String,
      postType: (map['postType'] ?? '') as String,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch((map['createdAt'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      upVotes,
      downVotes,
      commentCount,
      awards,
    ];
  }
}
