class ContentModel {
  final int id;
  final int topicID;
  final int contentID;
  final int contentCheck;
  final String contentName;
  final String contentFile;
  final String wordDescription;
  final String pictureBackground;
  final String optimizeLink;
  final String? thumbnail;
  final String pdfFile;
  final bool favFlag;
  final int isUserGroup;
  final bool allowDownload;
  final List<dynamic>? articlePermissionList;
  final List<dynamic>? articlePermissionListGroupList;
  final int timesPerDayID;
  final int watchedTimes;
  final int times;
  final DateTime? perDay;
  final String? currentMinutes;
  final String? progressTime;
  final bool isComplete;
  final DateTime createDate;
  final DateTime startContentDate;
  final DateTime endContentDate;
  final bool? requestFlag;
  final String link;
  final String? pdfUrl;
  final int? sort;
  final bool allView;
  final bool viewerFlag;
  final bool delayFlag;
  final String memberID;

  ContentModel({
    required this.id,
    required this.topicID,
    required this.contentID,
    required this.contentCheck,
    required this.contentName,
    required this.contentFile,
    required this.wordDescription,
    required this.pictureBackground,
    required this.optimizeLink,
    this.thumbnail,
    required this.pdfFile,
    required this.favFlag,
    required this.isUserGroup,
    required this.allowDownload,
    this.articlePermissionList,
    this.articlePermissionListGroupList,
    required this.timesPerDayID,
    required this.watchedTimes,
    required this.times,
    required this.perDay,
    this.currentMinutes,
    required this.progressTime,
    required this.isComplete,
    required this.createDate,
    required this.startContentDate,
    required this.endContentDate,
    required this.requestFlag,
    required this.link,
    this.pdfUrl,
    this.sort,
    required this.allView,
    required this.viewerFlag,
    required this.delayFlag,
    required this.memberID,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      topicID: json['topic_ID'],
      contentID: json['content_ID'],
      contentCheck: json['contentCheck'],
      contentName: json['content_Name'],
      contentFile: json['content_File'],
      wordDescription: json['wordDescription'],
      pictureBackground: json['pictureBackground'],
      optimizeLink: json['optimizeLink'],
      thumbnail: json['thumbnail'],
      pdfFile: json['pdfFile'],
      favFlag: json['favFlag'],
      isUserGroup: json['isUserGroup'],
      allowDownload: json['allowDownload'],
      articlePermissionList: json['articlePermissionList'],
      articlePermissionListGroupList: json['articlePermissionListGroupList'],
      timesPerDayID: json['timesPerDayID'],
      watchedTimes: json['watchedTimes'],
      times: json['times'],
      perDay: json['perDay'] != null ? DateTime.parse(json['perDay']) : null,
      currentMinutes: json['currentminutes'],
      progressTime: json['progressTime'],
      isComplete: json['isComplete'],
      createDate: DateTime.parse(json['createDate']),
      startContentDate: DateTime.parse(json['startContentDate']),
      endContentDate: DateTime.parse(json['endContentDate']),
      requestFlag: json['requestFlag'] != null ?? null,
      link: json['link'],
      pdfUrl: json['pdfUrl'],
      sort: json['sort'],
      allView: json['allView'],
      viewerFlag: json['viewerFlag'],
      delayFlag: json['delayFlag'],
      memberID: json['memberID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic_ID': topicID,
      'content_ID': contentID,
      'contentCheck': contentCheck,
      'content_Name': contentName,
      'content_File': contentFile,
      'wordDescription': wordDescription,
      'pictureBackground': pictureBackground,
      'optimizeLink': optimizeLink,
      'thumbnail': thumbnail,
      'pdfFile': pdfFile,
      'favFlag': favFlag,
      'isUserGroup': isUserGroup,
      'allowDownload': allowDownload,
      'articlePermissionList': articlePermissionList,
      'articlePermissionListGroupList': articlePermissionListGroupList,
      'timesPerDayID': timesPerDayID,
      'watchedTimes': watchedTimes,
      'times': times,
      'perDay': perDay?.toIso8601String(),
      'currentminutes': currentMinutes,
      'progressTime': progressTime,
      'isComplete': isComplete,
      'createDate': createDate.toIso8601String(),
      'startContentDate': startContentDate.toIso8601String(),
      'endContentDate': endContentDate.toIso8601String(),
      'requestFlag': requestFlag,
      'link': link,
      'pdfUrl': pdfUrl,
      'sort': sort,
      'allView': allView,
      'viewerFlag': viewerFlag,
      'delayFlag': delayFlag,
      'memberID': memberID,
    };
  }

  Map<String, dynamic> toAddPayload() {
    //return add upload
    return {'id': ''};
  }

  Map<String, dynamic> toUpdatePayload() {
    //return update upload
    return {'id': ''};
  }

  //add more relevant methods for this model
}
