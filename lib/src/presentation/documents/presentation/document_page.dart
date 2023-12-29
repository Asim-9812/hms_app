

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/presentation/documents/domain/services/document_services.dart';
import 'package:meroupachar/src/presentation/documents/presentation/folder_page.dart';
import 'package:meroupachar/src/presentation/documents/presentation/pdfView.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/api.dart';
import '../../../core/pdf_api.dart';
import '../../../core/resources/value_manager.dart';
import '../../common/snackbar.dart';
import '../../login/domain/model/user.dart';
import '../add_documents/presentation/add_document_page.dart';
import '../domain/model/document_model.dart';
import '../search_documents/presentation/search_document_page.dart';

class DocumentPage extends ConsumerStatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  final bool back;
  DocumentPage(this.isWideScreen,this.isNarrowScreen,this.back);

  @override
  ConsumerState<DocumentPage> createState() => _PatientDocumentPageState();
}

class _PatientDocumentPageState extends ConsumerState<DocumentPage> {
  bool isFolderLocked = false;
  List<DocumentModel> docList = [];
  int? pages;
  bool? isReady;



  _launchURL(String url) async {
    final scaffoldMessage = ScaffoldMessenger.of(context);
    try {
      if (!url.startsWith('https://') && !url.startsWith('http://')) {
        url = 'https://$url'; // prepend 'https://' if not present
      }

      await launchUrlString(url,mode: LaunchMode.externalApplication);
    } catch (e) {
      // If launching with 'https://' fails, try with 'http://'
      if (!url.startsWith('http://')) {
        url = 'http://$url';
        await launchUrlString(url,mode: LaunchMode.externalApplication);
      } else {
        scaffoldMessage.showSnackBar(
            SnackbarUtil.showFailureSnackbar(
                message: 'Invalid Url',
                duration: const Duration(milliseconds: 1200)
            )
        );
        print('Error launching URL: $e');
      }
    }
  }





  @override
  Widget build(BuildContext context) {

    return FadeIn(
      duration: Duration(milliseconds: 700),
      child: Scaffold(
        backgroundColor: ColorManager.white.withOpacity(0.9),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: ColorManager.primary,
          elevation: 1,
          title: Text('Documents',style: getMediumStyle(color: ColorManager.white,fontSize: 20),),
          leading: widget.back ? IconButton(
            onPressed: ()=>Get.back()
            , icon: FaIcon(Icons.chevron_left,size: 20,),color: ColorManager.white,) : null,
          actions: [
            IconButton(
              onPressed: ()=>Get.to(()=>AddDocuments(),transition: Transition.rightToLeftWithFade,duration: Duration(milliseconds: 500))
              , icon: FaIcon(CupertinoIcons.add_circled,size: 28,),color: ColorManager.white,),
            IconButton(onPressed: ()=>Get.to(()=>SearchDocuments(),transition:Transition.rightToLeftWithFade)
              , icon: FaIcon(Icons.search),color: ColorManager.white,),
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
              h20,
              h20,
              FadeInUp(
                  duration: Duration(milliseconds: 800),
                  child: buildLinks(context)),
              h100


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
    (screenSize);

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;
    final userBox = Hive.box<User>('session').values.toList();
    final docId = userBox[0].userID;
    final folderList = ref.watch(folderProvider(docId!));
    final documentList = ref.watch(documentProvider(docId));


    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text('My Folders',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
          // h20,
          folderList.when(
              data: (data){
                if(data.isEmpty ){
                  return Column(

                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Files',style: getMediumStyle(color: ColorManager.black,fontSize: 20),)),
                      Divider(
                        thickness: 0.5,
                        color: ColorManager.black.withOpacity(0.8),
                      ),
                      Center(child: Text('No files',style:getRegularStyle(color: ColorManager.black,fontSize: 20))),
                    ],
                  );
                }
                else{
                  return documentList.when(
                      data: (documents){
                        return GridView.builder(
                          itemCount: data.length,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: widget.isWideScreen? 4: isNarrowScreen?2: 3,
                              crossAxisSpacing: widget.isWideScreen?8:8.w,
                              mainAxisSpacing: widget.isWideScreen?8: 8.h,
                              childAspectRatio: widget.isWideScreen? 14/11:14/10
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final numberOfDocs = documents.where((doc) => doc.folderName == data[index].folderName).length;
                            return buildFolderBody(
                                context,
                                folderName: data[index].folderName,
                                fileNumbers: numberOfDocs,
                                onTap: (){
                                  final list = documents.where((element) => element.folderName == data[index].folderName ).toList();
                                  Get.to(()=>FolderPage(docId: docId, folderName: data[index].folderName, files: list));
                                });
                          },

                        );
                      },
                      error: (error,stack)=>Center(child: Text('File: $error')),
                      loading: ()=>SizedBox()
                  );

                }
              },
              error: (error,stack)=>Center(child: Text('$error'),),
              loading: ()=>Center(child: SpinKitDualRing(color: ColorManager.primary,lineWidth: 20),)
          ),
          h20,
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
      elevation: 0,
      shadowColor: ColorManager.dotGrey.withOpacity(0.5),
      color: ColorManager.lightBlueAccent.withOpacity(0.3),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: ColorManager.primary.withOpacity(0.2)
          ),
          borderRadius: BorderRadius.circular(10)
      ),

      child: InkWell(
        onLongPress: ()async{
          _showFolderDialog(context,isFolderLocked);
        },
        onTap: onTap,
        splashColor: ColorManager.primary.withOpacity(0.2),
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
                        ('pressed!!');
                        _showFolderDialog(context,isFolderLocked);
                      },
                      child: FaIcon(Icons.more_horiz,color: ColorManager.primary,size: 18,))


                ],
              ),
              FaIcon(Icons.folder,color: ColorManager.primary.withOpacity(0.8),size: 20,),
              SizedBox(
                height: 5,
              ),
              Text('$folderName',style: getRegularStyle(color: ColorManager.primary,fontSize: 12),),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$fileNumbers files',style: getRegularStyle(color: ColorManager.primary.withOpacity(0.5),fontSize: 8),),
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
      leading: FaIcon(icon,color: ColorManager.primary.withOpacity(0.5),),
      title: Text('$name',style: getRegularStyle(color: ColorManager.primary,fontSize: 16),),
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
              title: Text('Menu',style: getMediumStyle(color: ColorManager.primary),),
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

  /* folder widgets finished... */



  /* file widgets...*/

  Widget buildFile(BuildContext context) {
    final userBox = Hive.box<User>('session').values.toList();
    final docId = userBox[0].userID;
    final documentList = ref.watch(documentProvider(docId!));
    return documentList.when(
        data: (data){
          if(data.isEmpty){
            return SizedBox();
          }
          else{
            final reversedList = data.reversed.toList();
            return Padding(
              padding:EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Files',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                  Divider(
                    thickness: 0.5,
                    color: ColorManager.black.withOpacity(0.8),
                  ),
                  ListView.builder(
                    itemCount: reversedList.length > 5 ? 5 : reversedList.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return _fileTile(context,
                        docId: docId,
                        documentId:reversedList[index].documentID! ,
                        typeId: reversedList[index].documentTypeID!,
                        fileName: reversedList[index].documentTitle!,
                        description: reversedList[index].documentDescription?? 'No description',
                        onTap: ()async{
                          if(reversedList[index].documentTypeID == 2){
                            final image = Image.network('${Api.baseUrl}/${reversedList[index].doctorAttachment}').image;
                            showImageViewer(context, image, onViewerDismissed: () {
                              print("dismissed");
                            });
                          }
                          else{
                            final String path = '${Api.baseUrl}/${reversedList[index].doctorAttachment}';
                            final file = await PDFApi.loadNetwork(path);
                            Get.to(()=>PDFViewerPage(file: file,title:reversedList[index].documentTitle! ,));

                          }
                        },
                      );
                    },

                  ),
                ],
              ),
            );
          }
        },
        error: (error,stack)=>Center(child: Text('$error'),),
        loading: ()=>SizedBox()
    );



  }


  Widget buildLinks(BuildContext context) {
    final userBox = Hive.box<User>('session').values.toList();
    final docId = userBox[0].userID;
    final documentList = ref.watch(linkProvider(docId!));
    return documentList.when(
        data: (data){
          if(data.isEmpty){
            return SizedBox();
          }
          else{
            final reversedList = data.reversed.toList();
            return Padding(
              padding:EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Links',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                  Divider(
                    thickness: 0.5,
                    color: ColorManager.black.withOpacity(0.8),
                  ),
                  ListView.builder(
                    itemCount: reversedList.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return _linkTile(context,
                        docId: docId,
                        documentId:reversedList[index].documentID! ,
                        typeId: reversedList[index].documentTypeID!,
                        fileName: reversedList[index].documentTitle!,
                        description: reversedList[index].documentDescription?? 'No description',
                        onTap: ()async{
                          String url = reversedList[index].doctorAttachment!;

                          _launchURL(url);
                        },
                      );
                    },

                  ),
                ],
              ),
            );
          }
        },
        error: (error,stack)=>Center(child: Text('$error'),),
        loading: ()=>SizedBox()
    );



  }


  ///file ui...

  Widget _fileTile (BuildContext context,{
    required String fileName,
    required VoidCallback onTap,
    required String description,
    required int typeId,
    required int documentId,
    required String docId,
  }) {
    return ListTile(

      onLongPress: () async {
        _showFileDialog(context,documentId.toString(),docId);
      },
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Card(
        color: ColorManager.lightBlueAccent.withOpacity(0.3),
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),

        child: Container(
            padding: EdgeInsets.symmetric(horizontal: typeId == 2 ? 12.w:18.w,vertical: 12.h),
            child: FaIcon(typeId == 2 ? FontAwesomeIcons.images:FontAwesomeIcons.fileLines,color: ColorManager.primary.withOpacity(0.5),)),
      ),
      title: Text('$fileName',style: getRegularStyle(color: ColorManager.black),),
      subtitle: Text('${description}',style: getRegularStyle(color: ColorManager.textGrey,fontSize: 10),),
      trailing: IconButton(
        onPressed: () async {
          _showFileDialog(context,documentId.toString(),docId);
        },
        icon: FaIcon(Icons.more_horiz,color: ColorManager.iconGrey,),
      ),
    );
  }



  ///link ui...

  Widget _linkTile (BuildContext context,{
    required String fileName,
    required VoidCallback onTap,
    required String description,
    required int typeId,
    required int documentId,
    required String docId,
  }) {
    return ListTile(

      onLongPress: () async {
        _showFileDialog(context,documentId.toString(),docId);
      },
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Card(
        color: ColorManager.lightBlueAccent.withOpacity(0.3),
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),

        child: Container(
            padding: EdgeInsets.symmetric(horizontal: typeId == 2 ? 12.w:18.w,vertical: 12.h),
            child: FaIcon(CupertinoIcons.globe,color: ColorManager.primary.withOpacity(0.5),)),
      ),
      title: Text('$fileName',style: getRegularStyle(color: ColorManager.black),),
      subtitle: Text('${description}',style: getRegularStyle(color: ColorManager.textGrey,fontSize: 10),),
      trailing: IconButton(
        onPressed: () async {
          _showFileDialog(context,documentId.toString(),docId);
        },
        icon: FaIcon(Icons.more_horiz,color: ColorManager.iconGrey,),
      ),
    );
  }


  /// file menu...
  Future<void> _showFileDialog(BuildContext context,String documentId,String docId) {
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
              title: Text('Menu',style: getMediumStyle(color: ColorManager.primary),),
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    thickness: 0.5,
                    color: ColorManager.black,
                  ),
                  _folderCustomize(icon: Icons.delete_outline, name: 'Delete',
                      onTap: ()async{
                        final scaffoldMessage = ScaffoldMessenger.of(context);
                    final response = await DoctorDocumentServices().delDocument(documentId: documentId);
                    if(response.isLeft()){
                      final left = response.fold(
                              (l) => l,
                              (r) => null
                      );
                      scaffoldMessage.showSnackBar(
                          SnackbarUtil.showFailureSnackbar(
                              message: '$left',
                              duration: const Duration(milliseconds: 1200)
                          )
                      );
                      Navigator.pop(context);
                    }
                    else{
                        print('successful');

                        scaffoldMessage.showSnackBar(
                            SnackbarUtil.showSuccessSnackbar(
                                message: 'Successful',
                                duration: const Duration(milliseconds: 1200)
                            )
                        );
                        ref.refresh(documentProvider(docId));
                        ref.refresh(folderProvider(docId));
                        ref.refresh(linkProvider(docId));
                        Navigator.pop(context);

                    }
                      }
                  ),

                ],
              ),
            ),
          );
        }
    );
  }

}
