class User {
  int id;
  String name;
  String comment;
  String account;
  String password;
  String mail_address;
  bool is_login;
  bool is_premium;
  bool is_followed;
  int lastTokenTime = -1;
  int x_restrict;
  bool is_mail_authorized;
  bool require_policy_agreement;

  User.fromJsonMap(Map<String, dynamic> map)
      : name = map["name"],
        comment = map["comment"],
        account = map["account"],
        password = map["password"],
        mail_address = map["mail_address"],
        id = map["id"],
        is_login = map["is_login"],
        is_premium = map["is_premium"],
        is_followed = map["is_followed"],
        lastTokenTime = map["lastTokenTime"],
        x_restrict = map["x_restrict"],
        is_mail_authorized = map["is_mail_authorized"],
        require_policy_agreement = map["require_policy_agreement"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['comment'] = comment;
    data['account'] = account;
    data['password'] = password;
    data['mail_address'] = mail_address;
    data['id'] = id;
    data['is_login'] = is_login;
    data['is_premium'] = is_premium;
    data['is_followed'] = is_followed;
    data['lastTokenTime'] = lastTokenTime;
    data['x_restrict'] = x_restrict;
    data['is_mail_authorized'] = is_mail_authorized;
    data['require_policy_agreement'] = require_policy_agreement;
    return data;
  }
}
