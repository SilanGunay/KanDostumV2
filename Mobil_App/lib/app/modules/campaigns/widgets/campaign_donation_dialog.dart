import 'package:flutter/material.dart';
import 'package:kandostum2/app/shared/helpers/date_helper.dart';

class CampaignDonationDialog {
  static void show(BuildContext context, {String nextDonationDate, Function onConfirm}) {
    final date = DateHelper.parse(nextDonationDate);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (DateHelper.format(date) == DateHelper.format(today) || date.isBefore(today)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return _successDialog(context, onConfirm);
        },
      );
    } else {


      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return _wrongDialog(context, date.difference(today).inDays);
        },
      );
    }
  }

  static _successDialog(BuildContext context, Function onConfirm) {
    return AlertDialog(
      title: new Text('Donate!'),
      content: new Text(
          'By clicking the Confirm button, you confirm your donation. If you really donated, please click the confirm button.'),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Confirm'),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
        ),
      ],
    );
  }

  static _wrongDialog(BuildContext context, int days) {

    return AlertDialog(
      title: new Text('Donations are not allowed!'),
      content: new Text(
          'Sorry, you can not donate right now, $days left to donate again.'),
      actions: <Widget>[
        FlatButton(
          child: Text('Complete'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
