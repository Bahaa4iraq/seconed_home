import 'package:secondhome2/local_database/models/account.dart';
import 'package:secondhome2/local_database/sql_database.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AccountProvider extends GetxController {
  RxList<Account> accounts = <Account>[].obs;

  @override
  void onInit() {
    accounts.value = [];
    fetchAccounts();
    super.onInit();
  }

  Future fetchAccounts() async {
    final updatedAccounts = await SqlDatabase.db.getAllAccount();
    accounts.value = updatedAccounts;
    return;
  }

  Future deleteAccount(String email) async {
    await SqlDatabase.db.deleteAccount(email);
    return await fetchAccounts();
  }

  Future onClickAccount(res) async {
    final box = GetStorage();
    box.erase();
    await box.write('_userData', res);
  }
}
