class Account {
  String token;
  String id;
  String accountName;
  String? accountMobile;
  String? accountType;
  String accountEmail;
  DateTime? accountBirthday;
  String? accountAddress;
  bool isKindergarten;

  Account({
    required this.token,
    required this.id,
    required this.accountName,
    required this.accountMobile,
    required this.accountType,
    required this.accountEmail,
    required this.accountBirthday,
    required this.accountAddress,
    required this.isKindergarten,
  });

  factory Account.fromMap(Map<String, dynamic> json) {
    return Account(
      token: json['token'],
      id: json['_id'],
      accountName: json['account_name'],
      accountMobile: json['account_mobile'],
      accountType: json['account_type'],
      accountEmail: json['account_email'],
      accountBirthday:
          DateTime.parse(json['account_birthday'] ?? DateTime.now().toString()),
      accountAddress: json['account_address'],
      isKindergarten: json['is_kindergarten'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      '_id': id,
      'account_name': accountName,
      'account_mobile': accountMobile,
      'account_type': accountType,
      'account_email': accountEmail,
      'account_birthday': accountBirthday?.toIso8601String(),
      'account_address': accountAddress,
      'is_kindergarten': isKindergarten,
    };
  }
}
