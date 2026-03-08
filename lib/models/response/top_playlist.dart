// To parse this JSON data, do
//
//     final topPlaylist = topPlaylistFromJson(jsonString);

import 'dart:convert';

TopPlaylist topPlaylistFromJson(String str) =>
    TopPlaylist.fromJson(json.decode(str));

String topPlaylistToJson(TopPlaylist data) => json.encode(data.toJson());

class TopPlaylist {
  int hasNext;
  String biBiz;
  String session;
  int algId;
  List<SpecialList> specialList;
  String olexpIds;
  int showTime;
  int allClientPlaylistFlag;
  int refreshTime;

  TopPlaylist({
    required this.hasNext,
    required this.biBiz,
    required this.session,
    required this.algId,
    required this.specialList,
    required this.olexpIds,
    required this.showTime,
    required this.allClientPlaylistFlag,
    required this.refreshTime,
  });

  factory TopPlaylist.fromJson(Map<String, dynamic> json) => TopPlaylist(
    hasNext: json["has_next"],
    biBiz: json["bi_biz"],
    session: json["session"],
    algId: json["alg_id"],
    specialList: List<SpecialList>.from(
      json["special_list"].map((x) => SpecialList.fromJson(x)),
    ),
    olexpIds: json["OlexpIds"],
    showTime: json["show_time"],
    allClientPlaylistFlag: json["all_client_playlist_flag"],
    refreshTime: json["refresh_time"],
  );

  Map<String, dynamic> toJson() => {
    "has_next": hasNext,
    "bi_biz": biBiz,
    "session": session,
    "alg_id": algId,
    "special_list": List<dynamic>.from(specialList.map((x) => x.toJson())),
    "OlexpIds": olexpIds,
    "show_time": showTime,
    "all_client_playlist_flag": allClientPlaylistFlag,
    "refresh_time": refreshTime,
  };
}

class SpecialList {
  List<Abtag>? abtags;
  int sync;
  int specialid;
  int percount;
  ListInfoTransParam listInfoTransParam;
  int bzStatus;
  Singername singername;
  int from;
  AlgPath algPath;
  List<Tag> tags;
  int ugcTalentReview;
  int type;
  int slid;
  String flexibleCover;
  String nickname;
  Show show;
  int collectType;
  int collectcount;
  TransParam transParam;
  String reportInfo;
  String specialname;
  String imgurl;
  int playCount;
  String pic;
  String fromHash;
  int fromTag;
  DateTime publishtime;
  String globalCollectionId;
  String intro;
  int suid;

  SpecialList({
    this.abtags,
    required this.sync,
    required this.specialid,
    required this.percount,
    required this.listInfoTransParam,
    required this.bzStatus,
    required this.singername,
    required this.from,
    required this.algPath,
    required this.tags,
    required this.ugcTalentReview,
    required this.type,
    required this.slid,
    required this.flexibleCover,
    required this.nickname,
    required this.show,
    required this.collectType,
    required this.collectcount,
    required this.transParam,
    required this.reportInfo,
    required this.specialname,
    required this.imgurl,
    required this.playCount,
    required this.pic,
    required this.fromHash,
    required this.fromTag,
    required this.publishtime,
    required this.globalCollectionId,
    required this.intro,
    required this.suid,
  });

  factory SpecialList.fromJson(Map<String, dynamic> json) => SpecialList(
    abtags: json["abtags"] == null
        ? []
        : List<Abtag>.from(json["abtags"]!.map((x) => Abtag.fromJson(x))),
    sync: json["sync"],
    specialid: json["specialid"],
    percount: json["percount"],
    listInfoTransParam: ListInfoTransParam.fromJson(
      json["list_info_trans_param"],
    ),
    bzStatus: json["bz_status"],
    singername: singernameValues.map[json["singername"]]!,
    from: json["from"],
    algPath: algPathValues.map[json["alg_path"]]!,
    // tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
    tags: json["tags"].isEmpty
        ? []
        : List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
    ugcTalentReview: json["ugc_talent_review"],
    type: json["type"],
    slid: json["slid"],
    flexibleCover: json["flexible_cover"],
    nickname: json["nickname"],
    show: showValues.map[json["show"]]!,
    collectType: json["collectType"],
    collectcount: json["collectcount"],
    transParam: TransParam.fromJson(json["trans_param"]),
    reportInfo: json["report_info"],
    specialname: json["specialname"],
    imgurl: json["imgurl"],
    playCount: json["play_count"],
    pic: json["pic"],
    fromHash: json["from_hash"],
    fromTag: json["from_tag"],
    publishtime: DateTime.parse(json["publishtime"]),
    globalCollectionId: json["global_collection_id"],
    intro: json["intro"],
    suid: json["suid"],
  );

  Map<String, dynamic> toJson() => {
    "abtags": abtags == null
        ? []
        : List<dynamic>.from(abtags!.map((x) => x.toJson())),
    "sync": sync,
    "specialid": specialid,
    "percount": percount,
    "list_info_trans_param": listInfoTransParam.toJson(),
    "bz_status": bzStatus,
    "singername": singernameValues.reverse[singername],
    "from": from,
    "alg_path": algPathValues.reverse[algPath],
    "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
    "ugc_talent_review": ugcTalentReview,
    "type": type,
    "slid": slid,
    "flexible_cover": flexibleCover,
    "nickname": nickname,
    "show": showValues.reverse[show],
    "collectType": collectType,
    "collectcount": collectcount,
    "trans_param": transParam.toJson(),
    "report_info": reportInfo,
    "specialname": specialname,
    "imgurl": imgurl,
    "play_count": playCount,
    "pic": pic,
    "from_hash": fromHash,
    "from_tag": fromTag,
    "publishtime": publishtime.toIso8601String(),
    "global_collection_id": globalCollectionId,
    "intro": intro,
    "suid": suid,
  };

  String getFlexibleCover({int? size = 256}) {
    return flexibleCover.replaceAll("{size}", size.toString());
  }

  String getImgurl({int? size = 256}) {
    return imgurl.replaceAll("{size}", size.toString());
  }
}

class Abtag {
  String name;

  Abtag({required this.name});

  factory Abtag.fromJson(Map<String, dynamic> json) =>
      Abtag(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}

enum AlgPath { RECALL_FAISS, RECALL_SCID_SOURCE, RECALL_W2_V }

final algPathValues = EnumValues({
  "recall:faiss": AlgPath.RECALL_FAISS,
  "recall:scid_source": AlgPath.RECALL_SCID_SOURCE,
  "recall:w2v": AlgPath.RECALL_W2_V,
});

class ListInfoTransParam {
  int specialTag;
  int iden;
  int transFlag;
  Skin? skin;
  Aimusic? aimusic;

  ListInfoTransParam({
    required this.specialTag,
    required this.iden,
    required this.transFlag,
    this.skin,
    this.aimusic,
  });

  factory ListInfoTransParam.fromJson(Map<String, dynamic> json) =>
      ListInfoTransParam(
        specialTag: json["special_tag"],
        iden: json["iden"],
        transFlag: json["trans_flag"],
        skin: json["skin"] == null ? null : Skin.fromJson(json["skin"]),
        aimusic: json["aimusic"] == null
            ? null
            : Aimusic.fromJson(json["aimusic"]),
      );

  Map<String, dynamic> toJson() => {
    "special_tag": specialTag,
    "iden": iden,
    "trans_flag": transFlag,
    "skin": skin?.toJson(),
    "aimusic": aimusic?.toJson(),
  };
}

class Aimusic {
  String args;
  String id;

  Aimusic({required this.args, required this.id});

  factory Aimusic.fromJson(Map<String, dynamic> json) =>
      Aimusic(args: json["args"], id: json["id"]);

  Map<String, dynamic> toJson() => {"args": args, "id": id};
}

class Skin {
  DisplayVersionUserids displayVersionUserids;
  String fontColor;
  String moduleType;
  String id;
  String backgroundInfoType;
  int usedCount;
  ModuleThemeInfo moduleThemeInfo;
  String freeStart;
  int vipType;
  int resourceType;
  String freeEnd;
  BackgroundInfo backgroundInfo;
  String title;
  int statusBarHeight;
  Preview preview;
  String thumbnail;

  Skin({
    required this.displayVersionUserids,
    required this.fontColor,
    required this.moduleType,
    required this.id,
    required this.backgroundInfoType,
    required this.usedCount,
    required this.moduleThemeInfo,
    required this.freeStart,
    required this.vipType,
    required this.resourceType,
    required this.freeEnd,
    required this.backgroundInfo,
    required this.title,
    required this.statusBarHeight,
    required this.preview,
    required this.thumbnail,
  });

  factory Skin.fromJson(Map<String, dynamic> json) => Skin(
    displayVersionUserids: DisplayVersionUserids.fromJson(
      json["display_version_userids"],
    ),
    fontColor: json["font_color"],
    moduleType: json["module_type"],
    id: json["id"],
    backgroundInfoType: json["background_info_type"],
    usedCount: json["used_count"],
    moduleThemeInfo: ModuleThemeInfo.fromJson(json["module_theme_info"]),
    freeStart: json["free_start"],
    vipType: json["vip_type"],
    resourceType: json["resource_type"],
    freeEnd: json["free_end"],
    backgroundInfo: BackgroundInfo.fromJson(json["background_info"]),
    title: json["title"],
    statusBarHeight: json["status_bar_height"],
    preview: Preview.fromJson(json["preview"]),
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "display_version_userids": displayVersionUserids.toJson(),
    "font_color": fontColor,
    "module_type": moduleType,
    "id": id,
    "background_info_type": backgroundInfoType,
    "used_count": usedCount,
    "module_theme_info": moduleThemeInfo.toJson(),
    "free_start": freeStart,
    "vip_type": vipType,
    "resource_type": resourceType,
    "free_end": freeEnd,
    "background_info": backgroundInfo.toJson(),
    "title": title,
    "status_bar_height": statusBarHeight,
    "preview": preview.toJson(),
    "thumbnail": thumbnail,
  };
}

class BackgroundInfo {
  ColorInfo colorInfo;
  GradientInfo gradientInfo;
  BlurInfo blurInfo;
  ImageInfo imageInfo;

  BackgroundInfo({
    required this.colorInfo,
    required this.gradientInfo,
    required this.blurInfo,
    required this.imageInfo,
  });

  factory BackgroundInfo.fromJson(Map<String, dynamic> json) => BackgroundInfo(
    colorInfo: ColorInfo.fromJson(json["color_info"]),
    gradientInfo: GradientInfo.fromJson(json["gradient_info"]),
    blurInfo: BlurInfo.fromJson(json["blur_info"]),
    imageInfo: ImageInfo.fromJson(json["image_info"]),
  );

  Map<String, dynamic> toJson() => {
    "color_info": colorInfo.toJson(),
    "gradient_info": gradientInfo.toJson(),
    "blur_info": blurInfo.toJson(),
    "image_info": imageInfo.toJson(),
  };
}

class BlurInfo {
  String maskColor;
  dynamic radiu;

  BlurInfo({required this.maskColor, required this.radiu});

  factory BlurInfo.fromJson(Map<String, dynamic> json) =>
      BlurInfo(maskColor: json["mask_color"], radiu: json["radiu"]);

  Map<String, dynamic> toJson() => {"mask_color": maskColor, "radiu": radiu};
}

class ColorInfo {
  String color;

  ColorInfo({required this.color});

  factory ColorInfo.fromJson(Map<String, dynamic> json) =>
      ColorInfo(color: json["color"]);

  Map<String, dynamic> toJson() => {"color": color};
}

class GradientInfo {
  String maskColor;
  String orientation;
  String toColor;
  String fromColor;

  GradientInfo({
    required this.maskColor,
    required this.orientation,
    required this.toColor,
    required this.fromColor,
  });

  factory GradientInfo.fromJson(Map<String, dynamic> json) => GradientInfo(
    maskColor: json["mask_color"],
    orientation: json["orientation"],
    toColor: json["to_color"],
    fromColor: json["from_color"],
  );

  Map<String, dynamic> toJson() => {
    "mask_color": maskColor,
    "orientation": orientation,
    "to_color": toColor,
    "from_color": fromColor,
  };
}

class ImageInfo {
  String imageUrl;

  ImageInfo({required this.imageUrl});

  factory ImageInfo.fromJson(Map<String, dynamic> json) =>
      ImageInfo(imageUrl: json["image_url"]);

  Map<String, dynamic> toJson() => {"image_url": imageUrl};
}

class DisplayVersionUserids {
  Userids userids;
  Version version;

  DisplayVersionUserids({required this.userids, required this.version});

  factory DisplayVersionUserids.fromJson(Map<String, dynamic> json) =>
      DisplayVersionUserids(
        userids: Userids.fromJson(json["userids"]),
        version: Version.fromJson(json["version"]),
      );

  Map<String, dynamic> toJson() => {
    "userids": userids.toJson(),
    "version": version.toJson(),
  };
}

class Userids {
  Userids();

  factory Userids.fromJson(Map<String, dynamic> json) => Userids();

  Map<String, dynamic> toJson() => {};
}

class Version {
  List<Android> android;
  List<Android> ios;

  Version({required this.android, required this.ios});

  factory Version.fromJson(Map<String, dynamic> json) => Version(
    // android: List<Android>.from(
    //   json["android"].map((x) => Android.fromJson(x)),
    // ),
    android: json["android"] == null
        ? []
        : _parseAndroidList(json["android"]),
    // ios: List<Android>.from(json["ios"].map((x) => Android.fromJson(x))),
    ios: json["ios"] == null
        ? []
        : _parseAndroidList(json["ios"]),
  );

  static List<Android> _parseAndroidList(dynamic androidData) {
    if (androidData is List) {
      return androidData
          .where((item) => item is Map<String, dynamic>)
          .map((item) => Android.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }

  Map<String, dynamic> toJson() => {
    "android": List<dynamic>.from(android.map((x) => x.toJson())),
    "ios": List<dynamic>.from(ios.map((x) => x.toJson())),
  };
}

class Android {
  int b;
  int e;

  Android({required this.b, required this.e});

  factory Android.fromJson(Map<String, dynamic> json) =>
      Android(b: json["b"], e: json["e"]);

  Map<String, dynamic> toJson() => {"b": b, "e": e};
}

class ModuleThemeInfo {
  Size size;
  String md5;
  String maxHeightRate;
  String url;
  Userids images;
  String layout;
  int num;

  ModuleThemeInfo({
    required this.size,
    required this.md5,
    required this.maxHeightRate,
    required this.url,
    required this.images,
    required this.layout,
    required this.num,
  });

  factory ModuleThemeInfo.fromJson(Map<String, dynamic> json) =>
      ModuleThemeInfo(
        size: Size.fromJson(json["size"]),
        md5: json["md5"],
        maxHeightRate: json["max_height_rate"],
        url: json["url"],
        images: Userids.fromJson(json["images"]),
        layout: json["layout"],
        num: json["num"],
      );

  Map<String, dynamic> toJson() => {
    "size": size.toJson(),
    "md5": md5,
    "max_height_rate": maxHeightRate,
    "url": url,
    "images": images.toJson(),
    "layout": layout,
    "num": num,
  };
}

class Size {
  int width;
  int height;

  Size({required this.width, required this.height});

  factory Size.fromJson(Map<String, dynamic> json) =>
      Size(width: json["width"], height: json["height"]);

  Map<String, dynamic> toJson() => {"width": width, "height": height};
}

class Preview {
  String dynamicUrl;
  String staticUrl;

  Preview({required this.dynamicUrl, required this.staticUrl});

  factory Preview.fromJson(Map<String, dynamic> json) =>
      Preview(dynamicUrl: json["dynamic_url"], staticUrl: json["static_url"]);

  Map<String, dynamic> toJson() => {
    "dynamic_url": dynamicUrl,
    "static_url": staticUrl,
  };
}

enum Show { EMPTY, PURPLE, SHOW }

final showValues = EnumValues({
  "": Show.EMPTY,
  "根据你收藏的《打游戏，看小说都可以》推荐": Show.PURPLE,
  "根据你收藏的《日语写作业看小说必听歌曲》推荐": Show.SHOW,
});

enum Singername { EMPTY }

final singernameValues = EnumValues({"群星": Singername.EMPTY});

class Tag {
  String tagName;
  int tagId;

  Tag({required this.tagName, required this.tagId});

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(tagName: json["tag_name"], tagId: json["tag_id"]);

  Map<String, dynamic> toJson() => {"tag_name": tagName, "tag_id": tagId};
}

class TransParam {
  int specialTag;

  TransParam({required this.specialTag});

  factory TransParam.fromJson(Map<String, dynamic> json) =>
      TransParam(specialTag: json["special_tag"]);

  Map<String, dynamic> toJson() => {"special_tag": specialTag};
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
