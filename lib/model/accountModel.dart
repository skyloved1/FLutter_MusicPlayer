class DataModel {
  final int code;
  final Account account;
  final Profile profile;

  DataModel({required this.code, required this.account, required this.profile});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      code: json['code'],
      account: Account.fromJson(json['account']),
      profile: Profile.fromJson(json['profile']),
    );
  }
}

class Account {
  final int id;
  final String userName;
  final int type;
  final int status;
  final int whitelistAuthority;
  final int createTime;
  final int tokenVersion;
  final int ban;
  final int baoyueVersion;
  final int donateVersion;
  final int vipType;
  final bool anonimousUser;
  final bool paidFee;

  Account({
    required this.id,
    required this.userName,
    required this.type,
    required this.status,
    required this.whitelistAuthority,
    required this.createTime,
    required this.tokenVersion,
    required this.ban,
    required this.baoyueVersion,
    required this.donateVersion,
    required this.vipType,
    required this.anonimousUser,
    required this.paidFee,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      userName: json['userName'],
      type: json['type'],
      status: json['status'],
      whitelistAuthority: json['whitelistAuthority'],
      createTime: json['createTime'],
      tokenVersion: json['tokenVersion'],
      ban: json['ban'],
      baoyueVersion: json['baoyueVersion'],
      donateVersion: json['donateVersion'],
      vipType: json['vipType'],
      anonimousUser: json['anonimousUser'],
      paidFee: json['paidFee'],
    );
  }
}

class Profile {
  final int userId;
  final int userType;
  final String nickname;
  final int avatarImgId;
  final String avatarUrl;
  final int backgroundImgId;
  final String backgroundUrl;
  final String signature;
  final int createTime;
  final String userName;
  final int accountType;
  final String shortUserName;
  final int birthday;
  final int authority;
  final int gender;
  final int accountStatus;
  final int province;
  final int city;
  final int authStatus;
  final String? description;
  final String? detailDescription;
  final bool defaultAvatar;
  final List<String>? expertTags;
  final Map<String, dynamic>? experts;
  final int djStatus;
  final int locationStatus;
  final int vipType;
  final bool followed;
  final bool mutual;
  final bool authenticated;
  final int lastLoginTime;
  final String lastLoginIP;
  final String? remarkName;
  final int viptypeVersion;
  final int authenticationTypes;
  final Map<String, dynamic>? avatarDetail;
  final bool anchor;

  Profile({
    required this.userId,
    required this.userType,
    required this.nickname,
    required this.avatarImgId,
    required this.avatarUrl,
    required this.backgroundImgId,
    required this.backgroundUrl,
    required this.signature,
    required this.createTime,
    required this.userName,
    required this.accountType,
    required this.shortUserName,
    required this.birthday,
    required this.authority,
    required this.gender,
    required this.accountStatus,
    required this.province,
    required this.city,
    required this.authStatus,
    this.description,
    this.detailDescription,
    required this.defaultAvatar,
    this.expertTags,
    this.experts,
    required this.djStatus,
    required this.locationStatus,
    required this.vipType,
    required this.followed,
    required this.mutual,
    required this.authenticated,
    required this.lastLoginTime,
    required this.lastLoginIP,
    this.remarkName,
    required this.viptypeVersion,
    required this.authenticationTypes,
    this.avatarDetail,
    required this.anchor,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userId: json['userId'],
      userType: json['userType'],
      nickname: json['nickname'],
      avatarImgId: json['avatarImgId'],
      avatarUrl: json['avatarUrl'],
      backgroundImgId: json['backgroundImgId'],
      backgroundUrl: json['backgroundUrl'],
      signature: json['signature'],
      birthday: json['birthday'],
      authority: json['authority'],
      gender: json['gender'],
      accountStatus: json['accountStatus'],
      province: json['province'],
      city: json['city'],
      authStatus: json['authStatus'],
      description: json['description'],
      detailDescription: json['detailDescription'],
      defaultAvatar: json['defaultAvatar'],
      expertTags: json['expertTags']?.cast<String>(),
      experts: json['experts'],
      djStatus: json['djStatus'],
      locationStatus: json['locationStatus'],
      vipType: json['vipType'],
      followed: json['followed'],
      mutual: json['mutual'],
      authenticated: json['authenticated'],
      lastLoginTime: json['lastLoginTime'],
      lastLoginIP: json['lastLoginIP'],
      remarkName: json['remarkName'],
      viptypeVersion: json['viptypeVersion'],
      authenticationTypes: json['authenticationTypes'],
      avatarDetail: json['avatarDetail'],
      anchor: json['anchor'],
      createTime: json['createTime'],
      userName: json['userName'],
      accountType: json['accountType'],
      shortUserName: json['shortUserName'],
    );
  }
}
