import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/presentation/patient/scan/presentation/scanner_error_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr_scanner;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';



class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  qr_scanner.Barcode? result;
  String? url;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  BarcodeCapture? barcode;
  MobileScannerArguments? arguments;


  XFile? image;



  final MobileScannerController imgQrController = MobileScannerController(
    autoStart: false,
  );


  @override
  void initState() {
    super.initState();
    // Request camera permission when the widget initializes
    requestCameraPermission();
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      // Permission is granted, you can initialize the QR code scanner here.
    } else if (status.isDenied) {
      // Permission is denied, you can handle this case accordingly (show a dialog, etc.).
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, you can ask the user to open settings to grant the permission.
      openAppSettings();
    }
  }



  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }




  Future<void> ImgPicker() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      if (await imgQrController.analyzeImage(image!.path)) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Barcode found!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {});
        ('${barcode?.barcodes.first.rawValue ?? 'no barcode reader'}');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No barcode found!'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          image = null;
        });
      }
    }
  }


  void redirectUrl(String url) {
    if (url.startsWith('https://')) {
      url = url.replaceFirst('https://', '');
      UrlLauncher.openUrl(url);
    } else if (url.startsWith('http://')) {
      url = url.replaceFirst('http://', '');
      UrlLauncher.openUrl(url);
    }
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[




          Expanded(flex: 4, child: _buildQrView(context)),

          MobileScanner(
            controller: imgQrController,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            onDetect: (barcode) {
              setState(() {
                this.barcode = barcode;
                // Check if image is not null and barcode.rawValue is not null
                if (image != null && barcode.barcodes.first.rawValue != null) {
                  redirectUrl(barcode.barcodes.first.rawValue!);
                }
              });
            },
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(

                margin: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: ()=>Get.back(), icon: FaIcon(Icons.chevron_left,color: ColorManager.white,size: 40,)),
                    Text('Scan QR',style: getMediumStyle(color: ColorManager.white),),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: CircleBorder(
                          side: BorderSide(
                            width: 1,
                            color: ColorManager.white
                          )
                        )
                      ),
                        onPressed: () async {
                          await controller?.toggleFlash();
                          setState(() {});
                        },
                        child: FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return snapshot.data == false? FaIcon(Icons.flash_off):FaIcon(Icons.flash_on);
                          },
                        )),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(

                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,

                    ),
                    onPressed: () async {

                      ImgPicker();
                      setState(() {});
                    },
                    child: FutureBuilder(
                      future: controller?.getFlashStatus(),
                      builder: (context, snapshot) {
                        return FaIcon(Icons.image_outlined,color: ColorManager.white,size: 50,);
                      },
                    )),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;


        if (result != null) {
          url = result!.code;
          // Remove "https://" or "http://" from the result.code
          if (url!.startsWith('https://')) {
            url = url!.replaceFirst('https://', '');
            UrlLauncher.openUrl(url!);
          } else if (result!.code!.startsWith('http://')) {
            url = url!.replaceFirst('http://', '');
            UrlLauncher.openUrl(url!);
          }
          UrlLauncher.openUrl(url!);
        }

      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    dev.log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();

    imgQrController.dispose();
    super.dispose();
  }
}

class UrlLauncher {
  UrlLauncher._();

  static Future<void> openUrl(String code) async {
    final Uri uri = Uri(
      path: code,
      scheme: 'https'
    );
    launchUrl(uri,mode: LaunchMode.externalApplication);
  }
}