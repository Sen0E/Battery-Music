// To parse this JSON data, do
//
//     final topSong = topSongFromJson(jsonString);

import 'dart:convert';

List<TopSong> topSongFromJson(String str) =>
    List<TopSong>.from(json.decode(str).map((x) => TopSong.fromJson(x)));

String topSongToJson(List<TopSong> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopSong {
  List<Author> authors;
  int oldHideFlac;
  int topSongStatus;
  int status128;
  int filesize320;
  int rpId;
  String extern;
  int oldCpyHigh;
  String cdUrl;
  int failProcess;
  int payType;
  RpType rpType;
  String topicUrlFlac;
  int privilegeHigh;
  String parentId;
  int oldCpy320;
  int pkgPrice320;
  String topicRemark;
  int payTypeHigh;
  int privilege128;
  int price320;
  int failProcess128;
  int failProcess320;
  String rankId;
  String zone;
  int cid;
  int videoId;
  String buyCount;
  String hash;
  RpType rpType320;
  int price128;
  RpType rpTypeFlac;
  int timelengthHigh;
  String albumName;
  String topicUrl128;
  String issue;
  DateTime publishDate;
  int adId;
  int timelengthSuper;
  int oldHideSuper;
  int statusSuper;
  int oldHide128;
  int pkgPriceSuper;
  int priceHigh;
  int timelength128;
  int priceSuper;
  int maxSort;
  int exclusive;
  String albumAudioRemark;
  String hashSuper;
  int timelength;
  int privilegeSuper;
  int lastSort;
  RpType rpType128;
  int filesizeFlac;
  int rankCount;
  String songname;
  int oldHide;
  int payType128;
  int showAuthorName;
  String videoHash;
  String recommendReason;
  int rankCid;
  int videoFilesize;
  int status320;
  int payTypeSuper;
  int oldHide320;
  int offset;
  String filename;
  int status;
  RpType rpTypeHigh;
  int timelengthFlac;
  String topicUrl;
  int rpPublish;
  int oldCpySuper;
  int audioId;
  String remark;
  Musical musical;
  int pkgPriceHigh;
  int filesize128;
  int albumId;
  String hash320;
  int pkgPriceFlac;
  int hasObbligato;
  String topicUrl320;
  int failProcessHigh;
  int filesizeHigh;
  int filesize;
  String extnameSuper;
  int statusHigh;
  int videoTrack;
  int bitrateHigh;
  int bitrateSuper;
  String hashHigh;
  int priceFlac;
  String authorName;
  int sort;
  int timelength320;
  String albumSizableCover;
  Extname extname;
  String topicUrlHigh;
  int statusFlac;
  int privilegeFlac;
  int oldCpy;
  List<Remark> remarks;
  int oldCpy128;
  String topicUrlSuper;
  int videoTimelength;
  int filesizeSuper;
  int level;
  int privilege320;
  int pkgPrice128;
  int price;
  int payTypeFlac;
  String rpTypeSuper;
  int payType320;
  int bitrate;
  TransParam transParam;
  String hashFlac;
  String hash128;
  int failProcessSuper;
  int failProcessFlac;
  int oldCpyFlac;
  int oldHideHigh;
  int albumAudioId;
  int privilege;
  int pkgPrice;
  int bitrateFlac;
  DateTime addtime;

  TopSong({
    required this.authors,
    required this.oldHideFlac,
    required this.topSongStatus,
    required this.status128,
    required this.filesize320,
    required this.rpId,
    required this.extern,
    required this.oldCpyHigh,
    required this.cdUrl,
    required this.failProcess,
    required this.payType,
    required this.rpType,
    required this.topicUrlFlac,
    required this.privilegeHigh,
    required this.parentId,
    required this.oldCpy320,
    required this.pkgPrice320,
    required this.topicRemark,
    required this.payTypeHigh,
    required this.privilege128,
    required this.price320,
    required this.failProcess128,
    required this.failProcess320,
    required this.rankId,
    required this.zone,
    required this.cid,
    required this.videoId,
    required this.buyCount,
    required this.hash,
    required this.rpType320,
    required this.price128,
    required this.rpTypeFlac,
    required this.timelengthHigh,
    required this.albumName,
    required this.topicUrl128,
    required this.issue,
    required this.publishDate,
    required this.adId,
    required this.timelengthSuper,
    required this.oldHideSuper,
    required this.statusSuper,
    required this.oldHide128,
    required this.pkgPriceSuper,
    required this.priceHigh,
    required this.timelength128,
    required this.priceSuper,
    required this.maxSort,
    required this.exclusive,
    required this.albumAudioRemark,
    required this.hashSuper,
    required this.timelength,
    required this.privilegeSuper,
    required this.lastSort,
    required this.rpType128,
    required this.filesizeFlac,
    required this.rankCount,
    required this.songname,
    required this.oldHide,
    required this.payType128,
    required this.showAuthorName,
    required this.videoHash,
    required this.recommendReason,
    required this.rankCid,
    required this.videoFilesize,
    required this.status320,
    required this.payTypeSuper,
    required this.oldHide320,
    required this.offset,
    required this.filename,
    required this.status,
    required this.rpTypeHigh,
    required this.timelengthFlac,
    required this.topicUrl,
    required this.rpPublish,
    required this.oldCpySuper,
    required this.audioId,
    required this.remark,
    required this.musical,
    required this.pkgPriceHigh,
    required this.filesize128,
    required this.albumId,
    required this.hash320,
    required this.pkgPriceFlac,
    required this.hasObbligato,
    required this.topicUrl320,
    required this.failProcessHigh,
    required this.filesizeHigh,
    required this.filesize,
    required this.extnameSuper,
    required this.statusHigh,
    required this.videoTrack,
    required this.bitrateHigh,
    required this.bitrateSuper,
    required this.hashHigh,
    required this.priceFlac,
    required this.authorName,
    required this.sort,
    required this.timelength320,
    required this.albumSizableCover,
    required this.extname,
    required this.topicUrlHigh,
    required this.statusFlac,
    required this.privilegeFlac,
    required this.oldCpy,
    required this.remarks,
    required this.oldCpy128,
    required this.topicUrlSuper,
    required this.videoTimelength,
    required this.filesizeSuper,
    required this.level,
    required this.privilege320,
    required this.pkgPrice128,
    required this.price,
    required this.payTypeFlac,
    required this.rpTypeSuper,
    required this.payType320,
    required this.bitrate,
    required this.transParam,
    required this.hashFlac,
    required this.hash128,
    required this.failProcessSuper,
    required this.failProcessFlac,
    required this.oldCpyFlac,
    required this.oldHideHigh,
    required this.albumAudioId,
    required this.privilege,
    required this.pkgPrice,
    required this.bitrateFlac,
    required this.addtime,
  });

  factory TopSong.fromJson(Map<String, dynamic> json) => TopSong(
    authors: List<Author>.from(json["authors"].map((x) => Author.fromJson(x))),
    oldHideFlac: json["old_hide_flac"],
    topSongStatus: json["status"],
    status128: json["status_128"],
    filesize320: json["filesize_320"],
    rpId: json["rp_id"],
    extern: json["extern"],
    oldCpyHigh: json["old_cpy_high"],
    cdUrl: json["cd_url"],
    failProcess: json["fail_process"],
    payType: json["pay_type"],
    rpType: rpTypeValues.map[json["rp_type"]]!,
    topicUrlFlac: json["topic_url_flac"],
    privilegeHigh: json["privilege_high"],
    parentId: json["parent_id"],
    oldCpy320: json["old_cpy_320"],
    pkgPrice320: json["pkg_price_320"],
    topicRemark: json["topic_remark"],
    payTypeHigh: json["pay_type_high"],
    privilege128: json["privilege_128"],
    price320: json["price_320"],
    failProcess128: json["fail_process_128"],
    failProcess320: json["fail_process_320"],
    rankId: json["rank_id"],
    zone: json["zone"],
    cid: json["cid"],
    videoId: json["video_id"],
    buyCount: json["buy_count"],
    hash: json["hash"],
    rpType320: rpTypeValues.map[json["rp_type_320"]]!,
    price128: json["price_128"],
    rpTypeFlac: rpTypeValues.map[json["rp_type_flac"]]!,
    timelengthHigh: json["timelength_high"],
    albumName: json["album_name"],
    topicUrl128: json["topic_url_128"],
    issue: json["issue"],
    publishDate: DateTime.parse(json["publish_date"]),
    adId: json["ad_id"],
    timelengthSuper: json["timelength_super"],
    oldHideSuper: json["old_hide_super"],
    statusSuper: json["status_super"],
    oldHide128: json["old_hide_128"],
    pkgPriceSuper: json["pkg_price_super"],
    priceHigh: json["price_high"],
    timelength128: json["timelength_128"],
    priceSuper: json["price_super"],
    maxSort: json["max_sort"],
    exclusive: json["exclusive"],
    albumAudioRemark: json["album_audio_remark"],
    hashSuper: json["hash_super"],
    timelength: json["timelength"],
    privilegeSuper: json["privilege_super"],
    lastSort: json["last_sort"],
    rpType128: rpTypeValues.map[json["rp_type_128"]]!,
    filesizeFlac: json["filesize_flac"],
    rankCount: json["rank_count"],
    songname: json["songname"],
    oldHide: json["old_hide"],
    payType128: json["pay_type_128"],
    showAuthorName: json["show_author_name"],
    videoHash: json["video_hash"],
    recommendReason: json["recommend_reason"],
    rankCid: json["rank_cid"],
    videoFilesize: json["video_filesize"],
    status320: json["status_320"],
    payTypeSuper: json["pay_type_super"],
    oldHide320: json["old_hide_320"],
    offset: json["offset"],
    filename: json["filename"],
    status: json["__status"],
    rpTypeHigh: rpTypeValues.map[json["rp_type_high"]]!,
    timelengthFlac: json["timelength_flac"],
    topicUrl: json["topic_url"],
    rpPublish: json["rp_publish"],
    oldCpySuper: json["old_cpy_super"],
    audioId: json["audio_id"],
    remark: json["remark"],
    musical: Musical.fromJson(json["musical"]),
    pkgPriceHigh: json["pkg_price_high"],
    filesize128: json["filesize_128"],
    albumId: json["album_id"],
    hash320: json["hash_320"],
    pkgPriceFlac: json["pkg_price_flac"],
    hasObbligato: json["has_obbligato"],
    topicUrl320: json["topic_url_320"],
    failProcessHigh: json["fail_process_high"],
    filesizeHigh: json["filesize_high"],
    filesize: json["filesize"],
    extnameSuper: json["extname_super"],
    statusHigh: json["status_high"],
    videoTrack: json["video_track"],
    bitrateHigh: json["bitrate_high"],
    bitrateSuper: json["bitrate_super"],
    hashHigh: json["hash_high"],
    priceFlac: json["price_flac"],
    authorName: json["author_name"],
    sort: json["sort"],
    timelength320: json["timelength_320"],
    albumSizableCover: json["album_sizable_cover"],
    extname: extnameValues.map[json["extname"]]!,
    topicUrlHigh: json["topic_url_high"],
    statusFlac: json["status_flac"],
    privilegeFlac: json["privilege_flac"],
    oldCpy: json["old_cpy"],
    remarks: List<Remark>.from(json["remarks"].map((x) => Remark.fromJson(x))),
    oldCpy128: json["old_cpy_128"],
    topicUrlSuper: json["topic_url_super"],
    videoTimelength: json["video_timelength"],
    filesizeSuper: json["filesize_super"],
    level: json["level"],
    privilege320: json["privilege_320"],
    pkgPrice128: json["pkg_price_128"],
    price: json["price"],
    payTypeFlac: json["pay_type_flac"],
    rpTypeSuper: json["rp_type_super"],
    payType320: json["pay_type_320"],
    bitrate: json["bitrate"],
    transParam: TransParam.fromJson(json["trans_param"]),
    hashFlac: json["hash_flac"],
    hash128: json["hash_128"],
    failProcessSuper: json["fail_process_super"],
    failProcessFlac: json["fail_process_flac"],
    oldCpyFlac: json["old_cpy_flac"],
    oldHideHigh: json["old_hide_high"],
    albumAudioId: json["album_audio_id"],
    privilege: json["privilege"],
    pkgPrice: json["pkg_price"],
    bitrateFlac: json["bitrate_flac"],
    addtime: DateTime.parse(json["addtime"]),
  );

  Map<String, dynamic> toJson() => {
    "authors": List<dynamic>.from(authors.map((x) => x.toJson())),
    "old_hide_flac": oldHideFlac,
    "status": topSongStatus,
    "status_128": status128,
    "filesize_320": filesize320,
    "rp_id": rpId,
    "extern": extern,
    "old_cpy_high": oldCpyHigh,
    "cd_url": cdUrl,
    "fail_process": failProcess,
    "pay_type": payType,
    "rp_type": rpTypeValues.reverse[rpType],
    "topic_url_flac": topicUrlFlac,
    "privilege_high": privilegeHigh,
    "parent_id": parentId,
    "old_cpy_320": oldCpy320,
    "pkg_price_320": pkgPrice320,
    "topic_remark": topicRemark,
    "pay_type_high": payTypeHigh,
    "privilege_128": privilege128,
    "price_320": price320,
    "fail_process_128": failProcess128,
    "fail_process_320": failProcess320,
    "rank_id": rankId,
    "zone": zone,
    "cid": cid,
    "video_id": videoId,
    "buy_count": buyCount,
    "hash": hash,
    "rp_type_320": rpTypeValues.reverse[rpType320],
    "price_128": price128,
    "rp_type_flac": rpTypeValues.reverse[rpTypeFlac],
    "timelength_high": timelengthHigh,
    "album_name": albumName,
    "topic_url_128": topicUrl128,
    "issue": issue,
    "publish_date":
        "${publishDate.year.toString().padLeft(4, '0')}-${publishDate.month.toString().padLeft(2, '0')}-${publishDate.day.toString().padLeft(2, '0')}",
    "ad_id": adId,
    "timelength_super": timelengthSuper,
    "old_hide_super": oldHideSuper,
    "status_super": statusSuper,
    "old_hide_128": oldHide128,
    "pkg_price_super": pkgPriceSuper,
    "price_high": priceHigh,
    "timelength_128": timelength128,
    "price_super": priceSuper,
    "max_sort": maxSort,
    "exclusive": exclusive,
    "album_audio_remark": albumAudioRemark,
    "hash_super": hashSuper,
    "timelength": timelength,
    "privilege_super": privilegeSuper,
    "last_sort": lastSort,
    "rp_type_128": rpTypeValues.reverse[rpType128],
    "filesize_flac": filesizeFlac,
    "rank_count": rankCount,
    "songname": songname,
    "old_hide": oldHide,
    "pay_type_128": payType128,
    "show_author_name": showAuthorName,
    "video_hash": videoHash,
    "recommend_reason": recommendReason,
    "rank_cid": rankCid,
    "video_filesize": videoFilesize,
    "status_320": status320,
    "pay_type_super": payTypeSuper,
    "old_hide_320": oldHide320,
    "offset": offset,
    "filename": filename,
    "__status": status,
    "rp_type_high": rpTypeValues.reverse[rpTypeHigh],
    "timelength_flac": timelengthFlac,
    "topic_url": topicUrl,
    "rp_publish": rpPublish,
    "old_cpy_super": oldCpySuper,
    "audio_id": audioId,
    "remark": remark,
    "musical": musical.toJson(),
    "pkg_price_high": pkgPriceHigh,
    "filesize_128": filesize128,
    "album_id": albumId,
    "hash_320": hash320,
    "pkg_price_flac": pkgPriceFlac,
    "has_obbligato": hasObbligato,
    "topic_url_320": topicUrl320,
    "fail_process_high": failProcessHigh,
    "filesize_high": filesizeHigh,
    "filesize": filesize,
    "extname_super": extnameSuper,
    "status_high": statusHigh,
    "video_track": videoTrack,
    "bitrate_high": bitrateHigh,
    "bitrate_super": bitrateSuper,
    "hash_high": hashHigh,
    "price_flac": priceFlac,
    "author_name": authorName,
    "sort": sort,
    "timelength_320": timelength320,
    "album_sizable_cover": albumSizableCover,
    "extname": extnameValues.reverse[extname],
    "topic_url_high": topicUrlHigh,
    "status_flac": statusFlac,
    "privilege_flac": privilegeFlac,
    "old_cpy": oldCpy,
    "remarks": List<dynamic>.from(remarks.map((x) => x.toJson())),
    "old_cpy_128": oldCpy128,
    "topic_url_super": topicUrlSuper,
    "video_timelength": videoTimelength,
    "filesize_super": filesizeSuper,
    "level": level,
    "privilege_320": privilege320,
    "pkg_price_128": pkgPrice128,
    "price": price,
    "pay_type_flac": payTypeFlac,
    "rp_type_super": rpTypeSuper,
    "pay_type_320": payType320,
    "bitrate": bitrate,
    "trans_param": transParam.toJson(),
    "hash_flac": hashFlac,
    "hash_128": hash128,
    "fail_process_super": failProcessSuper,
    "fail_process_flac": failProcessFlac,
    "old_cpy_flac": oldCpyFlac,
    "old_hide_high": oldHideHigh,
    "album_audio_id": albumAudioId,
    "privilege": privilege,
    "pkg_price": pkgPrice,
    "bitrate_flac": bitrateFlac,
    "addtime": addtime.toIso8601String(),
  };

  String getAlbumSizableCover({int? size = 256}) {
    return albumSizableCover.replaceAll(RegExp(r'{size}'), size.toString());
  }
}

class Author {
  String sizableAvatar;
  int isPublish;
  int authorId;
  String authorName;

  Author({
    required this.sizableAvatar,
    required this.isPublish,
    required this.authorId,
    required this.authorName,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    sizableAvatar: json["sizable_avatar"],
    isPublish: json["is_publish"],
    authorId: json["author_id"],
    authorName: json["author_name"],
  );

  Map<String, dynamic> toJson() => {
    "sizable_avatar": sizableAvatar,
    "is_publish": isPublish,
    "author_id": authorId,
    "author_name": authorName,
  };
}

enum Extname { MP3 }

final extnameValues = EnumValues({"mp3": Extname.MP3});

class Musical {
  Musical();

  factory Musical.fromJson(Map<String, dynamic> json) => Musical();

  Map<String, dynamic> toJson() => {};
}

class Remark {
  String remark;
  int? ipType;
  int relAlbumAudioId;
  int remarkType;
  String? workType;
  int? isDefautAlias;

  Remark({
    required this.remark,
    this.ipType,
    required this.relAlbumAudioId,
    required this.remarkType,
    this.workType,
    this.isDefautAlias,
  });

  factory Remark.fromJson(Map<String, dynamic> json) => Remark(
    remark: json["remark"],
    ipType: json["ip_type"],
    relAlbumAudioId: json["rel_album_audio_id"],
    remarkType: json["remark_type"],
    workType: json["work_type"],
    isDefautAlias: json["is_defaut_alias"],
  );

  Map<String, dynamic> toJson() => {
    "remark": remark,
    "ip_type": ipType,
    "rel_album_audio_id": relAlbumAudioId,
    "remark_type": remarkType,
    "work_type": workType,
    "is_defaut_alias": isDefautAlias,
  };
}

enum RpType { AUDIO, EMPTY }

final rpTypeValues = EnumValues({"audio": RpType.AUDIO, "": RpType.EMPTY});

class TransParam {
  int cpyGrade;
  String unionCover;
  Language language;
  int? freeLimited;
  int cpyAttr0;
  int musicpackAdvance;
  int ogg128Filesize;
  int displayRate;
  Qualitymap qualitymap;
  int cid;
  int payBlockTpl;
  int display;
  ClassmapClass ipmap;
  String? hashMultitrack;
  String ogg128Hash;
  ClassmapClass classmap;
  int cpyLevel;
  int? ogg320Filesize;
  String? ogg320Hash;
  String? songnameSuffix;
  String? appidBlock;
  int? provider;
  HashOffset? hashOffset;
  int? initPubDay;

  TransParam({
    required this.cpyGrade,
    required this.unionCover,
    required this.language,
    this.freeLimited,
    required this.cpyAttr0,
    required this.musicpackAdvance,
    required this.ogg128Filesize,
    required this.displayRate,
    required this.qualitymap,
    required this.cid,
    required this.payBlockTpl,
    required this.display,
    required this.ipmap,
    this.hashMultitrack,
    required this.ogg128Hash,
    required this.classmap,
    required this.cpyLevel,
    this.ogg320Filesize,
    this.ogg320Hash,
    this.songnameSuffix,
    this.appidBlock,
    this.provider,
    this.hashOffset,
    this.initPubDay,
  });

  factory TransParam.fromJson(Map<String, dynamic> json) => TransParam(
    cpyGrade: json["cpy_grade"],
    unionCover: json["union_cover"],
    language: languageValues.map[json["language"]]!,
    freeLimited: json["free_limited"],
    cpyAttr0: json["cpy_attr0"],
    musicpackAdvance: json["musicpack_advance"],
    ogg128Filesize: json["ogg_128_filesize"],
    displayRate: json["display_rate"],
    qualitymap: Qualitymap.fromJson(json["qualitymap"]),
    cid: json["cid"],
    payBlockTpl: json["pay_block_tpl"],
    display: json["display"],
    ipmap: ClassmapClass.fromJson(json["ipmap"]),
    hashMultitrack: json["hash_multitrack"],
    ogg128Hash: json["ogg_128_hash"],
    classmap: ClassmapClass.fromJson(json["classmap"]),
    cpyLevel: json["cpy_level"],
    ogg320Filesize: json["ogg_320_filesize"],
    ogg320Hash: json["ogg_320_hash"],
    songnameSuffix: json["songname_suffix"],
    appidBlock: json["appid_block"],
    provider: json["provider"],
    hashOffset: json["hash_offset"] == null
        ? null
        : HashOffset.fromJson(json["hash_offset"]),
    initPubDay: json["init_pub_day"],
  );

  Map<String, dynamic> toJson() => {
    "cpy_grade": cpyGrade,
    "union_cover": unionCover,
    "language": languageValues.reverse[language],
    "free_limited": freeLimited,
    "cpy_attr0": cpyAttr0,
    "musicpack_advance": musicpackAdvance,
    "ogg_128_filesize": ogg128Filesize,
    "display_rate": displayRate,
    "qualitymap": qualitymap.toJson(),
    "cid": cid,
    "pay_block_tpl": payBlockTpl,
    "display": display,
    "ipmap": ipmap.toJson(),
    "hash_multitrack": hashMultitrack,
    "ogg_128_hash": ogg128Hash,
    "classmap": classmap.toJson(),
    "cpy_level": cpyLevel,
    "ogg_320_filesize": ogg320Filesize,
    "ogg_320_hash": ogg320Hash,
    "songname_suffix": songnameSuffix,
    "appid_block": appidBlock,
    "provider": provider,
    "hash_offset": hashOffset?.toJson(),
    "init_pub_day": initPubDay,
  };
}

class ClassmapClass {
  int attr0;

  ClassmapClass({required this.attr0});

  factory ClassmapClass.fromJson(Map<String, dynamic> json) =>
      ClassmapClass(attr0: json["attr0"]);

  Map<String, dynamic> toJson() => {"attr0": attr0};
}

class HashOffset {
  String clipHash;
  int startByte;
  int endMs;
  int endByte;
  int fileType;
  int startMs;
  String offsetHash;

  HashOffset({
    required this.clipHash,
    required this.startByte,
    required this.endMs,
    required this.endByte,
    required this.fileType,
    required this.startMs,
    required this.offsetHash,
  });

  factory HashOffset.fromJson(Map<String, dynamic> json) => HashOffset(
    clipHash: json["clip_hash"],
    startByte: json["start_byte"],
    endMs: json["end_ms"],
    endByte: json["end_byte"],
    fileType: json["file_type"],
    startMs: json["start_ms"],
    offsetHash: json["offset_hash"],
  );

  Map<String, dynamic> toJson() => {
    "clip_hash": clipHash,
    "start_byte": startByte,
    "end_ms": endMs,
    "end_byte": endByte,
    "file_type": fileType,
    "start_ms": startMs,
    "offset_hash": offsetHash,
  };
}

enum Language { EMPTY, LANGUAGE }

final languageValues = EnumValues({
  "国语": Language.EMPTY,
  "粤语": Language.LANGUAGE,
});

class Qualitymap {
  String bits;
  int attr0;
  int attr1;

  Qualitymap({required this.bits, required this.attr0, required this.attr1});

  factory Qualitymap.fromJson(Map<String, dynamic> json) => Qualitymap(
    bits: json["bits"],
    attr0: json["attr0"],
    attr1: json["attr1"],
  );

  Map<String, dynamic> toJson() => {
    "bits": bits,
    "attr0": attr0,
    "attr1": attr1,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
