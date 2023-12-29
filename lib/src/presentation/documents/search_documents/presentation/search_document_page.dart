import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/presentation/documents/domain/model/document_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../core/api.dart';
import '../../../../core/pdf_api.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../common/snackbar.dart';
import '../../../login/domain/model/user.dart';
import '../../domain/services/document_services.dart';
import '../../presentation/pdfView.dart';



class SearchDocuments extends ConsumerStatefulWidget {
  const SearchDocuments({super.key});

  @override
  ConsumerState<SearchDocuments> createState() => _SearchDocumentsState();
}

class _SearchDocumentsState extends ConsumerState<SearchDocuments> {
  TextEditingController _searchController = TextEditingController();


  List<DocumentModel> searchResults = [];




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
    final userBox = Hive.box<User>('session').values.toList();
    final docId = userBox[0].userID;
    final documentList = ref.watch(allDocumentProvider(docId!));
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.white.withOpacity(0.9),
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: true,
          backgroundColor: ColorManager.primary.withOpacity(0.8),
          elevation: 1,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Icon(Icons.chevron_left, color: ColorManager.white),
              ),
              w20,
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (value)=>onSearchTextChanged(value , documentList.value!),
                  autofocus: true,
                  style: getRegularStyle(color: ColorManager.black, fontSize: 18),
                  decoration: InputDecoration(
                    fillColor: ColorManager.white,
                    filled: true,
                    hintText: 'Search...',
                    hintStyle: getRegularStyle(color: ColorManager.textGrey, fontSize: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5), width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5), width: 0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (searchResults.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: searchResults.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    String fileName = searchResults[index].documentTitle!;
                    String folderName = searchResults[index].folderName!;

                    IconData icon = searchResults[index].documentTypeID == 1 ? FontAwesomeIcons.file : searchResults[index].documentTypeID == 2 ? FontAwesomeIcons.image : FontAwesomeIcons.globe;

                    return ListTile(
                      leading: Icon(icon,color: ColorManager.primary,),
                      title: Text(fileName,style: getRegularStyle(color: ColorManager.black,fontSize: 18),),

                      subtitle:
                      searchResults[index].documentTypeID == 4? null :
                      Text("$folderName",style: getRegularStyle(color: ColorManager.black.withOpacity(0.7),fontSize: 14),),
                      onTap: () async {
                        if(searchResults[index].documentTypeID == 2){
                          final image = Image.network('${Api.baseUrl}/${searchResults[index].doctorAttachment}').image;
                          showImageViewer(context, image, onViewerDismissed: () {
                            print("dismissed");
                          });
                        }
                        else if(searchResults[index].documentTypeID == 4){
                          final url = searchResults[index].doctorAttachment;
                          _launchURL(url!);
                        }
                        else{
                          final String path = '${Api.baseUrl}/${searchResults[index].doctorAttachment}';
                          final file = await PDFApi.loadNetwork(path);
                          Get.to(()=>PDFViewerPage(file: file,title:searchResults[index].documentTitle! ,));

                        }
                      },
                    );
                  },
                ),
              if (searchResults.isEmpty)
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                  child: Text('No matching files found...', style: getRegularStyle(color: ColorManager.textGrey)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void onSearchTextChanged(String searchText, List<DocumentModel> data) {
    searchResults.clear();
    if (searchText.isEmpty) {
      setState(() {});
      return;
    }

    data.forEach((item) {
      if (item.documentTitle!.toLowerCase().contains(searchText.toLowerCase()) ||
          item.folderName!.toLowerCase().contains(searchText.toLowerCase())) {
        searchResults.add(item);
      }
    });

    setState(() {});
  }
}
