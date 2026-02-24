class SongUrlResponse {
  // --- 基础状态/权限控制 ---
  final int? status;
  final int? privStatus;
  final List<String>? failProcess;
  final List<String>? authThrough;

  // --- 播放链接信息 (成功时返回) ---
  final List<String>? url;
  final List<String>? backupUrl;

  // --- 文件详细信息 (成功时返回) ---
  final String? fileName;
  final String? extName;
  final int? fileSize;
  final int? timeLength;
  final int? bitRate;
  final String? hash;
  final String? stdHash;
  final int? stdHashTime;

  // --- 音频属性 (成功时返回) ---
  final num? volume;
  final num? volumePeak;
  final num? volumeGain;
  final int? fileHead;
  final int? q;

  // --- 嵌套的详细参数 ---
  final Map<String, dynamic>? classMap;
  final TransParam? transParam;
  final TrackerThrough? trackerThrough;

  SongUrlResponse({
    this.status,
    this.privStatus,
    this.failProcess,
    this.authThrough,
    this.url,
    this.backupUrl,
    this.fileName,
    this.extName,
    this.fileSize,
    this.timeLength,
    this.bitRate,
    this.hash,
    this.stdHash,
    this.stdHashTime,
    this.volume,
    this.volumePeak,
    this.volumeGain,
    this.fileHead,
    this.q,
    this.classMap,
    this.transParam,
    this.trackerThrough,
  });

  factory SongUrlResponse.fromJson(Map<String, dynamic> json) {
    return SongUrlResponse(
      status: json['status'] as int?,
      privStatus: json['priv_status'] as int?,
      failProcess: (json['fail_process'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      authThrough: (json['auth_through'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),

      url: (json['url'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      backupUrl: (json['backupUrl'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),

      fileName: json['fileName'] as String?,
      extName: json['extName'] as String?,
      fileSize: json['fileSize'] as int?,
      timeLength: json['timeLength'] as int?,
      bitRate: json['bitRate'] as int?,
      hash: json['hash'] as String?,
      stdHash: json['std_hash'] as String?,
      stdHashTime: json['std_hash_time'] as int?,

      // volume 可能是 int 也可能是 double，使用 num 解析
      volume: json['volume'] as num?,
      volumePeak: json['volume_peak'] as num?,
      volumeGain: json['volume_gain'] as num?,
      fileHead: json['fileHead'] as int?,
      q: json['q'] as int?,

      classMap: json['classmap'] as Map<String, dynamic>?,
      transParam: json['trans_param'] != null
          ? TransParam.fromJson(json['trans_param'])
          : null,
      trackerThrough: json['tracker_through'] != null
          ? TrackerThrough.fromJson(json['tracker_through'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'priv_status': privStatus,
    'fail_process': failProcess,
    'auth_through': authThrough,
    'url': url,
    'backupUrl': backupUrl,
    'fileName': fileName,
    'extName': extName,
    'fileSize': fileSize,
    'timeLength': timeLength,
    'bitRate': bitRate,
    'hash': hash,
    'std_hash': stdHash,
    'std_hash_time': stdHashTime,
    'volume': volume,
    'volume_peak': volumePeak,
    'volume_gain': volumeGain,
    'fileHead': fileHead,
    'q': q,
    'classmap': classMap,
    'trans_param': transParam?.toJson(),
    'tracker_through': trackerThrough?.toJson(),
  };

  /// 辅助方法：判断是否需要购买/开通 VIP 才能播放
  bool get requiresVipOrPurchase {
    if (failProcess == null || failProcess!.isEmpty) return false;
    return failProcess!.contains('pkg') || failProcess!.contains('buy');
  }

  /// 辅助方法：获取可用的播放链接
  /// 优先返回 url 列表中的第一个，如果没有则返回 backupUrl 的第一个
  String? get playUrl {
    if (url != null && url!.isNotEmpty) return url!.first;
    if (backupUrl != null && backupUrl!.isNotEmpty) return backupUrl!.first;
    return null;
  }
}

/// 传输参数 (包含备用播放音质 hash 和封面等信息)
class TransParam {
  final int? displayRate;
  final int? display;
  final String? ogg128Hash;
  final int? ogg128Filesize;
  final String? ogg320Hash;
  final int? ogg320Filesize;
  final String? unionCover;
  final String? language;
  final String? hashMultitrack;
  final Map<String, dynamic>? qualityMap;
  final int? cpyAttr0;
  final Map<String, dynamic>? ipMap;
  final Map<String, dynamic>? classMap;
  final int? payBlockTpl;

  TransParam({
    this.displayRate,
    this.display,
    this.ogg128Hash,
    this.ogg128Filesize,
    this.ogg320Hash,
    this.ogg320Filesize,
    this.unionCover,
    this.language,
    this.hashMultitrack,
    this.qualityMap,
    this.cpyAttr0,
    this.ipMap,
    this.classMap,
    this.payBlockTpl,
  });

  factory TransParam.fromJson(Map<String, dynamic> json) {
    return TransParam(
      displayRate: json['display_rate'] as int?,
      display: json['display'] as int?,
      ogg128Hash: json['ogg_128_hash'] as String?,
      ogg128Filesize: json['ogg_128_filesize'] as int?,
      ogg320Hash: json['ogg_320_hash'] as String?,
      ogg320Filesize: json['ogg_320_filesize'] as int?,
      unionCover: json['union_cover'] as String?,
      language: json['language'] as String?,
      hashMultitrack: json['hash_multitrack'] as String?,
      qualityMap: json['qualitymap'] as Map<String, dynamic>?,
      cpyAttr0: json['cpy_attr0'] as int?,
      ipMap: json['ipmap'] as Map<String, dynamic>?,
      classMap: json['classmap'] as Map<String, dynamic>?,
      payBlockTpl: json['pay_block_tpl'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'display_rate': displayRate,
    'display': display,
    'ogg_128_hash': ogg128Hash,
    'ogg_128_filesize': ogg128Filesize,
    'ogg_320_hash': ogg320Hash,
    'ogg_320_filesize': ogg320Filesize,
    'union_cover': unionCover,
    'language': language,
    'hash_multitrack': hashMultitrack,
    'qualitymap': qualityMap,
    'cpy_attr0': cpyAttr0,
    'ipmap': ipMap,
    'classmap': classMap,
    'pay_block_tpl': payBlockTpl,
  };

  /// 辅助方法：获取封面 URL，自动替换 {size}
  String getCoverUrl({int size = 400}) {
    if (unionCover == null || unionCover!.isEmpty) return "";
    return unionCover!.replaceAll('{size}', size.toString());
  }
}

/// 追踪/版权信息
class TrackerThrough {
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

  factory TrackerThrough.fromJson(Map<String, dynamic> json) {
    return TrackerThrough(
      identityBlock: json['identity_block'] as int?,
      cpyGrade: json['cpy_grade'] as int?,
      musicpackAdvance: json['musicpack_advance'] as int?,
      allQualityFree: json['all_quality_free'] as int?,
      cpyLevel: json['cpy_level'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'identity_block': identityBlock,
    'cpy_grade': cpyGrade,
    'musicpack_advance': musicpackAdvance,
    'all_quality_free': allQualityFree,
    'cpy_level': cpyLevel,
  };
}
