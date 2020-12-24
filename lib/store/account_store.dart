import 'package:pixiv/model/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountStore {
  AccountProvider accountProvider = new AccountProvider();
  AccountPersist now;
  int index = 0;

  List<AccountPersist> accounts = new List<AccountPersist>();

  select(int index) async {
    var pre = await SharedPreferences.getInstance();
    await pre.setInt('account_select_num', index);
    now = accounts[index];
    this.index = index;
  }

  deleteAll() async {
    await accountProvider.open();
    await accountProvider.deleteAll();
    now = null;
  }

  updateSingle(AccountPersist accountPersist) async {
    await accountProvider.open();
    await accountProvider.update(accountPersist);
    await fetch();
  }

  deleteSingle(int id) async {
    await accountProvider.open();
    await accountProvider.delete(id);
    await fetch();
  }

  fetch() async {
    await accountProvider.open();
    List<AccountPersist> list = await accountProvider.getAllAccount();
    accounts.clear();
    accounts.addAll(list);
    var pre = await SharedPreferences.getInstance();
    var i = pre.getInt('account_select_num');
    if (list != null && list.isNotEmpty) {
      index = i ?? 0;
      now = list[i ?? 0];
    }
  }
}
