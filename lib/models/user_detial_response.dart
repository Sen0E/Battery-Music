class UserDetial {
  // --- 1. 基础资料 ---
  final String? nickname;
  final String? kNickname;
  final String? fxNickname;
  final String? pic;
  final String? kPic;
  final String? fxPic;
  final String? bgPic;
  final int? gender;
  final String? descri;
  final String? birthday;
  final String? city;
  final String? province;
  final String? occupation;
  final int? constellation;
  final String? hobby; // 爱好
  final String? remark; // 备注
  final String? loc; // 位置

  // --- 2. 社交与数据统计 ---
  final int? follows;
  final int? fans;
  final int? visitors;
  final int? hvisitors;
  final int? nvisitors;
  final int? friends;
  final int? relation;

  // --- 3. VIP、等级与特权 ---
  final int? vipType;
  final int? mType;
  final int? yType;
  final int? userType; // 用户类型
  final int? userYType;
  final int? pGrade;
  final int? svipLevel;
  final int? svipScore;
  final String? suVipBeginTime;
  final String? suVipEndTime;
  final String? suVipClearday;
  final String? suVipYEndtime;
  final int? bookvipValid;
  final int? singvipValid;

  // --- 4. 认证与状态 ---
  final int? realAuth;
  final int? faceAuth;
  final int? avatarReview;
  final String? authInfo;
  final String? authInfoSinger;
  final String? authInfoTalent;
  final int? starStatus;
  final int? starId;
  final int? isStar;
  final int? kStar; // K歌之星标识
  final int? singerStatus;
  final int? actorStatus; // 演员状态

  // --- 5. 勋章与铭牌 (非VIP可能缺失或为空) ---
  final UserMedalModel? medal;
  final int? nameplateId;
  final String? nameplateUrl;
  final String? nameplateDynamic;
  final int? nameplateType;
  final String? nameplateUrlV1;
  final String? nameplateDynamicV1;

  // --- 6. 其他配置与系统标识 ---
  final int? kqTalent;
  final int? servertime;
  final int? rtime; // 注册/记录时间
  final int? iden;
  final int? logintime;
  final int? duration;
  final int? visible;
  final String? userLikeid;
  final int? topNumber;
  final int? topVersion; // 可能返回 String "0" 或 int 0

  // --- 7. 模块可见性配置 (0/1/2 等开关) ---
  final int? commentVisible;
  final int? studentVisible;
  final int? followlistVisible;
  final int? fanslistVisible;
  final int? infoVisible;
  final int? followVisible;
  final int? listenVisible;
  final int? albumVisible;
  final int? pictorialVisible;
  final int? radioVisible;
  final int? soundVisible;
  final int? appletVisible;
  final int? selflistVisible;
  final int? collectlistVisible;
  final int? lvideoVisible;
  final int? svideoVisible;
  final int? mvVisible;
  final int? ksongVisible;
  final int? boxVisible;
  final int? nftVisible;
  final int? musicalVisible;
  final int? liveVisible;
  final int? timbreVisible;
  final int? assetsVisible;
  final int? onlineVisible;
  final int? ltingVisible;
  final int? listenmusicVisible;
  final int? likemusicVisible;
  final int? kuelfVisible;
  final int? shareVisible;
  final int? musicstationVisible;
  final int? yaicreationVisible;
  final int? ylikestoryVisible;
  final int? ychannelVisible;
  final int? ypublishstoryVisible;
  final int? myplayerVisible;
  final int? usermedalVisible;
  final int? singletrackVisible;
  final int? faxingkaVisible;
  final int? aiSongVisible;
  final int? mcardVisible;

  UserDetial({
    this.nickname,
    this.kNickname,
    this.fxNickname,
    this.pic,
    this.kPic,
    this.fxPic,
    this.bgPic,
    this.gender,
    this.descri,
    this.birthday,
    this.city,
    this.province,
    this.occupation,
    this.constellation,
    this.hobby,
    this.remark,
    this.loc,
    this.follows,
    this.fans,
    this.visitors,
    this.hvisitors,
    this.nvisitors,
    this.friends,
    this.relation,
    this.vipType,
    this.mType,
    this.yType,
    this.userType,
    this.userYType,
    this.pGrade,
    this.svipLevel,
    this.svipScore,
    this.suVipBeginTime,
    this.suVipEndTime,
    this.suVipClearday,
    this.suVipYEndtime,
    this.bookvipValid,
    this.singvipValid,
    this.realAuth,
    this.faceAuth,
    this.avatarReview,
    this.authInfo,
    this.authInfoSinger,
    this.authInfoTalent,
    this.starStatus,
    this.starId,
    this.isStar,
    this.kStar,
    this.singerStatus,
    this.actorStatus,
    this.medal,
    this.nameplateId,
    this.nameplateUrl,
    this.nameplateDynamic,
    this.nameplateType,
    this.nameplateUrlV1,
    this.nameplateDynamicV1,
    this.kqTalent,
    this.servertime,
    this.rtime,
    this.iden,
    this.logintime,
    this.duration,
    this.visible,
    this.userLikeid,
    this.topNumber,
    this.topVersion,
    this.commentVisible,
    this.studentVisible,
    this.followlistVisible,
    this.fanslistVisible,
    this.infoVisible,
    this.followVisible,
    this.listenVisible,
    this.albumVisible,
    this.pictorialVisible,
    this.radioVisible,
    this.soundVisible,
    this.appletVisible,
    this.selflistVisible,
    this.collectlistVisible,
    this.lvideoVisible,
    this.svideoVisible,
    this.mvVisible,
    this.ksongVisible,
    this.boxVisible,
    this.nftVisible,
    this.musicalVisible,
    this.liveVisible,
    this.timbreVisible,
    this.assetsVisible,
    this.onlineVisible,
    this.ltingVisible,
    this.listenmusicVisible,
    this.likemusicVisible,
    this.kuelfVisible,
    this.shareVisible,
    this.musicstationVisible,
    this.yaicreationVisible,
    this.ylikestoryVisible,
    this.ychannelVisible,
    this.ypublishstoryVisible,
    this.myplayerVisible,
    this.usermedalVisible,
    this.singletrackVisible,
    this.faxingkaVisible,
    this.aiSongVisible,
    this.mcardVisible,
  });

  factory UserDetial.fromJson(Map<String, dynamic> json) {
    return UserDetial(
      nickname: json['nickname']?.toString(), // 有时是数字id
      kNickname: json['k_nickname'] as String?,
      fxNickname: json['fx_nickname'] as String?,
      pic: json['pic'] as String?,
      kPic: json['k_pic'] as String?,
      fxPic: json['fx_pic'] as String?,
      bgPic: json['bg_pic'] as String?,
      gender: json['gender'] as int?,
      descri: json['descri'] as String?,
      birthday: json['birthday'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      occupation: json['occupation'] as String?,
      constellation: json['constellation'] as int?,
      hobby: json['hobby'] as String?,
      remark: json['remark'] as String?,
      loc: json['loc'] as String?,

      follows: json['follows'] as int?,
      fans: json['fans'] as int?,
      visitors: json['visitors'] as int?,
      hvisitors: json['hvisitors'] as int?,
      nvisitors: json['nvisitors'] as int?,
      friends: json['friends'] as int?,
      relation: json['relation'] as int?,

      vipType: json['vip_type'] as int?,
      mType: json['m_type'] as int?,
      yType: json['y_type'] as int?,
      userType: json['user_type'] as int?,
      userYType: json['user_y_type'] as int?,
      pGrade: json['p_grade'] as int?,
      svipLevel: json['svip_level'] as int?,
      svipScore: json['svip_score'] as int?,
      suVipBeginTime: json['su_vip_begin_time'] as String?,
      suVipEndTime: json['su_vip_end_time'] as String?,
      suVipClearday: json['su_vip_clearday'] as String?,
      suVipYEndtime: json['su_vip_y_endtime'] as String?,
      bookvipValid: json['bookvip_valid'] as int?,
      singvipValid: json['singvip_valid'] as int?,

      realAuth: json['real_auth'] as int?,
      faceAuth: json['face_auth'] as int?,
      avatarReview: json['avatar_review'] as int?,
      authInfo: json['auth_info'] as String?,
      authInfoSinger: json['auth_info_singer'] as String?,
      authInfoTalent: json['auth_info_talent'] as String?,
      starStatus: json['star_status'] as int?,
      starId: json['star_id'] as int?,
      isStar: json['is_star'] as int?,
      kStar: json['k_star'] as int?,
      singerStatus: json['singer_status'] as int?,
      actorStatus: json['actor_status'] as int?,

      medal: json['medal'] != null
          ? UserMedalModel.fromJson(json['medal'])
          : null,

      // 铭牌字段非VIP账号可能直接没有，会自动解析为 null
      nameplateId: json['nameplate_id'] as int?,
      nameplateUrl: json['nameplate_url'] as String?,
      nameplateDynamic: json['nameplate_dynamic'] as String?,
      nameplateType: json['nameplate_type'] as int?,
      nameplateUrlV1: json['nameplate_url_v1'] as String?,
      nameplateDynamicV1: json['nameplate_dynamic_v1'] as String?,

      kqTalent: json['kq_talent'] as int?,
      servertime: json['servertime'] as int?,
      rtime: json['rtime'] as int?,
      iden: json['iden'] as int?,
      logintime: json['logintime'] as int?,
      duration: json['duration'] as int?,
      visible: json['visible'] as int?,
      userLikeid: json['user_likeid'] as String?,
      topNumber: json['top_number'] as int?,

      // 兼容 top_version 可能是 String "0" 或 int 0 的情况
      topVersion: int.tryParse(json['top_version']?.toString() ?? ''),

      commentVisible: json['comment_visible'] as int?,
      studentVisible: json['student_visible'] as int?,
      followlistVisible: json['followlist_visible'] as int?,
      fanslistVisible: json['fanslist_visible'] as int?,
      infoVisible: json['info_visible'] as int?,
      followVisible: json['follow_visible'] as int?,
      listenVisible: json['listen_visible'] as int?,
      albumVisible: json['album_visible'] as int?,
      pictorialVisible: json['pictorial_visible'] as int?,
      radioVisible: json['radio_visible'] as int?,
      soundVisible: json['sound_visible'] as int?,
      appletVisible: json['applet_visible'] as int?,
      selflistVisible: json['selflist_visible'] as int?,
      collectlistVisible: json['collectlist_visible'] as int?,
      lvideoVisible: json['lvideo_visible'] as int?,
      svideoVisible: json['svideo_visible'] as int?,
      mvVisible: json['mv_visible'] as int?,
      ksongVisible: json['ksong_visible'] as int?,
      boxVisible: json['box_visible'] as int?,
      nftVisible: json['nft_visible'] as int?,
      musicalVisible: json['musical_visible'] as int?,
      liveVisible: json['live_visible'] as int?,
      timbreVisible: json['timbre_visible'] as int?,
      assetsVisible: json['assets_visible'] as int?,
      onlineVisible: json['online_visible'] as int?,
      ltingVisible: json['lting_visible'] as int?,
      listenmusicVisible: json['listenmusic_visible'] as int?,
      likemusicVisible: json['likemusic_visible'] as int?,
      kuelfVisible: json['kuelf_visible'] as int?,
      shareVisible: json['share_visible'] as int?,
      musicstationVisible: json['musicstation_visible'] as int?,
      yaicreationVisible: json['yaicreation_visible'] as int?,
      ylikestoryVisible: json['ylikestory_visible'] as int?,
      ychannelVisible: json['ychannel_visible'] as int?,
      ypublishstoryVisible: json['ypublishstory_visible'] as int?,
      myplayerVisible: json['myplayer_visible'] as int?,
      usermedalVisible: json['usermedal_visible'] as int?,
      singletrackVisible: json['singletrack_visible'] as int?,
      faxingkaVisible: json['faxingka_visible'] as int?,
      aiSongVisible: json['ai_song_visible'] as int?,
      mcardVisible: json['mcard_visible'] as int?,
    );
  }

  /// 辅助方法：获取包含 {size} 的头像处理 (方便在UI中调用指定尺寸)
  String getAvatarUrl({int size = 200}) {
    if (pic == null || pic!.isEmpty) return "";
    return pic!.replaceAll('{size}', size.toString());
  }

  /// 辅助方法：判断是否是超级会员
  bool get isSvip => (svipLevel ?? 0) > 0;

  /// 辅助方法：判断是否是普通VIP
  bool get isVip => (vipType ?? 0) > 0;
}

// ==========================================
// 勋章相关嵌套模型
// ==========================================

class UserMedalModel {
  final KtvMedalModel? ktv;
  final FxMedalModel? fx;

  UserMedalModel({this.ktv, this.fx});

  factory UserMedalModel.fromJson(Map<String, dynamic> json) {
    return UserMedalModel(
      ktv: json['ktv'] != null ? KtvMedalModel.fromJson(json['ktv']) : null,
      fx: json['fx'] != null ? FxMedalModel.fromJson(json['fx']) : null,
    );
  }
}

class KtvMedalModel {
  final String? type3;
  final String? type2;
  final String? type1;

  KtvMedalModel({this.type3, this.type2, this.type1});

  factory KtvMedalModel.fromJson(Map<String, dynamic> json) {
    // 即使非VIP的 ktv 是空对象 {}，这里的 json['type3'] 也会安全地解析为 null
    return KtvMedalModel(
      type3: json['type3'] as String?,
      type2: json['type2'] as String?,
      type1: json['type1'] as String?,
    );
  }
}

class FxMedalModel {
  final int? vipLevel;
  final int? richLevel;
  final int? starLevel;

  FxMedalModel({this.vipLevel, this.richLevel, this.starLevel});

  factory FxMedalModel.fromJson(Map<String, dynamic> json) {
    return FxMedalModel(
      vipLevel: json['vipLevel'] as int?,
      richLevel: json['richLevel'] as int?,
      starLevel: json['starLevel'] as int?,
    );
  }
}
