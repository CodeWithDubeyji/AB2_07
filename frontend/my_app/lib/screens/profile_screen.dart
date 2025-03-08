import 'package:flutter/material.dart';
import 'package:my_app/provider/profile_provider.dart';
import 'package:provider/provider.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      child: const ProfileScreenContent(),
    );
  }
}

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Log out the user
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Header
          Container(
            width: screenWidth,
            height: screenHeight * 0.25,
            decoration: BoxDecoration(
              gradient: LinearGradient(
              colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 3),
              ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: screenWidth * 0.1,
                  child: Text('HM', style: TextStyle(color: theme.primaryColor, fontSize: 24)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Himanshu Mishra',
                  style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('B+', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text('5 donations', style: const TextStyle(color: Colors.white)),
                    const SizedBox(width: 4),
                    Text('Last: March 15, 2023', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // Availability Toggle
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Availability:'),
                const SizedBox(width: 8),
                Switch(
                  value: provider.isAvailable,
                  onChanged: (_) => provider.toggleAvailability(),
                  activeColor: theme.primaryColor,
                ),
                Text(provider.isAvailable ? 'Available' : 'Not Available'),
              ],
            ),
          ),

          // Tab Buttons
          Row(
            children: [
              tabButton(context, 'Active Requests', 'active_requests'),
              tabButton(context, 'Request History', 'request_history'),
            ],
          ),

          // Tab Content
          Expanded(
            child: provider.activeTab == 'active_requests'
                ? RequestsListView(title: 'My Blood Requests')
                : provider.activeTab == 'request_history'
                    ? RequestHistoryView()
                    : const Center(child: Text('Select a tab to view details')),
          ),
        ],
      ),
    );
  }

  Widget tabButton(BuildContext context, String title, String tabId) {
    final provider = Provider.of<ProfileProvider>(context);
    final theme = Theme.of(context);
    final isActive = provider.activeTab == tabId;

    return Expanded(
      child: InkWell(
        onTap: () => provider.setActiveTab(tabId),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? theme.primaryColor : Colors.grey.shade300,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? theme.primaryColor : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}



class RequestsListView extends StatelessWidget {
  final String title;

  const RequestsListView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    final theme = Theme.of(context);

    // Sample request data - you can replace this with your actual data source
    final requests = [
      {
        'date': 'June 15, 2023',
        'time': '10:30 AM',
        'status': 'Accepted',
        'type': 'Normal',
        'bloodType': 'A+',
        'donorName': 'John Smith',
        'location': '123 Donor St, Medical District',
        'contact': '+555 123-4567',
        'donationCount': '8',
        'lastDonation': 'May 10, 2023',
      },
      {
        'date': 'July 3, 2023',
        'time': '2:15 PM',
        'status': 'Pending',
        'type': 'Urgent',
        'bloodType': 'O-',
      },
      {
        'date': 'August 5, 2023',
        'time': '11:45 AM',
        'status': 'Pending',
        'type': 'Emergency',
        'bloodType': 'AB+',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.primaryColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '2 pending',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                final bool isExpanded = provider.expandedCardIndex == index;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      // Request card header
                      InkWell(
                        onTap: () => provider.expandCard(index),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: getTypeColor(request['type']!),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(request['date']!, style: theme.textTheme.bodyLarge),
                                  Text(request['type']!, style: theme.textTheme.bodyMedium),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(request['time']!, style: theme.textTheme.bodyMedium),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      request['bloodType']!,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: request['status'] == 'Accepted' ? Colors.green.shade100 : Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  request['status']!,
                                  style: TextStyle(
                                    color: request['status'] == 'Accepted' ? Colors.green.shade800 : Colors.orange.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isExpanded ? Icons.expand_less : Icons.expand_more,
                                color: theme.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Expanded Content
                      if (isExpanded)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Location: ${request['location']}'),
                              Text('Donor: ${request['donorName']}'),
                              Text('Contact: ${request['contact']}'),
                              Text('Donation Count: ${request['donationCount']}'),
                              Text('Last Donation: ${request['lastDonation']}'),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color getTypeColor(String type) {
    switch (type) {
      case 'Normal':
        return Colors.green;
      case 'Urgent':
        return Colors.orange;
      case 'Emergency':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

class RequestHistoryView extends StatelessWidget {
  const RequestHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sample history data with more details
    final history = [
      {
        'date': 'May 10, 2023',
        'status': 'Completed',
        'type': 'Normal',
        'bloodType': 'A+',
        'donorName': 'John Smith',
        'donorContact': '+555 123-4567',
        'donationCount': '8',
        'lastDonation': 'April 20, 2023',
      },
      {
        'date': 'April 22, 2023',
        'status': 'Completed',
        'type': 'Urgent',
        'bloodType': 'O-',
        'donorName': 'Alice Brown',
        'donorContact': '+555 987-6543',
        'donationCount': '5',
        'lastDonation': 'March 30, 2023',
      },
      {
        'date': 'March 15, 2023',
        'status': 'Completed',
        'type': 'Emergency',
        'bloodType': 'AB+',
        'donorName': 'Michael Lee',
        'donorContact': '+555 555-5555',
        'donationCount': '10',
        'lastDonation': 'February 25, 2023',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final record = history[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: getTypeColor(record['type']!),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              title: Text(record['date']!, style: theme.textTheme.bodyLarge),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record['type']!, style: theme.textTheme.bodyMedium),
                  Text('Donor: ${record['donorName']}'),
                  Text('Contact: ${record['donorContact']}'),
                  Text('Donation Count: ${record['donationCount']}'),
                  Text('Last Donation: ${record['lastDonation']}'),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: record['status'] == 'Completed' ? Colors.green.shade100 : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  record['status']!,
                  style: TextStyle(
                    color: record['status'] == 'Completed' ? Colors.green.shade800 : Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color getTypeColor(String type) {
    switch (type) {
      case 'Normal':
        return Colors.green;
      case 'Urgent':
        return Colors.orange;
      case 'Emergency':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
