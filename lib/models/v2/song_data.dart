import 'dart:convert';

class Classmap {
  final int? attr0;

  Classmap({this.attr0});

  factory Classmap.fromMap(Map<String, dynamic> map) {
    return Classmap(attr0: map['attr0'] as int?);
  }

  Map<String, dynamic> toMap() {
    return {'attr0': attr0};
  }

  factory Classmap.fromJson(String source) =>
      Classmap.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 追踪透传参数模型
class TrackerThrough {
  /// 身份限制标识
  final int? identityBlock;
  final int? cpyGrade;
  final int? musicpackAdvance;
  final int? allQualityFree;
  final int? cpyLevel;

  TrackerThrough({
    this.identityBlock,
    this.cpyGrade,
    this.musicpackAdvance,
    this.allQualityFree,
    this.cpyLevel,
  });

  factory TrackerThrough.fromMap(Map<String, dynamic> map) {
    return TrackerThrough(
      identityBlock: map['identity_block'] as int?,
      cpyGrade: map['cpy_grade'] as int?,
      musicpackAdvance: map['musicpack_advance'] as int?,
      allQualityFree: map['all_quality_free'] as int?,
      cpyLevel: map['cpy_level'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'identity_block': identityBlock,
      'cpy_grade': cpyGrade,
      'musicpack_advance': musicpackAdvance,
      'all_quality_free': allQualityFree,
      'cpy_level': cpyLevel,
    };
  }

  factory TrackerThrough.fromJson(String source) =>
      TrackerThrough.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 音质映射模型（qualitymap）
class Qualitymap {
  final String? bits;
  final int? attr0;
  final int? attr1;

  Qualitymap({this.bits, this.attr0, this.attr1});

  factory Qualitymap.fromMap(Map<String, dynamic> map) {
    return Qualitymap(
      bits: map['bits'] as String?,
      attr0: map['attr0'] as int?,
      attr1: map['attr1'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'bits': bits, 'attr0': attr0, 'attr1': attr1};
  }

  factory Qualitymap.fromJson(String source) =>
      Qualitymap.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// IP映射模型
class Ipmap {
  final int? attr0;

  Ipmap({this.attr0});

  factory Ipmap.fromMap(Map<String, dynamic> map) {
    return Ipmap(attr0: map['attr0'] as int?);
  }

  Map<String, dynamic> toMap() {
    return {'attr0': attr0};
  }

  factory Ipmap.fromJson(String source) => Ipmap.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 透传参数模型
class TransParam {
  /// 展示参数
  final int? displayRate;

  /// 展示参数
  final int? display;

  /// OGG 格式不同码率的哈希值
  final String? ogg128Hash;

  /// 音质映射表
  final Qualitymap? qualitymap;

  /// 付费模块模板
  final int? payBlockTpl;

  /// 歌曲封面 URL（{size})
  final String? unionCover;

  /// 歌曲语言
  final String? language;

  /// 多轨音频哈希值
  final String? hashMultitrack;

  /// 版权属性标识
  final int? cpyAttr0;

  /// IP 地域限制标识
  final Ipmap? ipmap;

  /// OGG 格式不同码率的哈希值
  final String? ogg320Hash;
  final Classmap? classmap;

  /// OGG 格式对应码率的文件大小
  final int? ogg128Filesize;

  /// OGG 格式对应码率的文件大小
  final int? ogg320Filesize;

  TransParam({
    this.displayRate,
    this.display,
    this.ogg128Hash,
    this.qualitymap,
    this.payBlockTpl,
    this.unionCover,
    this.language,
    this.hashMultitrack,
    this.cpyAttr0,
    this.ipmap,
    this.ogg320Hash,
    this.classmap,
    this.ogg128Filesize,
    this.ogg320Filesize,
  });

  factory TransParam.fromMap(Map<String, dynamic> map) {
    return TransParam(
      displayRate: map['display_rate'] as int?,
      display: map['display'] as int?,
      ogg128Hash: map['ogg_128_hash'] as String?,
      qualitymap: map['qualitymap'] != null
          ? Qualitymap.fromMap(map['qualitymap'] as Map<String, dynamic>)
          : null,
      payBlockTpl: map['pay_block_tpl'] as int?,
      unionCover: map['union_cover'] as String?,
      language: map['language'] as String?,
      hashMultitrack: map['hash_multitrack'] as String?,
      cpyAttr0: map['cpy_attr0'] as int?,
      ipmap: map['ipmap'] != null
          ? Ipmap.fromMap(map['ipmap'] as Map<String, dynamic>)
          : null,
      ogg320Hash: map['ogg_320_hash'] as String?,
      classmap: map['classmap'] != null
          ? Classmap.fromMap(map['classmap'] as Map<String, dynamic>)
          : null,
      ogg128Filesize: map['ogg_128_filesize'] as int?,
      ogg320Filesize: map['ogg_320_filesize'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'display_rate': displayRate,
      'display': display,
      'ogg_128_hash': ogg128Hash,
      'qualitymap': qualitymap?.toMap(),
      'pay_block_tpl': payBlockTpl,
      'union_cover': unionCover,
      'language': language,
      'hash_multitrack': hashMultitrack,
      'cpy_attr0': cpyAttr0,
      'ipmap': ipmap?.toMap(),
      'ogg_320_hash': ogg320Hash,
      'classmap': classmap?.toMap(),
      'ogg_128_filesize': ogg128Filesize,
      'ogg_320_filesize': ogg320Filesize,
    };
  }

  factory TransParam.fromJson(String source) =>
      TransParam.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());

  String getUnionCover({int size = 256}) {
    return unionCover!.replaceAll('{size}', size.toString());
  }
}

/// 顶层音乐播放数据模型
class SongData {
  /// 音频文件扩展名（mp3）
  final String? extName;
  final Classmap? classmap;

  /// 播放状态(1:可播放)
  final int? status;

  /// 音频平均音量
  final double? volume;

  /// 哈希值对应的时间戳
  final int? stdHashTime;

  /// 备用播放地址数组
  final List<String>? backupUrl;

  /// 主播放地址数组
  final List<String>? url;

  /// 歌曲唯一标识
  final String? stdHash;
  final TrackerThrough? trackerThrough;
  final TransParam? transParam;

  /// 音频文件头长度
  final int? fileHead;

  /// 授权渠道数组
  final List<dynamic>? authThrough;

  /// 歌曲时长（秒）
  final int? timeLength;

  /// 音频码率
  final int? bitRate;

  /// 版权状态：1 = 有版权，0 = 无版权
  final int? privStatus;

  /// 音量峰值
  final double? volumePeak;

  /// 音量增益
  final int? volumeGain;

  /// 音质等级标识
  final int? q;

  /// 歌曲名称
  final String? fileName;

  /// 音频文件大小（字节）
  final int? fileSize;

  /// 歌曲唯一标识
  final String? hash;

  SongData({
    this.extName,
    this.classmap,
    this.status,
    this.volume,
    this.stdHashTime,
    this.backupUrl,
    this.url,
    this.stdHash,
    this.trackerThrough,
    this.transParam,
    this.fileHead,
    this.authThrough,
    this.timeLength,
    this.bitRate,
    this.privStatus,
    this.volumePeak,
    this.volumeGain,
    this.q,
    this.fileName,
    this.fileSize,
    this.hash,
  });

  factory SongData.fromMap(Map<String, dynamic> map) {
    return SongData(
      extName: map['extName'] as String?,
      classmap: map['classmap'] != null
          ? Classmap.fromMap(map['classmap'] as Map<String, dynamic>)
          : null,
      status: map['status'] as int?,
      volume: map['volume'] as double?,
      stdHashTime: map['std_hash_time'] as int?,
      backupUrl: map['backupUrl'] != null
          ? List<String>.from(map['backupUrl'] as List)
          : null,
      url: map['url'] != null ? List<String>.from(map['url'] as List) : null,
      stdHash: map['std_hash'] as String?,
      trackerThrough: map['tracker_through'] != null
          ? TrackerThrough.fromMap(
              map['tracker_through'] as Map<String, dynamic>,
            )
          : null,
      transParam: map['trans_param'] != null
          ? TransParam.fromMap(map['trans_param'] as Map<String, dynamic>)
          : null,
      fileHead: map['fileHead'] as int?,
      authThrough: map['auth_through'] as List<dynamic>?,
      timeLength: map['timeLength'] as int?,
      bitRate: map['bitRate'] as int?,
      privStatus: map['priv_status'] as int?,
      volumePeak: map['volume_peak'] as double?,
      volumeGain: map['volume_gain'] as int?,
      q: map['q'] as int?,
      fileName: map['fileName'] as String?,
      fileSize: map['fileSize'] as int?,
      hash: map['hash'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'extName': extName,
      'classmap': classmap?.toMap(),
      'status': status,
      'volume': volume,
      'std_hash_time': stdHashTime,
      'backupUrl': backupUrl,
      'url': url,
      'std_hash': stdHash,
      'tracker_through': trackerThrough?.toMap(),
      'trans_param': transParam?.toMap(),
      'fileHead': fileHead,
      'auth_through': authThrough,
      'timeLength': timeLength,
      'bitRate': bitRate,
      'priv_status': privStatus,
      'volume_peak': volumePeak,
      'volume_gain': volumeGain,
      'q': q,
      'fileName': fileName,
      'fileSize': fileSize,
      'hash': hash,
    };
  }

  /// 直接解析完整JSON字符串
  factory SongData.fromJson(String source) =>
      SongData.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}
