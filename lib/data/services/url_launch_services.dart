import 'package:url_launcher/url_launcher.dart';


class UrlLaunchServices{

  static void launchDialer(String? phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not open dialer';
    }
  }

}