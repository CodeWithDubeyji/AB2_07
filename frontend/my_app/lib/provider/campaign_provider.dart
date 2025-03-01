import 'package:flutter/material.dart';

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
      description: 'INVITE YOUR FRIENDS AND COLLEGUES FOR NEW BLOOD DONATION CAMPAIGN.',
    ),
    Campaign(
      id: '4',
      date: 'JANUARY, 10 2022',
      status: 'UPCOMING',
      description: 'INVITE YOUR FRIENDS AND COLLEGUES FOR NEW BLOOD DONATION CAMPAIGN.',
    ),
  ];

  int get activeCampaignsCount => _campaigns.length;
  List<Campaign> get campaigns => _campaigns;

  // Toggle user participation in campaign
  void toggleJoinCampaign(String campaignId) {
    final index = _campaigns.indexWhere((campaign) => campaign.id == campaignId);
    if (index != -1) {
      _campaigns[index].isUserJoined = !_campaigns[index].isUserJoined;
      notifyListeners();
    }
  }

  // View campaign details (navigation would be implemented in UI)
  void viewCampaignDetails(String campaignId) {
    // This would typically navigate to a details screen
    // For now, just a placeholder method
    print('Viewing details for campaign $campaignId');
  }
}

// Main Campaigns Screen
