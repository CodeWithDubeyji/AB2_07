import 'package:flutter/material.dart';
import 'package:my_app/provider/campaign_provider.dart';
import 'package:provider/provider.dart';

class CampaignsScreen extends StatelessWidget {
  const CampaignsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CampaignsProvider(),
      child: const _CampaignsScreenContent(),
    );
  }
}

class _CampaignsScreenContent extends StatelessWidget {
  const _CampaignsScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<CampaignsProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    
    final double paddingValue = screenWidth * 0.04; // 4% of screen width
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color:theme.textTheme.bodyLarge?.color ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'CAMPAIGNS',
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: screenWidth * 0.045, // Responsive font size
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: paddingValue),
            child: CircleAvatar(
              backgroundColor: theme.primaryColor,
              radius: screenWidth * 0.015, // Responsive radius
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(paddingValue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active campaigns count
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black54,
                  ),
                  children: [
                    TextSpan(text: 'WE HAVE TOTAL ', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)), 
                    TextSpan(
                      text: '0${provider.activeCampaignsCount} ACTIVE CAMPAIGNS',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: screenHeight * 0.02), // 2% of screen height
              
              // Campaign list
              Expanded(
                child: ListView.builder(
                  itemCount: provider.campaigns.length,
                  itemBuilder: (context, index) {
                    final campaign = provider.campaigns[index];
                    return _CampaignCard(
                      campaign: campaign,
                      theme: theme,
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final ThemeData theme;
  final double screenHeight;
  final double screenWidth;

  const _CampaignCard({
    required this.campaign,
    required this.theme,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CampaignsProvider>(context);
    final double cardPadding = screenWidth * 0.03; // 3% of screen width
    
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Status
          Row(
            children: [
              Text(
                campaign.date,
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.035,
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Text(
                campaign.status,
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ],
          ),
          
          SizedBox(height: screenHeight * 0.008),
          
          // Description
          Text(
            campaign.description,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: screenWidth * 0.035,
            ),
          ),
          
          SizedBox(height: screenHeight * 0.015),
          
          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // I AM IN button
              InkWell(
                onTap: () => provider.toggleJoinCampaign(campaign.id),
                child: Row(
                  children: [
                    // Checkbox/circle indicator
                    Container(
                      width: screenWidth * 0.05,
                      height: screenWidth * 0.05,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: campaign.isUserJoined ? theme.primaryColor : Colors.grey,
                          width: 1.5,
                        ),
                        color: campaign.isUserJoined ? theme.primaryColor : Colors.transparent,
                      ),
                      child: campaign.isUserJoined 
                          ? Icon(
                              Icons.check,
                              size: screenWidth * 0.035,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'I AM IN',
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ],
                ),
              ),
              
              // DETAILS button
              InkWell(
                onTap: () => provider.viewCampaignDetails(campaign.id),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: screenWidth * 0.04,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Text(
                      'DETAILS',
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: screenHeight * 0.015),
          
          // Divider
          Divider(color: Colors.grey[300], height: 1),
        ],
      ),
    );
  }
}



