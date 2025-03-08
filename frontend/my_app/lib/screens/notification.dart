import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/provider/notification_provider.dart' as myApp;

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = Provider.of<myApp.NotificationsProvider>(context);
    final notifications = notificationsProvider.notifications;
    final newNotificationsCount = notificationsProvider.newNotificationsCount;

    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('NOTIFICATIONS', style: theme.textTheme.bodyLarge),
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
                Text('0$newNotificationsCount', style: theme.textTheme.bodyLarge),
                SizedBox(width: 5),
                Text('NEW NOTIFICATIONS', style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  notification: notification,
                  onAccept: () {
                    notificationsProvider.removeNotification(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Request accepted'),
                      ),
                    );
                  },
                  onDecline: () {
                    notificationsProvider.removeNotification(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Request declined'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatefulWidget {
  final myApp.Notification notification;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onAccept,
    required this.onDecline,
  }) : super(key: key);

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.01,
      ),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: NotificationTile(
                notification: widget.notification,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ),
            if (isExpanded)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.01,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: widget.onAccept,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: Text('Accept'),
                    ),
                    ElevatedButton(
                      onPressed: widget.onDecline,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Decline'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final myApp.Notification notification;
  final double screenWidth;
  final double screenHeight;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
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
              color: theme.primaryColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: notification.isNew
                ? Text('N', style: theme.textTheme.bodyLarge)
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
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}