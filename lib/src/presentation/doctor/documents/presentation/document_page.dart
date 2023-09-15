

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';

import '../../../../core/resources/value_manager.dart';
import '../add_documents/presentation/add_document_page.dart';
import '../search_documents/presentation/search_document_page.dart';

class DoctorDocumentPage extends StatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  DoctorDocumentPage(this.isWideScreen,this.isNarrowScreen);

  @override
  State<DoctorDocumentPage> createState() => _PatientDocumentPageState();
}

class _PatientDocumentPageState extends State<DoctorDocumentPage> {
  bool isFolderLocked = false;
  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: Duration(milliseconds: 700),
      child: Scaffold(
        backgroundColor: ColorManager.dotGrey.withOpacity(0.4),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: ColorManager.white.withOpacity(0.8),
          elevation: 1,
          title: Text('Documents',style: getMediumStyle(color: ColorManager.black,fontSize: 24),),
          actions: [
            IconButton(
              onPressed: ()=>Get.to(()=>AddDocDoctor(),transition: Transition.rightToLeftWithFade,duration: Duration(milliseconds: 500))
              , icon: FaIcon(Icons.add),color: Colors.blue,),
            IconButton(onPressed: ()=>Get.to(()=>SearchDocDoctor(),transition:Transition.rightToLeftWithFade)
              , icon: FaIcon(Icons.search),color: Colors.blue,),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              h20,
              FadeInUp(
                  duration: Duration(milliseconds: 500),
                  child: myFolders(context)),
              FadeInUp(
                  duration: Duration(milliseconds: 700),
                  child: buildFile(context)),


            ],
          ),
        ),
      ),
    );
  }

/* folder widgets...*/


  /// Folder Container...
  Widget myFolders(BuildContext context){
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;
    print(screenSize);

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My Folders',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
          h20,
          GridView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.isWideScreen? 4: isNarrowScreen?2: 3,
                crossAxisSpacing: widget.isWideScreen?8:8.w,
                mainAxisSpacing: widget.isWideScreen?8: 8.h,
                childAspectRatio: widget.isWideScreen? 14/11:14/10
            ),
            children: [
              buildFolderBody(context,folderName: 'Academics', fileNumbers: 5, onTap: (){},isLocked:isFolderLocked),
              buildFolderBody(context,folderName: 'Certificates', fileNumbers: 2, onTap: (){},isLocked: isFolderLocked),
              buildFolderBody(context,folderName: 'Reports', fileNumbers: 6, onTap: (){},isLocked: isFolderLocked),

            ],
          ),
        ],
      ),
    );
  }


  /// folder ui...
  Widget buildFolderBody(BuildContext context,{
    required String folderName,
    required int fileNumbers,
    required VoidCallback onTap,
    bool? isLocked,
  }) {
    if(isLocked == null){
      isLocked = false;
    }
    return Card(
      elevation: 5,
      shadowColor: ColorManager.dotGrey.withOpacity(0.5),
      color: ColorManager.lightBlueAccent,
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: ColorManager.blue.withOpacity(0.2)
          ),
          borderRadius: BorderRadius.circular(10)
      ),

      child: InkWell(
        onLongPress: ()async{
          _showFolderDialog(context,isFolderLocked);
        },
        onTap: onTap,
        splashColor: ColorManager.blue.withOpacity(0.2),
        splashFactory: InkSplash.splashFactory,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(),
                  InkWell(
                      onTap: () async {
                        print('pressed!!');
                        _showFolderDialog(context,isFolderLocked);
                      },
                      child: FaIcon(Icons.more_horiz,color: ColorManager.blue,size: 18,))


                ],
              ),
              FaIcon(Icons.folder,color: ColorManager.blue.withOpacity(0.8),size: 20,),
              SizedBox(
                height: 5,
              ),
              Text('$folderName',style: getRegularStyle(color: ColorManager.blueText,fontSize: 12),),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$fileNumbers files',style: getRegularStyle(color: ColorManager.blueText.withOpacity(0.5),fontSize: 8),),
                  if(isLocked) FaIcon(CupertinoIcons.lock,color: ColorManager.iconGrey,size: 16,)
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }

  /// folder properties customize...

  Widget _folderCustomize({
    required IconData icon,
    required String name,
    required VoidCallback onTap
  }) {
    return ListTile(
      onTap: onTap,
      leading: FaIcon(icon,color: ColorManager.blue.withOpacity(0.5),),
      title: Text('$name',style: getRegularStyle(color: ColorManager.blueText,fontSize: 16),),
    );
  }

  /// folder menu...
  Future<void> _showFolderDialog(BuildContext context,bool isLocked) {
    return showDialog(
        context: context,
        builder: (context){
          return ZoomIn(
            duration: Duration(milliseconds: 300),
            child: AlertDialog(
              backgroundColor: ColorManager.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text('Menu',style: getMediumStyle(color: ColorManager.blueText),),
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    thickness: 0.5,
                    color: ColorManager.black,
                  ),
                  _folderCustomize(icon: Icons.drive_file_move_rounded, name: 'Move', onTap: (){}),
                  _folderCustomize(icon: Icons.copy_rounded, name: 'Copy', onTap: (){}),
                  _folderCustomize(icon: Icons.delete_outline, name: 'Delete', onTap: (){}),
                  _folderCustomize(icon: isLocked? FontAwesomeIcons.unlock:Icons.lock, name: isLocked? 'Unlock Folder':'Make the folder private',
                      onTap: (){
                        setState(() {
                          isFolderLocked = !isFolderLocked;
                        });
                        Navigator.pop(context);
                      }),

                ],
              ),
            ),
          );
        }
    );
  }

  /* folder widgets finished... */



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
    return ListTile(

      onLongPress: () async {
        _showFileDialog(context);
      },
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
      trailing: IconButton(
        onPressed: () async {
          _showFileDialog(context);
        },
        icon: FaIcon(Icons.more_horiz,color: ColorManager.iconGrey,),
      ),
    );
  }

  /// file menu...
  Future<void> _showFileDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return ZoomIn(
            duration: Duration(milliseconds: 300),
            child: AlertDialog(
              backgroundColor: ColorManager.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text('Menu',style: getMediumStyle(color: ColorManager.blueText),),
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    thickness: 0.5,
                    color: ColorManager.black,
                  ),
                  _folderCustomize(icon: Icons.drive_file_move_rounded, name: 'Move', onTap: (){}),
                  _folderCustomize(icon: Icons.copy_rounded, name: 'Copy', onTap: (){}),
                  _folderCustomize(icon: Icons.delete_outline, name: 'Delete', onTap: (){}),

                ],
              ),
            ),
          );
        }
    );
  }

}
