import 'package:bookly_app/core/utils/funcations/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> lanuchCustomUrl(context, String? url) async {
  if (url != null) {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      customSnackBar(context, "Could not launch $url");
    }
  }
}
