


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';




class SearchDocuments extends StatefulWidget {
  const SearchDocuments({super.key});

  @override
  State<SearchDocuments> createState() => _SearchDocumentsState();
}

class _SearchDocumentsState extends State<SearchDocuments> {



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.white.withOpacity(0.9),
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: true,
          backgroundColor: ColorManager.white.withOpacity(0.8),
          elevation: 1,

          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: ()=>Get.back(),
                child: Icon(Icons.chevron_left,color: ColorManager.black,),
              ),
              Container(
                height: 50.h,
                width: 320.w,

                child: TextFormField(
                  autofocus: true,
                  style: getRegularStyle(color: ColorManager.black,fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: 18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorManager.black.withOpacity(0.5),
                            width: 0.5
                        )
                    ),

                  ),
                ),
              ),
              InkWell(
                onTap: (){},
                child: FaIcon(Icons.filter_list,color: ColorManager.black,),
              )
            ],
          ) ,
          automaticallyImplyLeading: false,

        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              h100,
              Center(child: Text('Searhed files...',style:getRegularStyle(color: ColorManager.textGrey))),
              h100,
              buildFile(context)
            ],
          ),
        ),
      ),
    );
  }

  /* file widgets...*/

  Widget buildFile(BuildContext context) {
    return Container(
      
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),

          children: [
            Text('Recent Files',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
            Divider(
              thickness: 0.5,
              color: ColorManager.black.withOpacity(0.8),
            ),
            _fileTile(context, fileName: 'File.docx', onTap: (){}, dateTime: DateTime.now()),
            _fileTile(context, fileName: 'Image.jpg', onTap: (){}, dateTime: DateTime.now()),
            _fileTile(context, fileName: 'File 2.docx', onTap: (){}, dateTime: DateTime.now()),
            _fileTile(context, fileName: 'File 2.docx', onTap: (){}, dateTime: DateTime.now()),
            h100,

          ],
        ));
  }


  ///file ui...

  Widget _fileTile (BuildContext context,{
    required String fileName,
    required VoidCallback onTap,
    required DateTime dateTime,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        leading: Card(
          color: ColorManager.lightBlueAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),

          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
              child: FaIcon(FontAwesomeIcons.fileLines,color: ColorManager.blueText.withOpacity(0.5),)),
        ),
        title: Text('$fileName',style: getRegularStyle(color: ColorManager.black),),
        subtitle: Text('${DateFormat('dd/MM/yyyy hh:mm a').format(dateTime)}',style: getRegularStyle(color: ColorManager.textGrey,fontSize: 10),),
      ),
    );
  }





}
