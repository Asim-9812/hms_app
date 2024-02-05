import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/presentation/notices/domain/services/notice_services.dart';
import '../../../core/resources/value_manager.dart';
import 'notfication_general.dart';
import 'notification_personal.dart';

class NotificationPage extends ConsumerStatefulWidget {
  final String code;
  final String token;
  NotificationPage({required this.code,required this.token});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final params = Tuple2(widget.code, widget.token);
    final noticeList = ref.watch(getNoticeList(params));
    return Scaffold(
      backgroundColor: ColorManager.white.withOpacity(0.98),
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: FaIcon(Icons.chevron_left, color: ColorManager.white),
        ),
        centerTitle: true,
        title: Text(
          'Notifications',
          style: getMediumStyle(color: ColorManager.white),
        ),
        actions: [
          IconButton(
              onPressed: (){
                ref.refresh(getNoticeList(params));
              },
              icon: FaIcon(Icons.refresh,color: ColorManager.white,))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          h20,
          Center(
            child: Container(
              height: 70.w,
              width: 390.h,
              decoration: BoxDecoration(
                color: ColorManager.dotGrey.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TabBar(
                controller: _tabController,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                labelStyle: getMediumStyle(
                  color: ColorManager.white,
                  fontSize: 18,
                ),
                unselectedLabelStyle: getMediumStyle(
                  color: ColorManager.textGrey,
                  fontSize: 18,
                ),
                isScrollable: false,
                labelPadding: EdgeInsets.only(left: 15.w, right: 15.w),
                labelColor: ColorManager.white,
                unselectedLabelColor: ColorManager.textGrey,
                indicator: BoxDecoration(
                  color: ColorManager.primary,
                  borderRadius: BorderRadius.circular(15),
                ),
                tabs: [
                  Container(
                    width: double.infinity,
                    child: Tab(
                      text: 'General',
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Tab(text: 'Personal'),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 3.9 / 5,
            child: noticeList.when(
              data: (data) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    General(notificationList: data),
                    Personal(
                        notificationList: data
                            .where((element) => element.noticeType == 3)
                            .toList()),
                  ],
                );
              },
              error: (error, stack) => TabBarView(
                controller: _tabController,
                children: [
                  Text('$error'),
                  Text('$error'),
                ],
              ),
              loading: () => TabBarView(
                controller: _tabController,
                children: [
                  Center(child: SpinKitDualRing(color: ColorManager.primary)),
                  Center(child: SpinKitDualRing(color: ColorManager.primary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
