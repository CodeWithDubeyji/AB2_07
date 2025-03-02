import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Campaign {
  final String id;
  final String date;
  final String status;
  final String description;
  bool isUserJoined;

  Campaign({
    required this.id,
    required this.date,
    required this.status,
    required this.description,
    this.isUserJoined = false,
  });
}

// Campaign Provider for State Management
class CampaignsProvider extends ChangeNotifier {
  final url = Uri.parse('http://10.0.2.2:5000/api/requests/active-requests');

  void toggleJoinCampaign(String campaignId) async {
    final index = _campaigns.indexWhere((campaign) => campaign.id == campaignId);
    if (index != -1) {
      _campaigns[index].isUserJoined = !_campaigns[index].isUserJoined;
      notifyListeners();
      //await postData(_campaigns[index]);
    }
  }

  Future<void> getData() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);
        notifyListeners();
      } else {
        throw Exception('Failed to load campaigns' + response.statusCode.toString());
      }
    } catch (error) {
      throw error;
    }
  }

  final List<Campaign> _campaigns = [
    Campaign(
      id: '1',
      date: 'DECEMBER, 25 2022',
      status: 'ONGOING',
      description: 'FOR EXAMPLE THIS CAMPAIGN IS CONDUCTED BY COOPER HOSPITAL',
    ),
    Campaign(
      id: '2',
      date: 'DECEMBER, 27 2022',
      status: 'UPCOMING',
      description: 'FOR EXAMPLE THIS CAMPAIGN IS CONDUCTED BY ANDHERI BLOOD BANK',
    ),
    Campaign(
      id: '3',
      date: 'DECEMBER, 29 2022',
      status: 'UPCOMING',
      description: 'INVITE YOUR FRIENDS AND COLLEAGUES FOR NEW BLOOD DONATION CAMPAIGN.',
    ),
    Campaign(
      id: '4',
      date: 'JANUARY, 10 2022',
      status: 'UPCOMING',
      description: 'INVITE YOUR FRIENDS AND COLLEAGUES FOR NEW BLOOD DONATION CAMPAIGN.',
    ),
  ];

  int get activeCampaignsCount => _campaigns.length;
  List<Campaign> get campaigns => _campaigns;
  bool get isUserJoined => _campaigns.any((campaign) => campaign.isUserJoined);

  List<Campaign> get joinedCampaigns => _campaigns.where((campaign) => campaign.isUserJoined).toList();
  List<Campaign> get notJoinedCampaigns => _campaigns.where((campaign) => !campaign.isUserJoined).toList();

  // View campaign details (navigation would be implemented in UI)
  void viewCampaignDetails(String campaignId) {
    // This would typically navigate to a details screen
    // For now, just a placeholder method
    debugPrint('Viewing details for campaign $campaignId');
  }
}
