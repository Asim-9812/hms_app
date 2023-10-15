

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/presentation/doctor/documents/domain/services/document_services.dart';
import 'package:medical_app/src/presentation/doctor/documents/presentation/folder_page.dart';
import 'package:medical_app/src/presentation/doctor/documents/presentation/pdfView.dart';

import '../../../../core/api.dart';
import '../../../../core/pdf_api.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../common/snackbar.dart';
import '../../../login/domain/model/user.dart';
import '../add_documents/presentation/add_document_page.dart';
import '../domain/model/document_model.dart';
import '../search_documents/presentation/search_document_page.dart';

class DocumentPage extends ConsumerStatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  DocumentPage(this.isWideScreen,this.isNarrowScreen);

  @override
  ConsumerState<DocumentPage> createState() => _PatientDocumentPageState();
}

class _PatientDocumentPageState extends ConsumerState<DocumentPage> {
  bool isFolderLocked = false;
  List<DocumentModel> docList = [];
  int? pages;
  bool? isReady;




  @override
  Widget build(BuildContext context) {

    return FadeIn(
      duration: Duration(milliseconds: 700),
      child: Scaffold(
        backgroundColor: ColorManager.dotGrey.withOpacity(0.4),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: ColorManager.primary,
          elevation: 1,
          title: Text('Documents',style: getMediumStyle(color: ColorManager.white,fontSize: 20),),
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
          Text('My Folders',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
          h20,
          folderList.when(
              data: (data){
                if(data.isEmpty){
                  return Text('No folders.',style:getRegularStyle(color: ColorManager.black,fontSize: 20));
                }
                else{
                  return documentList.when(
                      data: (documents){
                        return GridView.builder(
                          itemCount: data.length,
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
              loading: ()=>Center(child: SpinKitDualRing(color: ColorManager.blue,lineWidth: 20),)
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
                        ('pressed!!');
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
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Files',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                  Divider(
                    thickness: 0.5,
                    color: ColorManager.black.withOpacity(0.8),
                  ),
                  Center(
                    child: Text('No files',style: getMediumStyle(color: ColorManager.black),),
                  ),
                ],
              ),
            );
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
            child: FaIcon(typeId == 2 ? FontAwesomeIcons.images:FontAwesomeIcons.fileLines,color: ColorManager.blueText.withOpacity(0.5),)),
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
                  _folderCustomize(icon: Icons.delete_outline, name: 'Delete',
                      onTap: (){}
                    //       ()async{
                    //     final scaffoldMessage = ScaffoldMessenger.of(context);
                    // final response = await DoctorDocumentServices().delDocument(documentId: documentId);
                    // if(response.isLeft()){
                    //   final left = response.fold(
                    //           (l) => l,
                    //           (r) => null
                    //   );
                    //   scaffoldMessage.showSnackBar(
                    //       SnackbarUtil.showFailureSnackbar(
                    //           message: '$left',
                    //           duration: const Duration(milliseconds: 1200)
                    //       )
                    //   );
                    //   Navigator.pop(context);
                    // }
                    // else{
                    //   if(response.isLeft()){
                    //
                    //     scaffoldMessage.showSnackBar(
                    //         SnackbarUtil.showSuccessSnackbar(
                    //             message: 'Successful',
                    //             duration: const Duration(milliseconds: 1200)
                    //         )
                    //     );
                    //     ref.refresh(documentProvider(docId));
                    //     ref.refresh(folderProvider(docId));
                    //     Navigator.pop(context);
                    //   }
                    // }
                    //   }
                  ),

                ],
              ),
            ),
          );
        }
    );
  }

}
