

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/presentation/documents/domain/services/document_services.dart';
import 'package:meroupachar/src/presentation/documents/presentation/pdfView.dart';

import '../../../core/api.dart';
import '../../../core/pdf_api.dart';
import '../../common/snackbar.dart';
import '../add_documents/presentation/add_document_page.dart';
import '../domain/model/document_model.dart';
import '../search_documents/presentation/search_document_page.dart';

class FolderPage extends ConsumerStatefulWidget {
  final String docId;
  final String folderName;
  final List<DocumentModel> files;
  FolderPage({required this.docId,required this.folderName,required this.files});

  @override
  ConsumerState<FolderPage> createState() => _PatientFolderPageState();
}

class _PatientFolderPageState extends ConsumerState<FolderPage> {
  // bool isFolderLocked = false;
  List<DocumentModel> docList = [];
  List<DocumentTypeModel> docTypeList = [];
  int? pages;
  bool? isReady;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorManager.white.withOpacity(0.9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorManager.primaryDark,
        elevation: 1,
        title: Text(widget.folderName,style: getMediumStyle(color: ColorManager.white,fontSize: 24),),
        leading: IconButton(
          onPressed: ()=>Get.back(),
          icon: FaIcon(CupertinoIcons.chevron_back),color: Colors.white,),
      actions: [
          IconButton(
            onPressed: ()=>Get.to(()=>AddDocuments(existingFolder: widget.folderName,),transition: Transition.rightToLeftWithFade,duration: Duration(milliseconds: 500))
            , icon: FaIcon(Icons.add),color: ColorManager.primary),
          IconButton(onPressed: ()=>Get.to(()=>SearchDocuments(),transition:Transition.rightToLeftWithFade)
            , icon: FaIcon(Icons.search),color: ColorManager.primary,),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFile(context),
            ],
          ),
        ),
      ),
    );
  }






  /* file widgets...*/

  Widget buildFile(BuildContext context) {
    return  ListView.builder(
      itemCount: widget.files.length > 5 ? 5 : widget.files.length,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _fileTile(context,
          docId: widget.docId,
          documentId:widget.files[index].documentID! ,
          typeId: widget.files[index].documentTypeID!,
          fileName: widget.files[index].documentTitle!,
          description: widget.files[index].documentDescription?? 'No description',
          onTap: ()async{
            if(widget.files[index].documentTypeID == 2){
              final image = Image.network('${Api.baseUrl}/${widget.files[index].doctorAttachment}').image;
              showImageViewer(context, image, onViewerDismissed: () {
                print("dismissed");
              });
            }
            else{
              final String path = '${Api.baseUrl}/${widget.files[index].doctorAttachment}';
              final file = await PDFApi.loadNetwork(path);
              Get.to(()=>PDFViewerPage(file: file,title:widget.files[index].documentTitle! ,));

            }
          },
        );
      },

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

  Widget _menuCustomize({
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
                  _menuCustomize(icon: Icons.delete_outline, name: 'Delete',
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
                          if(response.isLeft()){
                            scaffoldMessage.showSnackBar(
                                SnackbarUtil.showSuccessSnackbar(
                                    message: 'Successful',
                                    duration: const Duration(milliseconds: 1200)
                                )
                            );
                            ref.refresh(documentProvider(docId));
                            ref.refresh(folderProvider(docId));
                            Navigator.pop(context);
                          }
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
