import 'dart:convert';

import 'package:battery_music/utils/safe_convert.dart';

class UserInfoDetail {
  /// 主昵称
  final String nickname;

  /// K歌昵称
  final String kNickname;

  /// 分享昵称
  final String fxNickname;

  final int kqTalent;

  final String pic;
  final String kPic;
  final String fxPic;

  /// 性别 (1=男，2=女)
  final int gender;

  /// VIP类型
  final int vipType;

  /// 付费包
  final int mType;

  /// 年度会员
  final int yType;

  /// 个人简介
  final String descri;

  /// 关注数
  final int follows;

  /// 粉丝数
  final int fans;

  /// 访客数
  final int visitors;

  /// 星座
  final int constellation;
  final Map<String, dynamic> medal;
  final int starStatus;
  final int starId;

  /// 生日
  final String birthday;

  /// 城市
  final String city;

  /// 省份
  final String province;

  /// 职业
  final String occupation;
  final String bgPic;

  /// 与当前查看者的关系
  final int relation;
  final String authInfo;
  final String authInfoSinger;
  final String authInfoTalent;
  final int tmeStarStatus;
  final int bizStatus;
  final int pGrade;
  final int friends;
  final int faceAuth;
  final int avatarReview;

  /// 服务器时间
  final int servertime;

  /// 听书会员
  final int bookvipValid;
  final int iden;
  final int isStar;
  final int knockCnt;
  final List<dynamic> knock;
  final int realAuth;
  final int riskSymbol;
  final int userLike;
  final int userIsLike;
  final String userLikeid;
  final int topNumber;
  final int topVersion;
  final String mainShortCase;
  final String mainLongCase;
  final String guestShortCase;
  final int singerStatus;
  final String bcCode;
  final String arttoyAvatar;
  final int visitorVisible;
  final int configVal;
  final int configVal1;
  final int kuqunVisible;
  final int userType;
  final int userYType;

  /// 超级VIP开始时间
  final String suVipBeginTime;

  /// 超级VIP结束时间
  final String suVipEndTime;
  final String suVipClearday;
  final String suVipYEndtime;

  /// 上次登录时间
  final int logintime;
  final String loc;

  /// 以Visible都是个人主页哪些模块对别人可见
  final int commentVisible;
  final int studentVisible;
  final int followlistVisible;
  final int fanslistVisible;
  final int infoVisible;
  final int followVisible;
  final int listenVisible;
  final int albumVisible;
  final int pictorialVisible;
  final int radioVisible;
  final int soundVisible;
  final int appletVisible;
  final int selflistVisible;
  final int collectlistVisible;
  final int lvideoVisible;
  final int svideoVisible;
  final int mvVisible;
  final int ksongVisible;
  final int boxVisible;
  final int nftVisible;
  final int musicalVisible;
  final int liveVisible;
  final int timbreVisible;
  final int assetsVisible;
  final int onlineVisible;
  final int ltingVisible;
  final int listenmusicVisible;
  final int likemusicVisible;
  final int kuelfVisible;
  final int shareVisible;
  final int musicstationVisible;
  final int yaicreationVisible;
  final int ylikestoryVisible;
  final int ychannelVisible;
  final int ypublishstoryVisible;
  final int myplayerVisible;
  final int usermedalVisible;
  final int singletrackVisible;
  final int faxingkaVisible;
  final int aiSongVisible;
  final int mcardVisible;

  /// 名称牌
  final int nameplateId;

  /// 名称牌图标
  final String nameplateUrl;
  final String nameplateDynamic;
  final int nameplateType;
  final String nameplateUrlV1;
  final String nameplateDynamicV1;
  final int hvisitors;
  final int nvisitors;

  /// 注册时间
  final int rtime;
  final String hobby;
  final int actorStatus;
  final String remark;
  final int duration;

  /// 超级VIP等级
  final int svipLevel;

  /// 超级VIP成长值
  final int svipScore;
  final int visible;
  final int kStar;
  final int singvipValid;

  const UserInfoDetail({
    required this.nickname,
    required this.kNickname,
    required this.fxNickname,
    required this.kqTalent,
    required this.pic,
    required this.kPic,
    required this.fxPic,
    required this.gender,
    required this.vipType,
    required this.mType,
    required this.yType,
    required this.descri,
    required this.follows,
    required this.fans,
    required this.visitors,
    required this.constellation,
    required this.medal,
    required this.starStatus,
    required this.starId,
    required this.birthday,
    required this.city,
    required this.province,
    required this.occupation,
    required this.bgPic,
    required this.relation,
    required this.authInfo,
    required this.authInfoSinger,
    required this.authInfoTalent,
    required this.tmeStarStatus,
    required this.bizStatus,
    required this.pGrade,
    required this.friends,
    required this.faceAuth,
    required this.avatarReview,
    required this.servertime,
    required this.bookvipValid,
    required this.iden,
    required this.isStar,
    required this.knockCnt,
    required this.knock,
    required this.realAuth,
    required this.riskSymbol,
    required this.userLike,
    required this.userIsLike,
    required this.userLikeid,
    required this.topNumber,
    required this.topVersion,
    required this.mainShortCase,
    required this.mainLongCase,
    required this.guestShortCase,
    required this.singerStatus,
    required this.bcCode,
    required this.arttoyAvatar,
    required this.visitorVisible,
    required this.configVal,
    required this.configVal1,
    required this.kuqunVisible,
    required this.userType,
    required this.userYType,
    required this.suVipBeginTime,
    required this.suVipEndTime,
    required this.suVipClearday,
    required this.suVipYEndtime,
    required this.logintime,
    required this.loc,
    required this.commentVisible,
    required this.studentVisible,
    required this.followlistVisible,
    required this.fanslistVisible,
    required this.infoVisible,
    required this.followVisible,
    required this.listenVisible,
    required this.albumVisible,
    required this.pictorialVisible,
    required this.radioVisible,
    required this.soundVisible,
    required this.appletVisible,
    required this.selflistVisible,
    required this.collectlistVisible,
    required this.lvideoVisible,
    required this.svideoVisible,
    required this.mvVisible,
    required this.ksongVisible,
    required this.boxVisible,
    required this.nftVisible,
    required this.musicalVisible,
    required this.liveVisible,
    required this.timbreVisible,
    required this.assetsVisible,
    required this.onlineVisible,
    required this.ltingVisible,
    required this.listenmusicVisible,
    required this.likemusicVisible,
    required this.kuelfVisible,
    required this.shareVisible,
    required this.musicstationVisible,
    required this.yaicreationVisible,
    required this.ylikestoryVisible,
    required this.ychannelVisible,
    required this.ypublishstoryVisible,
    required this.myplayerVisible,
    required this.usermedalVisible,
    required this.singletrackVisible,
    required this.faxingkaVisible,
    required this.aiSongVisible,
    required this.mcardVisible,
    required this.nameplateId,
    required this.nameplateUrl,
    required this.nameplateDynamic,
    required this.nameplateType,
    required this.nameplateUrlV1,
    required this.nameplateDynamicV1,
    required this.hvisitors,
    required this.nvisitors,
    required this.rtime,
    required this.hobby,
    required this.actorStatus,
    required this.remark,
    required this.duration,
    required this.svipLevel,
    required this.svipScore,
    required this.visible,
    required this.kStar,
    required this.singvipValid,
  });

  factory UserInfoDetail.fromMap(Map<String, dynamic> map) {
    return UserInfoDetail(
      nickname: map['nickname'] ?? '',
      kNickname: map['k_nickname'] ?? '',
      fxNickname: map['fx_nickname'] ?? '',
      kqTalent: map['kq_talent'] ?? 0,
      pic: map['pic'] ?? '',
      kPic: map['k_pic'] ?? '',
      fxPic: map['fx_pic'] ?? '',
      gender: map['gender'] ?? 0,
      vipType: map['vip_type'] ?? 0,
      mType: map['m_type'] ?? 0,
      yType: map['y_type'] ?? 0,
      descri: map['descri'] ?? '',
      follows: map['follows'] ?? 0,
      fans: map['fans'] ?? 0,
      visitors: map['visitors'] ?? 0,
      constellation: map['constellation'] ?? 0,
      medal: map['medal'] ?? {},
      starStatus: map['star_status'] ?? 0,
      starId: map['star_id'] ?? 0,
      birthday: map['birthday'] ?? '',
      city: map['city'] ?? '',
      province: map['province'] ?? '',
      occupation: map['occupation'] ?? '',
      bgPic: map['bg_pic'] ?? '',
      relation: map['relation'] ?? 0,
      authInfo: map['auth_info'] ?? '',
      authInfoSinger: map['auth_info_singer'] ?? '',
      authInfoTalent: map['auth_info_talent'] ?? '',
      tmeStarStatus: map['tme_star_status'] ?? 0,
      bizStatus: map['biz_status'] ?? 0,
      pGrade: map['p_grade'] ?? 0,
      friends: map['friends'] ?? 0,
      faceAuth: map['face_auth'] ?? 0,
      avatarReview: map['avatar_review'] ?? 0,
      servertime: map['servertime'] ?? 0,
      bookvipValid: map['bookvip_valid'] ?? 0,
      iden: map['iden'] ?? 0,
      isStar: map['is_star'] ?? 0,
      knockCnt: map['knock_cnt'] ?? 0,
      knock: map['knock'] ?? [],
      realAuth: map['real_auth'] ?? 0,
      riskSymbol: map['risk_symbol'] ?? 0,
      userLike: map['user_like'] ?? 0,
      userIsLike: map['user_is_like'] ?? 0,
      userLikeid: map['user_likeid'] ?? '',
      topNumber: map['top_number'] ?? 0,
      topVersion: SafeConvert.toInt(map['top_version']),
      mainShortCase: map['main_short_case'] ?? '',
      mainLongCase: map['main_long_case'] ?? '',
      guestShortCase: map['guest_short_case'] ?? '',
      singerStatus: map['singer_status'] ?? 0,
      bcCode: map['bc_code'] ?? '',
      arttoyAvatar: map['arttoy_avatar'] ?? '',
      visitorVisible: map['visitor_visible'] ?? 0,
      configVal: map['config_val'] ?? 0,
      configVal1: map['config_val1'] ?? 0,
      kuqunVisible: map['kuqun_visible'] ?? 0,
      userType: map['user_type'] ?? 0,
      userYType: map['user_y_type'] ?? 0,
      suVipBeginTime: map['su_vip_begin_time'] ?? '',
      suVipEndTime: map['su_vip_end_time'] ?? '',
      suVipClearday: map['su_vip_clearday'] ?? '',
      suVipYEndtime: map['su_vip_y_endtime'] ?? '',
      logintime: map['logintime'] ?? 0,
      loc: map['loc'] ?? '',
      commentVisible: map['comment_visible'] ?? 0,
      studentVisible: map['student_visible'] ?? 0,
      followlistVisible: map['followlist_visible'] ?? 0,
      fanslistVisible: map['fanslist_visible'] ?? 0,
      infoVisible: map['info_visible'] ?? 0,
      followVisible: map['follow_visible'] ?? 0,
      listenVisible: map['listen_visible'] ?? 0,
      albumVisible: map['album_visible'] ?? 0,
      pictorialVisible: map['pictorial_visible'] ?? 0,
      radioVisible: map['radio_visible'] ?? 0,
      soundVisible: map['sound_visible'] ?? 0,
      appletVisible: map['applet_visible'] ?? 0,
      selflistVisible: map['selflist_visible'] ?? 0,
      collectlistVisible: map['collectlist_visible'] ?? 0,
      lvideoVisible: map['lvideo_visible'] ?? 0,
      svideoVisible: map['svideo_visible'] ?? 0,
      mvVisible: map['mv_visible'] ?? 0,
      ksongVisible: map['ksong_visible'] ?? 0,
      boxVisible: map['box_visible'] ?? 0,
      nftVisible: map['nft_visible'] ?? 0,
      musicalVisible: map['musical_visible'] ?? 0,
      liveVisible: map['live_visible'] ?? 0,
      timbreVisible: map['timbre_visible'] ?? 0,
      assetsVisible: map['assets_visible'] ?? 0,
      onlineVisible: map['online_visible'] ?? 0,
      ltingVisible: map['lting_visible'] ?? 0,
      listenmusicVisible: map['listenmusic_visible'] ?? 0,
      likemusicVisible: map['likemusic_visible'] ?? 0,
      kuelfVisible: map['kuelf_visible'] ?? 0,
      shareVisible: map['share_visible'] ?? 0,
      musicstationVisible: map['musicstation_visible'] ?? 0,
      yaicreationVisible: map['yaicreation_visible'] ?? 0,
      ylikestoryVisible: map['ylikestory_visible'] ?? 0,
      ychannelVisible: map['ychannel_visible'] ?? 0,
      ypublishstoryVisible: map['ypublishstory_visible'] ?? 0,
      myplayerVisible: map['myplayer_visible'] ?? 0,
      usermedalVisible: map['usermedal_visible'] ?? 0,
      singletrackVisible: map['singletrack_visible'] ?? 0,
      faxingkaVisible: map['faxingka_visible'] ?? 0,
      aiSongVisible: map['ai_song_visible'] ?? 0,
      mcardVisible: map['mcard_visible'] ?? 0,
      nameplateId: map['nameplate_id'] ?? 0,
      nameplateUrl: map['nameplate_url'] ?? '',
      nameplateDynamic: map['nameplate_dynamic'] ?? '',
      nameplateType: map['nameplate_type'] ?? 0,
      nameplateUrlV1: map['nameplate_url_v1'] ?? '',
      nameplateDynamicV1: map['nameplate_dynamic_v1'] ?? '',
      hvisitors: map['hvisitors'] ?? 0,
      nvisitors: map['nvisitors'] ?? 0,
      rtime: map['rtime'] ?? 0,
      hobby: map['hobby'] ?? '',
      actorStatus: map['actor_status'] ?? 0,
      remark: map['remark'] ?? '',
      duration: map['duration'] ?? 0,
      svipLevel: map['svip_level'] ?? 0,
      svipScore: map['svip_score'] ?? 0,
      visible: map['visible'] ?? 0,
      kStar: map['k_star'] ?? 0,
      singvipValid: map['singvip_valid'] ?? 0,
    );
  }

  factory UserInfoDetail.fromJson(String str) =>
      UserInfoDetail.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'k_nickname': kNickname,
      'fx_nickname': fxNickname,
      'kq_talent': kqTalent,
      'pic': pic,
      'k_pic': kPic,
      'fx_pic': fxPic,
      'gender': gender,
      'vip_type': vipType,
      'm_type': mType,
      'y_type': yType,
      'descri': descri,
      'follows': follows,
      'fans': fans,
      'visitors': visitors,
      'constellation': constellation,
      'medal': medal,
      'star_status': starStatus,
      'star_id': starId,
      'birthday': birthday,
      'city': city,
      'province': province,
      'occupation': occupation,
      'bg_pic': bgPic,
      'relation': relation,
      'auth_info': authInfo,
      'auth_info_singer': authInfoSinger,
      'auth_info_talent': authInfoTalent,
      'tme_star_status': tmeStarStatus,
      'biz_status': bizStatus,
      'p_grade': pGrade,
      'friends': friends,
      'face_auth': faceAuth,
      'avatar_review': avatarReview,
      'servertime': servertime,
      'bookvip_valid': bookvipValid,
      'iden': iden,
      'is_star': isStar,
      'knock_cnt': knockCnt,
      'knock': knock,
      'real_auth': realAuth,
      'risk_symbol': riskSymbol,
      'user_like': userLike,
      'user_is_like': userIsLike,
      'user_likeid': userLikeid,
      'top_number': topNumber,
      'top_version': topVersion,
      'main_short_case': mainShortCase,
      'main_long_case': mainLongCase,
      'guest_short_case': guestShortCase,
      'singer_status': singerStatus,
      'bc_code': bcCode,
      'arttoy_avatar': arttoyAvatar,
      'visitor_visible': visitorVisible,
      'config_val': configVal,
      'config_val1': configVal1,
      'kuqun_visible': kuqunVisible,
      'user_type': userType,
      'user_y_type': userYType,
      'su_vip_begin_time': suVipBeginTime,
      'su_vip_end_time': suVipEndTime,
      'su_vip_clearday': suVipClearday,
      'su_vip_y_endtime': suVipYEndtime,
      'logintime': logintime,
      'loc': loc,
      'comment_visible': commentVisible,
      'student_visible': studentVisible,
      'followlist_visible': followlistVisible,
      'fanslist_visible': fanslistVisible,
      'info_visible': infoVisible,
      'follow_visible': followVisible,
      'listen_visible': listenVisible,
      'album_visible': albumVisible,
      'pictorial_visible': pictorialVisible,
      'radio_visible': radioVisible,
      'sound_visible': soundVisible,
      'applet_visible': appletVisible,
      'selflist_visible': selflistVisible,
      'collectlist_visible': collectlistVisible,
      'lvideo_visible': lvideoVisible,
      'svideo_visible': svideoVisible,
      'mv_visible': mvVisible,
      'ksong_visible': ksongVisible,
      'box_visible': boxVisible,
      'nft_visible': nftVisible,
      'musical_visible': musicalVisible,
      'live_visible': liveVisible,
      'timbre_visible': timbreVisible,
      'assets_visible': assetsVisible,
      'online_visible': onlineVisible,
      'lting_visible': ltingVisible,
      'listenmusic_visible': listenmusicVisible,
      'likemusic_visible': likemusicVisible,
      'kuelf_visible': kuelfVisible,
      'share_visible': shareVisible,
      'musicstation_visible': musicstationVisible,
      'yaicreation_visible': yaicreationVisible,
      'ylikestory_visible': ylikestoryVisible,
      'ychannel_visible': ychannelVisible,
      'ypublishstory_visible': ypublishstoryVisible,
      'myplayer_visible': myplayerVisible,
      'usermedal_visible': usermedalVisible,
      'singletrack_visible': singletrackVisible,
      'faxingka_visible': faxingkaVisible,
      'ai_song_visible': aiSongVisible,
      'mcard_visible': mcardVisible,
      'nameplate_id': nameplateId,
      'nameplate_url': nameplateUrl,
      'nameplate_dynamic': nameplateDynamic,
      'nameplate_type': nameplateType,
      'nameplate_url_v1': nameplateUrlV1,
      'nameplate_dynamic_v1': nameplateDynamicV1,
      'hvisitors': hvisitors,
      'nvisitors': nvisitors,
      'rtime': rtime,
      'hobby': hobby,
      'actor_status': actorStatus,
      'remark': remark,
      'duration': duration,
      'svip_level': svipLevel,
      'svip_score': svipScore,
      'visible': visible,
      'k_star': kStar,
      'singvip_valid': singvipValid,
    };
  }

  String toJson() => json.encode(toMap());
}
