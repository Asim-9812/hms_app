

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/style_manager.dart';
import '../../../../../core/resources/value_manager.dart';
import '../../../../../data/provider/common_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../../common/date_input_formatter.dart';
import '../../../../common/snackbar.dart';
import '../../../../documents/domain/model/document_model.dart';
import '../../../../login/domain/model/user.dart';
import '../../domain/services/document_services.dart';



class AddPatientDocuments extends ConsumerStatefulWidget {
  final String? existingFolder;
  AddPatientDocuments({this.existingFolder});

  @override
  ConsumerState<AddPatientDocuments> createState() => _AddDocumentPageState();
}

class _AddDocumentPageState extends ConsumerState<AddPatientDocuments> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _folderNameController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();

  PlatformFile? file;



  bool isPosting = false;
  bool? _validateFile ;
  bool _newFolder = false;
  String selectedDocumentType ='Select a type';
  late String selectedFolder;
  int selectedDocumentTypeId =0;
  List<DocumentTypeModel> docTypeList = [];
  List<String> folderList = [];


  String initialFolder = 'Select a folder';
  final userBox = Hive.box<User>('session').values.toList();



  DocumentTypeModel initial = DocumentTypeModel(
      documentTypeId: 0,
      documentType: 'Select a type',
      isActive: false,
      remarks: '',
      entryDate: DateTime.now()
  );


  List<String> dateType = ['years', 'months','days'];
  String selectedDateType = 'years';
  int dateTypeId = 0;


  void initState(){
    super.initState();
    _getDocumentTypes();
    _folderNameController.text =widget.existingFolder ?? '';
    selectedFolder = widget.existingFolder ?? 'Select a folder';




  }


  void _getDocumentTypes() async {

    final userId = userBox[0].username;
    final folders = await PatientDocumentServices().getFolderList(username: userId!);
    final typeList = await PatientDocumentServices().getDocumentTypeList();
    setState(() {
      folderList = folders;
      docTypeList = [initial,...typeList];
    });
  }


  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:_dateController.text.isNotEmpty?DateFormat('yyyy-MM-dd').parse(_dateController.text): DateTime.now(),
      firstDate:DateTime(1900),
      lastDate:DateTime.now(),
    );
    if (picked != null && picked != DateTime.now())
      controller.text = DateFormat('yyyy-MM-dd').format(picked);

  }




  @override
  Widget build(BuildContext context) {



    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.white.withOpacity(0.9),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ColorManager.primary,
          elevation: 1,
          title: Text('Add Document',style: getMediumStyle(color: ColorManager.white,fontSize: 24),),
          leading: IconButton(
            onPressed: ()=>Get.back(),
            icon: Icon(Icons.chevron_left,color: ColorManager.white,),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              h20,
              _createFile(),
              buildBrowseFile(),
              h20,
              h20,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                        ),
                        onPressed: ()async {
                          final scaffoldMessage = ScaffoldMessenger.of(context);
                          formKey.currentState!.validate();
                          formKey1.currentState!.validate();
                          if(formKey.currentState!.validate() && formKey1.currentState!.validate()){

                            if(file == null){
                              setState(() {
                                _validateFile = true;
                              });
                              scaffoldMessage.showSnackBar(
                                  SnackbarUtil.showFailureSnackbar(
                                      message: 'Please select a file',
                                      duration: const Duration(milliseconds: 1200)
                                  )
                              );
                            }
                            else{
                              setState(() {
                                isPosting = true;
                              });
                              final response = await PatientDocumentServices().addPatientDocuments(
                                  documentID: 1,
                                  userID: userBox[0].username!,
                                  documentTypeID: selectedDocumentTypeId,
                                  folderName: 'Patient',
                                  doctorAttachmentID: 1,
                                  documentTitle: _nameController.text.trim(),
                                  documentDescription:_descController.text.trim() ,
                                  completedDate: _dateController.text.trim(),
                                  documentUrl: file!
                              );
                              if(response.isLeft()){
                                final left = response.fold((l) => l, (r) => null);
                                print(left);
                                scaffoldMessage.showSnackBar(
                                    SnackbarUtil.showFailureSnackbar(
                                        message: 'Something went wrong',
                                        duration: const Duration(milliseconds: 1200)
                                    )
                                );

                              }
                              else{

                                scaffoldMessage.showSnackBar(
                                    SnackbarUtil.showSuccessSnackbar(
                                        message: 'File uploaded!!!',
                                        duration: const Duration(milliseconds: 1200)
                                    )
                                );
                                ref.invalidate(imageProvider);
                                setState(() {
                                  isPosting = false;
                                });

                                ref.refresh(patientDocumentProvider(userBox[0].username!));
                                ref.refresh(patientFolderProvider(userBox[0].username!));
                                Navigator.pop(context);
                              }
                            }




                          }
                          else{

                            scaffoldMessage.showSnackBar(
                                SnackbarUtil.showFailureSnackbar(
                                    message: 'Please fill required fields',
                                    duration: const Duration(milliseconds: 1200)
                                )
                            );
                          }
                        },
                        child: isPosting? SpinKitDualRing(color: ColorManager.white,size: 16,): Text('Save',style: getRegularStyle(color: ColorManager.white,fontSize: 20),),
                      ),
                    ),
                    w10,
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.dotGrey,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel',style: getRegularStyle(color: ColorManager.black,fontSize: 20),),
                      ),
                    ),
                  ],
                ),
              ),
              h100
            ],
          ),
        ),

      ),
    );
  }

  Widget _createFile(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              isDense:true,
              padding: EdgeInsets.zero,
              value: selectedDocumentType,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Type',
                labelStyle: TextStyle(color: ColorManager.primary),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorManager.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorManager.primary),
                ),
              ),
              items: docTypeList
                  .map(
                    (item) => DropdownMenuItem<String>(
                  value: item.documentType,
                  child: Text(
                    item.documentType,
                    style: getRegularStyle(color: Colors.black,fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedDocumentType= value!;
                  selectedDocumentTypeId = docTypeList.firstWhere((element) => element.documentType == value).documentTypeId;
                });
              },
              validator: (value){
                if(value == 'Select a type'){
                  return 'Document type is required';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            h10,
            TextFormField(
              controller: _nameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value){
                if (value!.isEmpty) {
                  return 'Name is required';
                }
                if (RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value)) {
                  return 'Invalid Name';
                }
                return null;
              },
              decoration: InputDecoration(

                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: ColorManager.primary
                      )
                  ),
                  floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                  labelText: 'File name',
                  labelStyle: getRegularStyle(color: ColorManager.primary),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: ColorManager.primary
                      )
                  )
              ),
            ),
            h10,
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Date is required';
                }

                // Create a regular expression pattern to match 'yyyy-MM-dd' format
                final pattern = r'^\d{4}-\d{2}-\d{2}$';
                final regex = RegExp(pattern);

                if (!regex.hasMatch(value)) {
                  return 'Invalid Date';
                }

                // Split the date string into parts
                final dateParts = value.split('-');

                // Ensure there are three parts (year, month, day)
                if (dateParts.length != 3) {
                  return 'Invalid Date';
                }

                final year = int.tryParse(dateParts[0]);
                final month = int.tryParse(dateParts[1]);
                final day = int.tryParse(dateParts[2]);

                if (year == null || month == null || day == null) {
                  return 'Invalid Date';
                }

                // Check if the month is invalid
                if (month < 1 || month > 12) {
                  return 'Invalid Month';
                }

                // Check if the day is invalid for the selected month
                if (day < 1 || day > DateTime(year, month + 1, 0).day) {
                  return 'Day must be between 1 and ${DateTime(year, month, 0).day}';
                }

                // Get the current date
                final currentDate = DateTime.now();

                // Check if the selected date is in the future
                if (DateTime(year, month, day).isAfter(currentDate)) {
                  return 'Date cannot be in the future';
                }


                return null;
              },
              inputFormatters: [
                DateInputFormatter()
              ],
              controller: _dateController,
              decoration: InputDecoration(
                floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                labelText: 'Completed date',
                labelStyle: TextStyle(color: ColorManager.primary),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: ColorManager.primary
                    )
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: ColorManager.primary
                    )
                ),
                hintText: 'YYYY-MM-DD',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today,color: ColorManager.primary,),
                  onPressed: () => _selectDate(context, _dateController),
                ),
              ),
            ),
            h16,
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Expanded(
            //       child: DropdownButtonFormField<String>(
            //         isDense:true,
            //         padding: EdgeInsets.zero,
            //         value: selectedFolder,
            //         decoration: InputDecoration(
            //           isDense: true,
            //           labelText: 'Choose a folder',
            //           labelStyle: TextStyle(color: ColorManager.primary),
            //           filled: true,
            //           fillColor: Colors.transparent,
            //           border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10),
            //             borderSide: BorderSide(color: ColorManager.primary),
            //           ),
            //           enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10),
            //             borderSide: BorderSide(color: ColorManager.primary),
            //           ),
            //         ),
            //         items: folderList
            //             .map(
            //               (item) => DropdownMenuItem<String>(
            //             value: item,
            //             child: Text(
            //               item,
            //               style: getRegularStyle(color: Colors.black,fontSize: 16),
            //               overflow: TextOverflow.ellipsis,
            //             ),
            //           ),
            //         )
            //             .toList(),
            //         onChanged: (String? value) {
            //           setState(() {
            //             selectedFolder= value!;
            //             _folderNameController.text = value;
            //             _newFolder = false;
            //           });
            //         },
            //         validator: (value){
            //           if(value == 'Select a folder'  && _newFolder == false){
            //             return 'Select a folder';
            //           }
            //           return null;
            //         },
            //         autovalidateMode: AutovalidateMode.onUserInteraction,
            //       ),
            //     ),
            //     w10,
            //     InkWell(
            //       onTap: (){
            //         setState(() {
            //           _newFolder = !_newFolder;
            //           selectedFolder = 'Select a folder';
            //           _folderNameController.clear();
            //         });
            //       },
            //       child: Container(
            //         height: 60.h,
            //         width: 100,
            //         decoration: BoxDecoration(
            //           color: _newFolder ? ColorManager.primary : Colors.transparent,
            //           borderRadius: BorderRadius.circular(10),
            //           border: Border.all(
            //             color: ColorManager.primary
            //           )
            //         ),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             FaIcon(FontAwesomeIcons.folderPlus,size: 20.sp,color: _newFolder ? ColorManager.white : ColorManager.black),
            //             h10,
            //             Text('New folder',style: getRegularStyle(color: _newFolder ? ColorManager.white : ColorManager.black,fontSize: 14.sp),),
            //           ],
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            // h10,
            //   if(_newFolder == true)
            //   TextFormField(
            //     controller: _folderNameController,
            //     autovalidateMode: AutovalidateMode.onUserInteraction,
            //     validator: (value){
            //       if (value!.isEmpty) {
            //         return 'Folder name is required';
            //       }
            //       if (RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value)) {
            //         return 'Invalid Name';
            //       }
            //       if (folderList.any((folder) => folder.toLowerCase() == value.toLowerCase())) {
            //         return 'Folder name already exists';
            //       }
            //       return null;
            //     },
            //     decoration: InputDecoration(
            //
            //
            //         enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10),
            //             borderSide: BorderSide(
            //                 color: ColorManager.primary
            //             )
            //         ),
            //         floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
            //         labelText: 'Folder name',
            //         labelStyle: getRegularStyle(color: ColorManager.primary),
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10),
            //             borderSide: BorderSide(
            //                 color: ColorManager.primary
            //             )
            //         )
            //     ),
            //   ),
            // h10,

          ],
        ),
      ),
    );
  }



  /* upload files ui ...*/

  Widget buildBrowseFile() {
    final image= ref.watch(imageProvider);


    if (image != null) {


      File newFile = File(image.path);
      PlatformFile platformFile = convertFileToPlatformFile(newFile);

      setState(() {
        file = platformFile;
        _validateFile = false;
      });

    }

    return Form(
      key: formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DottedBorder(
            borderPadding: EdgeInsets.symmetric(horizontal: 18.w),
            dashPattern: [8, 3, 8, 3],
            color: _validateFile == true ? ColorManager.red :ColorManager.primary,
            borderType: BorderType.RRect,
            radius: Radius.circular(12),
            padding: EdgeInsets.zero,
            child: InkWell(
              onTap: ()async {
                final scaffoldMessage = ScaffoldMessenger.of(context);
                print(selectedDocumentType);
                if(selectedDocumentTypeId == 0){

                  scaffoldMessage.showSnackBar(
                      SnackbarUtil.showFailureSnackbar(
                          message: 'Select a document type',
                          duration: const Duration(milliseconds: 1200)
                      )
                  );
                }
                else if(selectedDocumentType.toLowerCase() == 'image'){

                  await showModalBottomSheet(

                      backgroundColor: ColorManager.white,
                      context: context,
                      builder: (context){
                        return Container(
                          height: 150,
                          padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap : () async {
                                       ref.read(imageProvider.notifier).camera();




                                       // if(image!=null){
                                       //   // Convert XFile to File
                                       //   File file2 = File(image.path);
                                       //   PlatformFile platformFile = convertFileToPlatformFile(file2);
                                       //
                                       //   setState(() {
                                       //     file = platformFile;
                                       //     _validateFile =false;
                                       //   });
                                       //
                                       //   ref.refresh(imageProvider);
                                       //
                                       // }


                                        // Now you can work with the 'file' as a File
                                        // For example, you can use it to display or upload the image
                                       setState(() {

                                       });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: ColorManager.black.withOpacity(0.5)
                                          )
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 30.h),
                                      child: Icon(FontAwesomeIcons.camera,color: ColorManager.black,),
                                    ),
                                  ),
                                  h10,
                                  Text('Camera',style: getRegularStyle(color: ColorManager.black,fontSize: 16),)
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap:()async{

                                      ref.read(imageProvider.notifier).pickAnImage();



                                      // FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      //   allowMultiple: false,
                                      //   type: FileType.custom,
                                      //   allowedExtensions: [
                                      //     'jpg',
                                      //     'jpeg',
                                      //     'png',
                                      //     'gif',
                                      //     'bmp',
                                      //     'tiff',
                                      //     'webp',
                                      //     'svg',
                                      //     'ico'],
                                      // );
                                      //
                                      // if (result != null) {
                                      //   setState(() {
                                      //     file = result.files.first;
                                      //     _validateFile =false;
                                      //   });
                                      //
                                      // } else {
                                      //   // User canceled the picker
                                      // }

                                      setState(() {

                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: ColorManager.black.withOpacity(0.5)
                                          )
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 30.h),
                                      child: Icon(FontAwesomeIcons.image,color: ColorManager.black,),
                                    ),
                                  ),
                                  h10,
                                  Text('Gallery',style: getRegularStyle(color: ColorManager.black,fontSize: 16),)
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                  );


                }
                else if(selectedDocumentType.toLowerCase() == 'pdf'){
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: [
                      'pdf', 'pdx', 'pdfx', 'pdfa', 'pdt', 'pdn'],
                  );

                  if (result != null) {

                    setState(() {
                      file = result.files.first;
                      _validateFile =false;
                    });
                  } else {
                    // User canceled the picker
                  }
                }

              },
              splashColor: ColorManager.primary.withOpacity(0.5),
              child: Container(
                height: 150.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 30.w),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if(file != null)
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              file = null;
                            });
                            ref.invalidate(imageProvider);
                          },
                          child: FaIcon(Icons.cancel_outlined,color: ColorManager.primary,)),
                    ),
                    FaIcon(CupertinoIcons.arrow_down_doc,color: ColorManager.primary,size: 40,),
                    h10,
                    Container(
                        width: file == null ? double.infinity : 300,
                        child: Center(child: Text(file == null ? 'Browse for files':'${file!.path}',style: getMediumStyle(color: ColorManager.primary,fontSize: 16),overflow: TextOverflow.clip ,maxLines: 2,))),

                  ],
                ),
              ),
            ),
          ),
          h20,
          if(_validateFile == true)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Text('File is required',style: TextStyle(color: ColorManager.red.withOpacity(0.7)),),
            ),
          if(_validateFile == true)
            h10,

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: TextFormField(
                controller: _descController,
                maxLines: null,

                decoration: InputDecoration(

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorManager.primary
                        )
                    ),
                    floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                    labelText: 'Add a description',
                    labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorManager.primary
                        )
                    )
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Description is required';
                  }
                  return null;
                },
              ),
            ),

        ],
      ),
    );
  }

  PlatformFile convertFileToPlatformFile(File file) {
    // Get the path of the File
    String filePath = file.path;

    // Get the name of the File
    String fileName = file.uri.pathSegments.last;

    // Create a PlatformFile using the path and name
    PlatformFile platformFile = PlatformFile(
      path: filePath,
      name: fileName, size: 128000
    );

    return platformFile;
  }



}
