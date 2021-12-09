import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:invenzine/constants/route_names.dart';
import 'package:invenzine/pages/home_pages/full_view.dart';
import 'package:invenzine/services/locator.dart';
import 'package:invenzine/services/navigation_service.dart';

class DynamicLinkService {
  final NavigationService _navigationService = locator<NavigationService>();
  Future handleDynamicLinks() async {
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    // 2. handle link that has been retrieved
    _handleDeepLink(data);

    // 3. Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      // 3a. handle link that has been retrieved
      _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');

      // Check if we want to make a post
      var isPost = deepLink.pathSegments.contains('articleview');

      if (isPost) {
        // get the title of the post
        //var title = deepLink.queryParameters['title'];
        String linkpath = deepLink.path;
        String docid = linkpath.substring(linkpath.length - 20);

        if (docid != null) {
          print(docid);
          _navigationService.navigateTo(FullView, arguments: docid);
        }
      }
    }
  }
}

// Future<String> createFirstPostLink(String title) async {
//   final DynamicLinkParameters parameters = DynamicLinkParameters(
//     uriPrefix: 'https://invenzine.page.link',
//     link: Uri.parse('https://techmag-77e4a.web.app/articleview/$title'),
//     androidParameters: AndroidParameters(
//       packageName: 'com.example.invenzine',
//     ),
//     // NOT ALL ARE REQUIRED ===== HERE AS AN EXAMPLE =====
//     // iosParameters: IosParameters(
//     //   bundleId: 'com.example.ios',
//     //   minimumVersion: '1.0.1',
//     //   appStoreId: '123456789',
//     // ),
//     // googleAnalyticsParameters: GoogleAnalyticsParameters(
//     //   campaign: 'example-promo',
//     //   medium: 'social',
//     //   source: 'orkut',
//     // ),
//     // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
//     //   providerToken: '123456',
//     //   campaignToken: 'example-promo',
//     // ),
//     // socialMetaTagParameters: SocialMetaTagParameters(
//     //   title: 'Example of a Dynamic Link',
//     //   description: 'This link works whether app is installed or not!',
//     // ),
//   );

//   final Uri dynamicUrl = await parameters.buildUrl();
//   print(dynamicUrl);
//   //return dynamicUrl.toString();
// }
