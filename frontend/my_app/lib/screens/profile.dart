import 'package:flutter/material.dart';
import 'package:my_app/provider/home_screen_provider.dart';
import 'package:my_app/theme/theme.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            onPressed: () {
              Navigator.of(context).pop();
              provider.setSelectedTabIndex(0);
            }),
        title: Text(
          'PROFILE',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                    Navigator.of(context).pushNamed('/notification');
                },
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
              ? _buildErrorWidget(context, provider)
              : _buildProfileContent(context, size, theme, provider),
      //bottomNavigationBar: _buildBottomNavBar(context, provider),
    );
  }

  Widget _buildErrorWidget(BuildContext context, HomeProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage ?? 'Failed to load profile',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                provider.fetchData();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(
      BuildContext context, Size size, ThemeData theme, HomeProvider provider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(context, theme, provider),
          const SizedBox(height: 16),
          _buildProfileOptions(context, theme),
          const SizedBox(height: 32),
          _buildAppVersion(context, theme),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, ThemeData theme, HomeProvider provider) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          // This would be an actual image in a real app
          child: Icon(
            Icons.person,
            size: 60,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          provider.userName,
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Divider(
          color: theme.dividerColor,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildProfileOptions(BuildContext context, ThemeData theme) {
    final options = [
      {
        'icon': Icons.settings,
        'title': 'SETTINGS & PREFERENCES',
      },
      {
        'icon': Icons.notifications,
        'title': 'NOTIFICATIONS',
      },
      {
        'icon': Icons.description,
        'title': 'TERMS OF USE',
      },
      {
        'icon': Icons.privacy_tip,
        'title': 'PRIVACY POLICY',
      },
      {
        'icon': Icons.help,
        'title': 'HELP & FAQS',
      },
      {
        'icon': Icons.support_agent,
        'title': 'CONTACT US',
      },
    ];

    return Column(
      children: options.map((option) {
        return _buildOptionTile(context, option['icon'] as IconData,
            option['title'] as String, theme);
      }).toList(),
    );
  }

  Widget _buildOptionTile(
      BuildContext context, IconData icon, String title, ThemeData theme) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: theme.iconTheme.color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: theme.iconTheme.color?.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: theme.dividerColor,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        ),
      ],
    );
  }

  Widget _buildAppVersion(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'APP VERSION 4.5.42015',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
        ),
      ),
    );
  }
}
