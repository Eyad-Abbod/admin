import 'dart:convert';

import 'package:aldeerh_admin/admin/operations/add.dart';
import 'package:aldeerh_admin/admin/operations/add_congrat.dart';
import 'package:aldeerh_admin/admin/operations/ads_news.dart';
import 'package:aldeerh_admin/admin/operations/comments_admin.dart';
import 'package:aldeerh_admin/admin/operations/familes.dart';
import 'package:aldeerh_admin/admin/operations/news_screen.dart';
import 'package:aldeerh_admin/admin/operations/persons.dart';
import 'package:aldeerh_admin/admin/operations/shared.dart';
import 'package:aldeerh_admin/admin/operations/users/users_all.dart';
import 'package:aldeerh_admin/admin/operations/view_suggestion.dart';
import 'package:aldeerh_admin/screens/home_screen.dart';
import 'package:aldeerh_admin/screens/search_news.dart';
import 'package:aldeerh_admin/utilities/app_theme.dart';
import 'package:aldeerh_admin/utilities/crud.dart';
import 'package:aldeerh_admin/utilities/link_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String a = '';
  bool isLoadRunning = false;
  int visiter = 0;
  int visiterRecorde = 0;
  int visiterUnRecorde = 0;

  @override
  void initState() {
    visitedToDay();
    super.initState();
  }

  final Curd curd = Curd();

  List<String> seenList = [];
  visitedToDay() async {
    if (mounted) {
      setState(() {
        isLoadRunning = true;
      });
    }
    try {
      final res = await http.get(Uri.parse(linkVisitedToDay));

      if (mounted) {
        setState(() {
          a = json.decode(res.body);

          List aa = a.split(',');
          for (var i = 0; i < aa.length; i++) {
            if (aa[i].substring(0, 1) == '0') {
              visiterUnRecorde = visiterUnRecorde + 1;
            } else {
              visiterRecorde = visiterRecorde + 1;
            }
            visiter = visiter + 1;
          }

          isLoadRunning = false;
        });
      }
    } catch (e) {
      // _isConnected = false;
      if (mounted) {
        setState(() {
          isLoadRunning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text("لوحة التحكم"),
        actions: [
          IconButton(
            onPressed: () {
              // showSearch(context: context, delegate: SearchUser());
              Get.to(() => const SearchNews(
                    isAdmin: 6,
                  ));
            },
            icon: const Icon(Icons.search_sharp),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Get.offAll(() => const HomeScreen()),
          backgroundColor: AppTheme.appTheme.primaryColor,
          child: const Text('عودة')),
      body: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        // child: Text('data'),
        child: SizedBox(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 1,
            children: [
              Card(
                color: Colors.greenAccent,
                elevation: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person,
                      size: 30,
                    ),
                    isLoadRunning
                        ? const Center(child: CupertinoActivityIndicator())
                        : Text('الزائرين اليوم: $visiter',
                            style: const TextStyle(fontSize: 20)),
                    isLoadRunning
                        ? const Center(child: CupertinoActivityIndicator())
                        : Text('المسجلين: $visiterRecorde'),
                    isLoadRunning
                        ? const Center(child: CupertinoActivityIndicator())
                        : Text('الغير مسجلين: $visiterUnRecorde')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          children: [
            InkWell(
              onTap: () => Get.to(() => const NewsScreen()),
              child: const Card(
                elevation: 2,
                color: Colors.deepPurpleAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.newspaper),
                    Text(
                      'الأخبار',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () => Get.to(() => const PersonsAdminScreen()),
              child: Card(
                elevation: 2,
                color: Colors.amberAccent.shade700,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.newspaper),
                    Text(
                      'شخصيات',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () => Get.to(() => const SharedAdminScreen()),
              child: const Card(
                elevation: 2,
                color: Colors.cyan,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.newspaper),
                    Text(
                      'خواطر',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () => Get.to(() => const FamiliesAdminScreen()),
              child: const Card(
                elevation: 2,
                color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.newspaper),
                    Text(
                      'أسر منتجة',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // InkWell(
            //   onTap: () => Get.to(() => const NewsStateScreen()),
            //   child: Card(
            //     elevation: 2,
            //     color: Colors.amber,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: const [
            //         Icon(Icons.newspaper),
            //         Text('الشخصيات'),
            //       ],
            //     ),
            //   ),
            // ),
            // InkWell(
            //   onTap: () => Get.to(() => const NewsStateScreen()),
            //   child: Card(
            //     elevation: 2,
            //     color: Colors.green,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: const [
            //         Icon(Icons.newspaper),
            //         Text('المشاركات'),
            //       ],
            //     ),
            //   ),
            // ),
            InkWell(
              onTap: () => Get.to(() => const AdsNewsAdminScreen()),
              child: const Card(
                elevation: 2,
                color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.newspaper),
                    Text(
                      'إعلانات',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => Get.to(() => const ViewSuggestion()),
              child: Card(
                color: Colors.green.shade400,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.newspaper),
                    Text(
                      'المقترحات',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // Card(
            //   color: Colors.red.shade400,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: const [
            //       Icon(Icons.person),
            //       Text('الإدارة'),
            //     ],
            //   ),
            // ),
            InkWell(
              onTap: () => Get.to(() => const CommentsAdmin()),
              child: Card(
                elevation: 2,
                color: Colors.red.shade400,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.comment),
                    Text(
                      'التعليقات',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () => Get.to(() => const Users()),
              child: Card(
                elevation: 2,
                color: Colors.purple.shade400,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_box_outlined),
                    Text(
                      'المستخدمين',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () => Get.to(() => const AddNewsAdmin()),
              child: Card(
                elevation: 2,
                color: Colors.blue.shade400,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_box_outlined),
                    Text(
                      'إضافة خبر',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => Get.to(() => const AddCongrats()),
              child: Card(
                elevation: 2,
                color: Colors.red.shade400,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_box_outlined),
                    Text(
                      'رسالة عامة',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Card(
            //   color: Colors.lightGreenAccent,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: const [
            //       Icon(Icons.newspaper),
            //       Text('المستخدمين'),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
