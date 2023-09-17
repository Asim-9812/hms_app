

import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/style_manager.dart';
import '../../../../../core/resources/value_manager.dart';

class AddDocDoctor extends StatefulWidget {
  const AddDocDoctor({super.key});

  @override
  State<AddDocDoctor> createState() => _AddDocumentPageState();
}

class _AddDocumentPageState extends State<AddDocDoctor> {


  @override
  Widget build(BuildContext context) {

    List<Widget> folderLists = [
      buildFolder(),
      buildFolder(),
      buildFolder(),
      buildFolder(),
      buildFolder(),
      buildFolder(),
      buildFolder(),
    ];
    List<Widget> withNewFolder = [...folderLists,buildNewFolder()];


    return FadeInRight(
      duration: Duration(milliseconds: 500),
      child: Scaffold(
        backgroundColor: ColorManager.white.withOpacity(0.9),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ColorManager.white.withOpacity(0.8),
          elevation: 1,
          title: Text('Add Document',style: getMediumStyle(color: ColorManager.black,fontSize: 24),),
          leading: IconButton(
            onPressed: ()=>Get.back(),
            icon: Icon(Icons.chevron_left,color: ColorManager.black,),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              h20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInRight(
                      duration: Duration(milliseconds: 700),
                      child: buildBrowseFile( withNewFolder: withNewFolder)),
                  w16,
                  FadeInRight(
                      duration: Duration(milliseconds: 900),
                      child: buildCreateNewFolder())


                ],
              ),
              h100,
              FadeInRight(
                  duration: Duration(milliseconds: 800),
                  child: buildFile(context))
            ],
          ),
        ),
      ),
    );
  }

  /* upload files ui ...*/

  Widget buildBrowseFile( {
    required List<Widget> withNewFolder,
  }) {
    return DottedBorder(
      dashPattern: [8, 3, 8, 3],
      color: ColorManager.blueText,
      borderType: BorderType.RRect,
      radius: Radius.circular(12),
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: ()async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.custom,
            allowedExtensions: ['jpg', 'pdf', 'doc','docx','png','jpeg','xlsx'],
          );

          if (result != null) {
            List<PlatformFile> fileList = result.files;



            for(var i=0; i<fileList.length; i++){
              (fileList[i].name);
              (fileList[i].bytes);
              (fileList[i].size);
              (fileList[i].extension);
              (fileList[i].path);
            }
            _showDialogSaveFolder(withNewFolder: withNewFolder);

          } else {
            // User canceled the picker
          }
        },
        splashColor: ColorManager.primary.withOpacity(0.5),
        child: Container(
          height: 150.h,
          width: 180.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FaIcon(CupertinoIcons.arrow_down_doc,color: ColorManager.blueText,size: 40,),
              h10,
              Text('Browse for files',style: getMediumStyle(color: ColorManager.blueText,fontSize: 18),),
              h10,
              Text('Maximum file size 2.5mb',style: getRegularStyle(color: ColorManager.textGrey,fontSize: 14),)
            ],
          ),
        ),
      ),
    );
  }


  Widget buildFolder() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
      height: 100.h,
      width: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorManager.blueText
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(CupertinoIcons.folder_solid,size: 40,color: ColorManager.blueText,),
          Text('Academics',style: getRegularStyle(color: ColorManager.blueText,fontSize: 14),)
        ],
      ),
    );
  }


  Widget buildNewFolder() {
    return DottedBorder(
      dashPattern: [8, 3, 8, 3],
      color: ColorManager.blueText,
      borderType: BorderType.RRect,
      radius: Radius.circular(12),
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
        height: 100.h,
        width: 100.w,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(Icons.add,size: 40,color: ColorManager.blueText,),
            Text('Create a new folder',style: getRegularStyle(color: ColorManager.blueText,fontSize: 14),textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
  
  Widget gridViewFolders({
    required List<Widget> withNewFolder
  }){
    
    return Container(
      height: 400.h,
      width: 360.w,
      child: GridView.builder(
        itemCount: withNewFolder.length,
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 1/1
        ),
        shrinkWrap: true,
        itemBuilder: (context, int index) {
          return withNewFolder[index];
        },

      ),
    );
    
  }


  Future<void> _showDialogSaveFolder( {
    required List<Widget> withNewFolder
}) {
    return showDialog(
        context: context,
        builder: (context){
          return ZoomIn(
            duration: Duration(milliseconds: 500),
            child: AlertDialog(
              backgroundColor: ColorManager.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text('Save to...',style: getMediumStyle(color: ColorManager.blueText),),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.w),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    thickness: 0.5,
                    color: ColorManager.black,
                  ),
                  gridViewFolders( withNewFolder: withNewFolder)
                ],
              ),
              actions: [
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: ColorManager.white
                    ),
                    onPressed: ()=>Navigator.pop(context),
                    child: Text('Cancel',style: getRegularStyle(color: ColorManager.blueText,fontSize: 16),)
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: ColorManager.blueText.withOpacity(0.7)
                    ),
                    onPressed: ()=>Navigator.pop(context),
                    child: Text('Select',style: getRegularStyle(color: ColorManager.white,fontSize: 16),)
                )
              ],
            ),
          );
        }
    );
  }

  /* upload files ui finished... */

  /* Create new files */

  Widget buildCreateNewFolder() {
    return InkWell(
      onTap: () async {
        showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                backgroundColor: ColorManager.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text('Create a new folder',style: getMediumStyle(color: ColorManager.blueText,fontSize: 20),),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.w),
                content: TextFormField(
                  style: getRegularStyle(color: ColorManager.black,fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Enter Folder Name',
                    hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: ColorManager.black.withOpacity(0.5),
                        width: 0.5
                      )
                    )
                  ),
                ),
                actions: [
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: ColorManager.white
                      ),
                      onPressed: ()=>Navigator.pop(context),
                      child: Text('Cancel',style: getRegularStyle(color: ColorManager.blueText,fontSize: 16),)
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: ColorManager.blueText.withOpacity(0.7)
                      ),
                      onPressed: ()=>Navigator.pop(context),
                      child: Text('Submit',style: getRegularStyle(color: ColorManager.white,fontSize: 16),)
                  )
                ],
              );
            }
        );
      },
      splashColor: ColorManager.primary,
      child: Container(
        height: 150.h,
        width: 180.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorManager.blue.withOpacity(0.8)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(CupertinoIcons.folder_fill_badge_plus,size: 45,color: ColorManager.white,),
            Text('Create new folder',style: getMediumStyle(color: ColorManager.white,fontSize: 18),)
          ],
        ),
      ),
    );
  }

  Widget buildFile(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),

          children: [
            Text('Uploaded File',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
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
        onPressed: () async { },
        icon: FaIcon(Icons.delete_outline,color: ColorManager.iconGrey,),
      ),
    );
  }




}
