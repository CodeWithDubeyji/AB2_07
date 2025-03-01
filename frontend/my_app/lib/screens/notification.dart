import 'package:flutter/material.dart';
import 'package:my_app/provider/notification_provider.dart' as myApp;
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = Provider.of<myApp.NotificationsProvider>(context);
    final notifications = notificationsProvider.notifications;
    final newNotificationsCount = notificationsProvider.newNotificationsCount;
    
    // Using theme colors as specified
    final primaryColor = Theme.of(context).primaryColor;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textTheme = Theme.of(context).textTheme;
    
    // Using MediaQuery for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'NOTIFICATIONS',
          style: textTheme.bodyLarge
        ),
        
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.01,
            ),
            child: Row(
              children: [
                Text(
                  '0${newNotificationsCount}',
                  style: textTheme.bodyLarge
                ),
                SizedBox(width: 5),
                Text(
                  'NEW NOTIFICATIONS',
                  style: textTheme.bodyLarge
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationTile(
                  notification: notification,
                  primaryColor: primaryColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final myApp.Notification notification;
  final Color primaryColor;
  final double screenWidth;
  final double screenHeight;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.primaryColor,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02,
        vertical: screenHeight * 0.005,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth * 0.1,
            height: screenWidth * 0.1,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: notification.isNew
                ? Text(
                    'N',
                    style: textTheme.bodyLarge
                  )
                : Icon(
                    Icons.check,
                    color: Colors.white,
                    size: screenWidth * 0.05,
                  ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Text(
              notification.message,
              style: textTheme.bodyLarge
            ),
          ),
        ],
      ),
    );
  }
}
