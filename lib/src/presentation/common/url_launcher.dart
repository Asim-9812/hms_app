import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlLauncher {
  int? phoneNumber;
  String? email;
  String? url;

  UrlLauncher({this.email, this.phoneNumber,this.url});




  Future<void> launchUrl() async {
    try {
      if (email == null && url == null) {
        final Uri launchUri = Uri(
          scheme: 'tel',
          path: '$phoneNumber',
        );
        await launchUrlString(launchUri.toString());
      }
      else if(phoneNumber == null && url == null) {
        final Uri launchUri = Uri(
          scheme: 'mailto',
          path: '$email',
        );
        await launchUrlString(launchUri.toString());
      }
      else {
        final Uri launchUri = Uri(
          scheme: 'https',
          path: '$url',
        );
        await launchUrlString(launchUri.toString());
      }
    } catch (e) {
      // Handle exceptions
    }
  }
}
