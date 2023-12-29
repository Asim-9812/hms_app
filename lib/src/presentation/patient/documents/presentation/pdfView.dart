
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';

import '../../../common/snackbar.dart';


class PDFPatientViewerPage extends StatefulWidget {
  final File file;
  final String title;
  const PDFPatientViewerPage({super.key, required this.file,required this.title});

  @override
  PDFPatientViewerPageState createState() => PDFPatientViewerPageState();
}

class PDFPatientViewerPageState extends State<PDFPatientViewerPage> {
  late PDFViewController controller;
  int pages = 0;
  int indexPage = 0;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final text = '${indexPage + 1} of $pages';

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.black,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(widget.title,style: getMediumStyle(color: ColorManager.white),),
        leading: IconButton(
          onPressed: ()=>Get.back(),
          icon: Icon(Icons.chevron_left,color: ColorManager.white,),
        ),
        actions: pages >= 2
            ? [
          Center(child: Text(text, style: const TextStyle(color: Colors.white),)),
          IconButton(
            icon: Icon(Icons.chevron_left, size: 32.h, color: indexPage > 0 ? Colors.white : Colors.grey,),
            onPressed: indexPage > 0 ? () {
              final page = indexPage - 1;
              controller.setPage(page);
            } : null,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, size: 32.h, color: indexPage < pages - 1 ? Colors.white : Colors.grey,),
            onPressed: indexPage < pages - 1 ? () {
              final page = indexPage + 1;
              controller.setPage(page);
            } : null,
          ),
        ]
            : null,

      ),
      body: PDFView(
        filePath: widget.file.path,
        autoSpacing: false,
        swipeHorizontal: true,
        fitEachPage: true,
        // pageSnap: false,
        // pageFling: true,
        onRender: (pages) => setState(() => this.pages = pages!),
        onViewCreated: (controller) =>
            setState(() => this.controller = controller),
        onPageChanged: (indexPage, _) =>
            setState(() => this.indexPage = indexPage!),
        onError: (error){
          final scaffoldMessage = ScaffoldMessenger.of(context);
          scaffoldMessage.showSnackBar(
              SnackbarUtil.showFailureSnackbar(
                  message: 'Something went wrong',
                  duration: const Duration(milliseconds: 1200)
              )
          );
        },
      ),
    );
  }
}