import 'package:secondhome2/provider/accounts_provider.dart';
import 'package:secondhome2/provider/auth_provider.dart';
import 'package:secondhome2/screens/auth/login_page.dart';
import 'package:secondhome2/static_files/my_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../provider/student/provider_student_dashboard.dart';
import '../kindergarten_teacher/teacher_kindergarten_home.dart';
import '../nursery/nursery_home.dart';
import '../nursery_teacher/teacher_nursery_home.dart';
import '../student/home_page_student.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final AccountProvider accountProvider = Get.put(AccountProvider());

  TokenProvider get tokenProvider => Get.put(TokenProvider());

  onCLickAccount(Map<String, dynamic> account) async {
    if (tokenProvider.userData?['account_email'] != account['account_email']) {
      await accountProvider.onClickAccount(account);
      tokenProvider.addToken(account);
      Get.delete<StudentDashboardProvider>();

      if (account['account_type'] == 'student') {
        if (account["is_kindergarten"]) {
          Get.offAll(() => HomePageStudent(userData: account));
        } else {
          Get.offAll(() => HomePageNursery(userData: account));
        }
      } else if (account['account_type'] == 'teacher') {
        if (account["is_kindergarten"]) {
          Get.offAll(() => HomePageKindergartenTeacher(userData: account));
        } else {
          Get.offAll(() => HomePageNurseryTeacher(userData: account));
        }
      }
    }
  }

  @override
  void initState() {
    accountProvider.fetchAccounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: MyColor.pink,
            title: const Text(
              'الحسابات',
              style: TextStyle(color: MyColor.white0),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: MyColor.white0,
            ),
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const LoginPage());
                  },
                  child: const Icon(
                    Icons.add,
                  ),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Obx(() => ListView.builder(
                  shrinkWrap: true,
                  itemCount: accountProvider.accounts.length,
                  padding: const EdgeInsets.all(24),
                  itemBuilder: (context, index) {
                    final account = accountProvider.accounts[index];
                    return GestureDetector(
                        onTap: () => onCLickAccount(
                            accountProvider.accounts[index].toMap()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/img/logo.jpg"),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(account.accountName),
                                  Text(account.accountEmail)
                                ],
                              )),
                              const SizedBox(
                                width: 16,
                              ),
                              if (tokenProvider.userData?['account_email'] !=
                                  account.accountEmail)
                                GestureDetector(
                                  onTap: () => accountProvider
                                      .deleteAccount(account.accountEmail),
                                  child: const Icon(Icons.delete),
                                ),
                              if (tokenProvider.userData?['account_email'] ==
                                  account.accountEmail)
                                const Icon(Icons.star, color: MyColor.pink)
                            ],
                          ),
                        ));
                  }))
            ],
          )),
    );
  }
}
