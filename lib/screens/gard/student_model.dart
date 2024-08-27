class StudentGardModel {
  String? sId;
  String? accountName;
  String? accountMobile;
  bool? isIn;
  bool? isOut;
  String? inCreatedAt;
  String? outCreatedAt;

  StudentGardModel(
      {this.sId,
      this.accountName,
      this.accountMobile,
      this.isIn,
      this.isOut,
      this.inCreatedAt,
      this.outCreatedAt});

  StudentGardModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    accountName = json['account_name'];
    accountMobile = json['account_mobile'];
    isIn = json['is_in'];
    isOut = json['is_out'];
    inCreatedAt = json['in_createdAt'];
    outCreatedAt = json['out_createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['account_name'] = accountName;
    data['account_mobile'] = accountMobile;
    data['is_in'] = isIn;
    data['is_out'] = isOut;
    data['in_createdAt'] = inCreatedAt;
    data['out_createdAt'] = outCreatedAt;
    return data;
  }
}
