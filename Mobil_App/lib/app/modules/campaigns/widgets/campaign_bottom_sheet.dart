import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kandostum2/app/shared/helpers/local_imagepath.dart';
import 'package:social_share/social_share.dart';

class CampaignBottomSheet {
  static final hashtags = [
    'blood donation',
    'to save a life',
    'blood',
    'kan dostum'
  ];
  static final urlAPP =
      'https://www.kizilay.gov.tr';

  static void show(BuildContext context, String text/* , String imageUrl */) {
    String imagePath = '';
/*     LocalImagePath.readFile(imageUrl).then((String result) {
      imagePath = result;
    }); */
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                leading: new Icon(FontAwesomeIcons.copy),
                title: new Text('Copy'),
                onTap: () {
                  Navigator.pop(context);
                  SocialShare.copyToClipboard(text);
                },
              ),
              new ListTile(
                leading: new Icon(FontAwesomeIcons.facebook),
                title: new Text('Facebook'),
                onTap: () {
                  Navigator.pop(context);
                  SocialShare.shareFacebookStory(
                      imagePath, '#ffffff', '#000000', urlAPP,
                      appId: '300836977741771');
                },
              ),
              new ListTile(
                leading: new Icon(FontAwesomeIcons.instagram),
                title: new Text('Instagram'),
                onTap: () {
                  Navigator.pop(context);
                  SocialShare.shareInstagramStory(
                      imagePath, '#ffffff', '#000000', urlAPP);
                },
              ),
              new ListTile(
                leading: new Icon(FontAwesomeIcons.telegram),
                title: new Text('Telegram'),
                onTap: () {
                  Navigator.pop(context);
                  SocialShare.shareTelegram(text);
                },
              ),
              new ListTile(
                leading: new Icon(FontAwesomeIcons.whatsapp),
                title: new Text('WhatsApp'),
                onTap: () {
                  Navigator.pop(context);
                  SocialShare.shareWhatsapp(text);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
