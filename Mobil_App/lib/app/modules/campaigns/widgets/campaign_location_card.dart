import 'package:flutter/material.dart';
import 'package:kandostum2/app/modules/campaigns/models/campaign_location_model.dart';

class CampaignLocationCard extends StatelessWidget {
  final CampaignLocationModel campaign;
  final Function onShare;
  final Function onDonation;

  const CampaignLocationCard({
    Key key,
    this.campaign,
    this.onShare,
    this.onDonation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(campaign.photoPath ?? ''),),
              title: Text(campaign.name ?? ''),
              subtitle: Text(campaign.location),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildButton(
                  visible: true,
                  label: 'Share',
                  icon: Icons.share,
                  onPressed: onShare,
                ),
                _buildButton(
                  visible: true,
                  label: 'Donate',
                  icon: Icons.favorite,
                  onPressed: onDonation,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildButton(
      {bool visible, String label, IconData icon, Function onPressed}) {
    return Visibility(
      visible: visible,
      child: FlatButton.icon(
        icon: Icon(
          icon,
          size: 18.0,
        ),
        label: Text(
          label,
          style: TextStyle(fontSize: 12.0),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
