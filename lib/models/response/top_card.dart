import 'dart:convert';

class TopCard {
  /// 在线实验 ID 列表 (Online Experiment IDs)
  /// 用于灰度发布或 A/B 测试，记录用户命中了哪些算法实验策略
  final String? olexpIds;

  /// 歌曲列表
  final List<SongItem>? songList;

  /// 列表大小
  final int? songListSize;

  /// 业务标识 (Business Intelligence/Biz)
  /// 例如 "rcmd_sc1" 可能代表 "Recommend Scenario 1" (推荐场景1)
  final String? biBiz;

  /// 推荐描述文案 (如 "私人专属好歌")
  final String? recDesc;

  /// 推荐用户昵称 (通常用于达人推荐，此处为空)
  final String? recUserNickname;

  /// 签名校验串
  final String? sign;

  /// 卡片样式 ID
  final int? cardId;

  const TopCard({
    this.olexpIds,
    this.songList,
    this.songListSize,
    this.biBiz,
    this.recDesc,
    this.recUserNickname,
    this.sign,
    this.cardId,
  });

  factory TopCard.fromMap(Map<String, dynamic> map) {
    return TopCard(
      olexpIds: map['OlexpIds'],
      songList: map['song_list'] != null
          ? List<SongItem>.from(
              (map['song_list'] as List).map((x) => SongItem.fromMap(x)),
            )
          : null,
      songListSize: map['song_list_size'],
      biBiz: map['bi_biz'],
      recDesc: map['rec_desc'],
      recUserNickname: map['rec_user_nickname'],
      sign: map['sign'],
      cardId: map['card_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'OlexpIds': olexpIds,
      'song_list': songList?.map((x) => x.toMap()).toList(),
      'song_list_size': songListSize,
      'bi_biz': biBiz,
      'rec_desc': recDesc,
      'rec_user_nickname': recUserNickname,
      'sign': sign,
      'card_id': cardId,
    };
  }

  String toJson() => json.encode(toMap());
}

/// -----------------------------------------------------------------------------
/// Song_list (SongItem) 类：单曲详情
/// -----------------------------------------------------------------------------
class SongItem {
  /// 无损 FLAC 文件大小
  final int? filesizeFlac;
  final String? officialSongname;
  final String? oriAudioName;
  final String? hash192;

  /// 是否为推荐歌曲 (1: 是)
  final int? isRec;

  /// FLAC 格式 Hash
  final String? hashFlac;
  final String? songname;
  final int? musicTrac;
  final int? isOriginal;

  /// 付费类型 (0:免费, 1:VIP, 3:付费专辑等)
  final int? payType;
  final int? songType;

  /// 专辑 ID (注意：此处为 int，与上一个接口不同)
  final int? albumId;

  final String? remark;
  final String? language;
  final int? isFileHead320;

  /// 算法路径 (Algorithm Path)
  /// 包含召回源(recall)、排序分(rank_predict)、点击率预估(pred_click)等核心算法数据
  final String? algPath;

  final int? isFileHead;

  /// 320k 音质时长 (浮点数，精确到毫秒)
  final double? timelength320;

  /// 场景 ID / 子分类 ID
  final int? scid;
  final String? suffixAudioName;
  final String? mvHash;
  final String? hash;

  /// 标准 Hash
  final String? authorName;
  final List<SongTag>? tags;
  final String? rankLabel;

  /// 榜单标签 (如 "昨日超万人播放")
  final int? bitrate;
  final int? isMvFileHead;
  final int? hasAccompany;
  final int? filesize128;
  final String? hash320;

  /// 流量/广告追踪标记 (Zero Trust / Campaign Mark)
  final String? ztcMark;

  /// 推荐来源类型
  final String? recSourceType;

  /// 上报信息 (Report Info)
  /// 包含了详细的模型预测分数，用于客户端埋点回传，帮助优化推荐模型
  final String? reportInfo;

  final int? filesize192;
  final String? publishDate;
  final int? fileSize;
  final int? hasAlbum;
  final String? extname;
  final String? type;
  final int? level;
  final int? from;
  final String? recLabelPrefix;
  final int? oldCpy;
  final String? hash128;
  final TrackerInfo? trackerInfo;
  final List<IpsTag>? ipsTags;
  final RelateGoods? relateGoods;
  final int? filesizeOther;
  final String? sizableCover;
  final List<SingerInfo>? singerInfo;
  final int? mvType;
  final int? publishTime;
  final int? filesizeApe;
  final int? recLabelType;
  final String? albumName;
  final int? filesize320;
  final TransParam? transParam;
  final String? filename;
  final String? albumAudioRemark;
  final String? albumAudioId;
  final String? hashApe;
  final String? hashOther;

  /// 权限位 (Privilege) - 控制下载、播放等权限
  final int? privilege;

  /// 歌曲总时长 (浮点数)
  final double? timeLength;

  final String? mixsongid;
  final int? failProcess;
  final int? qualityLevel;
  final int? songid;

  const SongItem({
    this.filesizeFlac,
    this.officialSongname,
    this.oriAudioName,
    this.hash192,
    this.isRec,
    this.hashFlac,
    this.songname,
    this.musicTrac,
    this.isOriginal,
    this.payType,
    this.songType,
    this.albumId,
    this.remark,
    this.language,
    this.isFileHead320,
    this.algPath,
    this.isFileHead,
    this.timelength320,
    this.scid,
    this.suffixAudioName,
    this.mvHash,
    this.hash,
    this.authorName,
    this.tags,
    this.rankLabel,
    this.bitrate,
    this.isMvFileHead,
    this.hasAccompany,
    this.filesize128,
    this.hash320,
    this.ztcMark,
    this.recSourceType,
    this.reportInfo,
    this.filesize192,
    this.publishDate,
    this.fileSize,
    this.hasAlbum,
    this.extname,
    this.type,
    this.level,
    this.from,
    this.recLabelPrefix,
    this.oldCpy,
    this.hash128,
    this.trackerInfo,
    this.ipsTags,
    this.relateGoods,
    this.filesizeOther,
    this.sizableCover,
    this.singerInfo,
    this.mvType,
    this.publishTime,
    this.filesizeApe,
    this.recLabelType,
    this.albumName,
    this.filesize320,
    this.transParam,
    this.filename,
    this.albumAudioRemark,
    this.albumAudioId,
    this.hashApe,
    this.hashOther,
    this.privilege,
    this.timeLength,
    this.mixsongid,
    this.failProcess,
    this.qualityLevel,
    this.songid,
  });

  factory SongItem.fromMap(Map<String, dynamic> map) {
    return SongItem(
      filesizeFlac: map['filesize_flac'],
      officialSongname: map['official_songname'],
      oriAudioName: map['ori_audio_name'],
      hash192: map['hash_192'],
      isRec: map['is_rec'],
      hashFlac: map['hash_flac'],
      songname: map['songname'],
      musicTrac: map['music_trac'],
      isOriginal: map['is_original'],
      payType: map['pay_type'],
      songType: map['song_type'],
      albumId: map['album_id'],
      remark: map['remark'],
      language: map['language'],
      isFileHead320: map['is_file_head_320'],
      algPath: map['alg_path'],
      isFileHead: map['is_file_head'],

      /// JSON中是浮点数，需要转换
      timelength320: (map['timelength_320'] as num?)?.toDouble(),
      scid: map['scid'],
      suffixAudioName: map['suffix_audio_name'],
      mvHash: map['mv_hash'],
      hash: map['hash'],
      authorName: map['author_name'],
      tags: map['tags'] != null
          ? List<SongTag>.from(
              (map['tags'] as List).map((x) => SongTag.fromMap(x)),
            )
          : null,
      rankLabel: map['rank_label'],
      bitrate: map['bitrate'],
      isMvFileHead: map['is_mv_file_head'],
      hasAccompany: map['has_accompany'],
      filesize128: map['filesize_128'],
      hash320: map['hash_320'],
      ztcMark: map['ztc_mark'],
      recSourceType: map['rec_source_type'],
      reportInfo: map['report_info'],
      filesize192: map['filesize_192'],
      publishDate: map['publish_date'],
      fileSize: map['file_size'],
      hasAlbum: map['has_album'],
      extname: map['extname'],
      type: map['type'],
      level: map['level'],
      from: map['from'],
      recLabelPrefix: map['rec_label_prefix'],
      oldCpy: map['old_cpy'],
      hash128: map['hash_128'],
      trackerInfo: map['tracker_info'] != null
          ? TrackerInfo.fromMap(map['tracker_info'])
          : null,
      ipsTags: map['ips_tags'] != null
          ? List<IpsTag>.from(
              (map['ips_tags'] as List).map((x) => IpsTag.fromMap(x)),
            )
          : null,
      relateGoods: map['relate_goods'] != null
          ? RelateGoods.fromMap(map['relate_goods'])
          : null,
      filesizeOther: map['filesize_other'],
      sizableCover: map['sizable_cover'],
      singerInfo: map['singerinfo'] != null
          ? List<SingerInfo>.from(
              (map['singerinfo'] as List).map((x) => SingerInfo.fromMap(x)),
            )
          : null,
      mvType: map['mv_type'],
      publishTime: map['publish_time'],
      filesizeApe: map['filesize_ape'],
      recLabelType: map['rec_label_type'],
      albumName: map['album_name'],
      filesize320: map['filesize_320'],
      transParam: map['trans_param'] != null
          ? TransParam.fromMap(map['trans_param'])
          : null,
      filename: map['filename'],
      albumAudioRemark: map['album_audio_remark'],
      albumAudioId: map['album_audio_id'],
      hashApe: map['hash_ape'],
      hashOther: map['hash_other'],
      privilege: map['privilege'],

      /// JSON中是浮点数，需要转换
      timeLength: (map['time_length'] as num?)?.toDouble(),
      mixsongid: map['mixsongid'],
      failProcess: map['fail_process'],
      qualityLevel: map['quality_level'],
      songid: map['songid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'filesize_flac': filesizeFlac,
      'official_songname': officialSongname,
      'ori_audio_name': oriAudioName,
      'hash_192': hash192,
      'is_rec': isRec,
      'hash_flac': hashFlac,
      'songname': songname,
      'music_trac': musicTrac,
      'is_original': isOriginal,
      'pay_type': payType,
      'song_type': songType,
      'album_id': albumId,
      'remark': remark,
      'language': language,
      'is_file_head_320': isFileHead320,
      'alg_path': algPath,
      'is_file_head': isFileHead,
      'timelength_320': timelength320,
      'scid': scid,
      'suffix_audio_name': suffixAudioName,
      'mv_hash': mvHash,
      'hash': hash,
      'author_name': authorName,
      'tags': tags?.map((x) => x.toMap()).toList(),
      'rank_label': rankLabel,
      'bitrate': bitrate,
      'is_mv_file_head': isMvFileHead,
      'has_accompany': hasAccompany,
      'filesize_128': filesize128,
      'hash_320': hash320,
      'ztc_mark': ztcMark,
      'rec_source_type': recSourceType,
      'report_info': reportInfo,
      'filesize_192': filesize192,
      'publish_date': publishDate,
      'file_size': fileSize,
      'has_album': hasAlbum,
      'extname': extname,
      'type': type,
      'level': level,
      'from': from,
      'rec_label_prefix': recLabelPrefix,
      'old_cpy': oldCpy,
      'hash_128': hash128,
      'tracker_info': trackerInfo?.toMap(),
      'ips_tags': ipsTags?.map((x) => x.toMap()).toList(),
      'relate_goods': relateGoods?.toMap(),
      'filesize_other': filesizeOther,
      'sizable_cover': sizableCover,
      'singerinfo': singerInfo?.map((x) => x.toMap()).toList(),
      'mv_type': mvType,
      'publish_time': publishTime,
      'filesize_ape': filesizeApe,
      'rec_label_type': recLabelType,
      'album_name': albumName,
      'filesize_320': filesize320,
      'trans_param': transParam?.toMap(),
      'filename': filename,
      'album_audio_remark': albumAudioRemark,
      'album_audio_id': albumAudioId,
      'hash_ape': hashApe,
      'hash_other': hashOther,
      'privilege': privilege,
      'time_length': timeLength,
      'mixsongid': mixsongid,
      'fail_process': failProcess,
      'quality_level': qualityLevel,
      'songid': songid,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }

  String getSizableCoverUrl({int size = 256}) {
    return sizableCover!.replaceAll('{size}', size.toString());
  }
}

/// -----------------------------------------------------------------------------
/// Tags 类：标签信息
/// -----------------------------------------------------------------------------
class SongTag {
  final int? tagId;
  final int? parentId;
  final String? tagName;

  const SongTag({this.tagId, this.parentId, this.tagName});

  factory SongTag.fromMap(Map<String, dynamic> map) {
    return SongTag(
      tagId: map['tag_id'],
      parentId: map['parent_id'],
      tagName: map['tag_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'tag_id': tagId, 'parent_id': parentId, 'tag_name': tagName};
  }
}

/// -----------------------------------------------------------------------------
/// TrackerInfo 类：追踪/鉴权信息
/// -----------------------------------------------------------------------------
class TrackerInfo {
  final String? auth;
  final int? moduleId;
  final String? openTime;

  const TrackerInfo({this.auth, this.moduleId, this.openTime});

  factory TrackerInfo.fromMap(Map<String, dynamic> map) {
    return TrackerInfo(
      auth: map['auth'],
      moduleId: map['module_id'],
      openTime: map['open_time'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'auth': auth, 'module_id': moduleId, 'open_time': openTime};
  }
}

/// -----------------------------------------------------------------------------
/// IpsTag 类：热度/状态标签
/// -----------------------------------------------------------------------------
class IpsTag {
  final String? name;
  final String? ipId;
  final String? pid;

  const IpsTag({this.name, this.ipId, this.pid});

  factory IpsTag.fromMap(Map<String, dynamic> map) {
    return IpsTag(name: map['name'], ipId: map['ip_id'], pid: map['pid']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'ip_id': ipId, 'pid': pid};
  }
}

/// -----------------------------------------------------------------------------
/// RelateGoods 类：关联商品 (空对象)
/// -----------------------------------------------------------------------------
class RelateGoods {
  const RelateGoods();

  factory RelateGoods.fromMap(Map<String, dynamic> map) {
    return const RelateGoods();
  }

  Map<String, dynamic> toMap() => {};
}

/// -----------------------------------------------------------------------------
/// SingerInfo 类：歌手信息
/// -----------------------------------------------------------------------------
class SingerInfo {
  final String? name;
  final int? isPublish;

  /// 歌手 ID (注意：此处为 int，与上一个接口可能不同)
  final int? id;

  const SingerInfo({this.name, this.isPublish, this.id});

  factory SingerInfo.fromMap(Map<String, dynamic> map) {
    return SingerInfo(
      name: map['name'],
      isPublish: map['is_publish'],
      id: map['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'is_publish': isPublish, 'id': id};
  }
}

/// -----------------------------------------------------------------------------
/// TransParam 类：传输/版权参数
/// -----------------------------------------------------------------------------
class TransParam {
  /// 付费块模板 ID (Payment Block Template)
  final int? payBlockTpl;
  final ClassMap? classmap;
  final String? language;

  /// 版权属性位 0 (Copyright Attribute)
  final int? cpyAttr0;
  final int? musicpackAdvance;
  final int? ogg128Filesize;
  final int? displayRate;
  final int? ogg320Filesize;
  final QualityMap? qualitymap;
  final String? ogg128Hash;
  final IpMap? ipmap;
  final int? cid;
  final String? songnameSuffix;
  final int? display;
  final String? ogg320Hash;
  final String? hashMultitrack;

  /// 版权等级 (Copyright Grade)
  final int? cpyGrade;
  final String? unionCover;

  /// 版权级别
  final int? cpyLevel;

  const TransParam({
    this.payBlockTpl,
    this.classmap,
    this.language,
    this.cpyAttr0,
    this.musicpackAdvance,
    this.ogg128Filesize,
    this.displayRate,
    this.ogg320Filesize,
    this.qualitymap,
    this.ogg128Hash,
    this.ipmap,
    this.cid,
    this.songnameSuffix,
    this.display,
    this.ogg320Hash,
    this.hashMultitrack,
    this.cpyGrade,
    this.unionCover,
    this.cpyLevel,
  });

  factory TransParam.fromMap(Map<String, dynamic> map) {
    return TransParam(
      payBlockTpl: map['pay_block_tpl'],
      classmap: map['classmap'] != null
          ? ClassMap.fromMap(map['classmap'])
          : null,
      language: map['language'],
      cpyAttr0: map['cpy_attr0'],
      musicpackAdvance: map['musicpack_advance'],
      ogg128Filesize: map['ogg_128_filesize'],
      displayRate: map['display_rate'],
      ogg320Filesize: map['ogg_320_filesize'],
      qualitymap: map['qualitymap'] != null
          ? QualityMap.fromMap(map['qualitymap'])
          : null,
      ogg128Hash: map['ogg_128_hash'],
      ipmap: map['ipmap'] != null ? IpMap.fromMap(map['ipmap']) : null,
      cid: map['cid'],
      songnameSuffix: map['songname_suffix'],
      display: map['display'],
      ogg320Hash: map['ogg_320_hash'],
      hashMultitrack: map['hash_multitrack'],
      cpyGrade: map['cpy_grade'],
      unionCover: map['union_cover'],
      cpyLevel: map['cpy_level'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pay_block_tpl': payBlockTpl,
      'classmap': classmap?.toMap(),
      'language': language,
      'cpy_attr0': cpyAttr0,
      'musicpack_advance': musicpackAdvance,
      'ogg_128_filesize': ogg128Filesize,
      'display_rate': displayRate,
      'ogg_320_filesize': ogg320Filesize,
      'qualitymap': qualitymap?.toMap(),
      'ogg_128_hash': ogg128Hash,
      'ipmap': ipmap?.toMap(),
      'cid': cid,
      'songname_suffix': songnameSuffix,
      'display': display,
      'ogg_320_hash': ogg320Hash,
      'hash_multitrack': hashMultitrack,
      'cpy_grade': cpyGrade,
      'union_cover': unionCover,
      'cpy_level': cpyLevel,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }

  String getUnionCoverUrl({int size = 256}) {
    return unionCover!.replaceAll('{size}', size.toString());
  }
}

/// -----------------------------------------------------------------------------
/// 辅助映射类 (ClassMap, QualityMap, IpMap)
/// -----------------------------------------------------------------------------
class ClassMap {
  final int? attr0;

  const ClassMap({this.attr0});

  factory ClassMap.fromMap(Map<String, dynamic> map) {
    return ClassMap(attr0: map['attr0']);
  }

  Map<String, dynamic> toMap() => {'attr0': attr0};
}

class QualityMap {
  /// 音质位域字符串 (如 "1b40180007f3fc075")
  final String? bits;
  final int? attr0;
  final int? attr1;

  const QualityMap({this.bits, this.attr0, this.attr1});

  factory QualityMap.fromMap(Map<String, dynamic> map) {
    return QualityMap(
      bits: map['bits'],
      attr0: map['attr0'],
      attr1: map['attr1'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'bits': bits, 'attr0': attr0, 'attr1': attr1};
  }
}

class IpMap {
  final int? attr0;

  const IpMap({this.attr0});

  factory IpMap.fromMap(Map<String, dynamic> map) {
    return IpMap(attr0: map['attr0']);
  }

  Map<String, dynamic> toMap() => {'attr0': attr0};
}
