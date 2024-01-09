import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlLauncher {
  int? phoneNumber;
  String? email;

  UrlLauncher({this.email, this.phoneNumber});




  Future<void> launchUrl() async {
    try {
      if (email == null) {
        final Uri launchUri = Uri(
          scheme: 'tel',
          path: '$phoneNumber',
        );
        await launchUrlString(launchUri.toString());
      }
      else {
        final Uri launchUri = Uri(
          scheme: 'mailto',
          path: '$email',
        );
        await launchUrlString(launchUri.toString());
      }
    } catch (e) {
      // Handle exceptions
    }
  }
}
