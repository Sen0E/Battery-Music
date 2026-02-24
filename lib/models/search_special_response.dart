/// 对应 JSON 中的 "data" 部分
class SearchSpecialResponse {
  final int? total;
  final int? page;
  final int? pageSize;
  final int? from;
  final int? size;
  final List<PlaylistItem>? lists;
  final String? correctionTip;

  SearchSpecialResponse({
    this.total,
    this.page,
    this.pageSize,
    this.from,
    this.size,
    this.lists,
    this.correctionTip,
  });

  factory SearchSpecialResponse.fromJson(Map<String, dynamic> json) {
    return SearchSpecialResponse(
      total: json['total'] as int?,
      page: json['page'] as int?,
      pageSize: json['pagesize'] as int?,
      from: json['from'] as int?,
      size: json['size'] as int?,
      correctionTip: json['correctiontip'] as String?,
      lists: (json['lists'] as List<dynamic>?)
          ?.map((e) => PlaylistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'page': page,
    'pagesize': pageSize,
    'from': from,
    'size': size,
    'correctiontip': correctionTip,
    'lists': lists?.map((e) => e.toJson()).toList(),
  };
}

/// 歌单实体 (对应 lists 中的每一项)
class PlaylistItem {
  // --- 基础信息 ---
  final String? specialName; // 歌单名称
  final int? specialId; // 歌单 ID
  final String? nickname; // 创建者昵称
  final String? intro; // 简介
  final String? img; // 封面图片
  final String? publishTime; // 发布时间

  // --- 统计数据 ---
  final int? songCount; // 歌曲数量
  final int? playCount; // 播放量 (JSON中是字符串，转为int)
  final int? totalPlayCount; // 总播放量 (JSON中是字符串，转为int)
  final int? collectCount; // 收藏量 (JSON中是字符串，转为int)

  // --- 标识/ID ---
  final String? suid; // 创建者 ID (JSON中是字符串)
  final int? isVip; // 是否 VIP
  final int? isUgc; // 是否 UGC (用户生成内容)
  final int? grade; // 评分/等级

  // --- 其他信息 ---
  final String? contain; // 包含的歌曲概览 (如 "黄龄、HOYO-MiX - TruE")
  final Map<String, dynamic>? transParam;

  PlaylistItem({
    this.specialName,
    this.specialId,
    this.nickname,
    this.intro,
    this.img,
    this.publishTime,
    this.songCount,
    this.playCount,
    this.totalPlayCount,
    this.collectCount,
    this.suid,
    this.isVip,
    this.isUgc,
    this.grade,
    this.contain,
    this.transParam,
  });

  factory PlaylistItem.fromJson(Map<String, dynamic> json) {
    return PlaylistItem(
      specialName: json['specialname'] as String?,
      specialId: json['specialid'] as int?,
      nickname: json['nickname'] as String?,
      intro: json['intro'] as String?,
      img: json['img'] as String?,
      publishTime: json['publish_time'] as String?,

      songCount: json['song_count'] as int?,
      // 这里的 play_count 在 JSON 里是字符串 "986"，需要转换
      playCount: int.tryParse(json['play_count']?.toString() ?? ''),
      totalPlayCount: int.tryParse(json['total_play_count']?.toString() ?? ''),
      collectCount: int.tryParse(json['collect_count']?.toString() ?? ''),

      suid: json['suid']?.toString(), // 确保转为 String
      isVip: json['isvip'] as int?,
      isUgc: json['isugc'] as int?,
      // grade 有时候是 int，有时候 grade_int 是字符串，这里取 grade
      grade: json['grade'] as int?,

      contain: json['contain'] as String?,
      transParam: json['trans_param'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'specialname': specialName,
    'specialid': specialId,
    'nickname': nickname,
    'intro': intro,
    'img': img,
    'publish_time': publishTime,
    'song_count': songCount,
    'play_count': playCount?.toString(), // 转回字符串以匹配原始 API 格式
    'total_play_count': totalPlayCount?.toString(),
    'collect_count': collectCount?.toString(),
    'suid': suid,
    'isvip': isVip,
    'isugc': isUgc,
    'grade': grade,
    'contain': contain,
    'trans_param': transParam,
  };

  /// 辅助方法：获取图片 URL
  /// 歌单 API 返回的图片通常已经是固定大小 (如 /150/)，但为了保险可以处理
  /// 如果 URL 中包含 {size} 则替换，否则直接返回
  String getImageUrl({int size = 400}) {
    if (img == null) return "";
    if (img!.contains('{size}')) {
      return img!.replaceAll('{size}', size.toString());
    }
    // 某些 API 返回的是固定尺寸 /150/，如果需要大图，可能需要正则替换，
    // 但通常歌单搜索结果已经是缩略图了。
    return img!;
  }

  /// 辅助方法：格式化播放量 (例如 208436 -> 20.8万)
  String get formattedPlayCount {
    final count = totalPlayCount ?? playCount ?? 0;
    if (count > 10000) {
      return "${(count / 10000).toStringAsFixed(1)}万";
    }
    return count.toString();
  }
}
