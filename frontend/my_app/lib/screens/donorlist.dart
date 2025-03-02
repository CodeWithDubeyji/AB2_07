import 'package:flutter/material.dart';
import 'package:my_app/provider/donor_provider.dart';
import 'package:provider/provider.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchResultsProvider>(context);
    final donors = searchProvider.filteredDonors;
    final resultCount = searchProvider.resultCount;
    final selectedBloodType = searchProvider.selectedBloodType;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'SEARCH',
          style: textTheme.bodyLarge
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  '$resultCount RESULT(S) FOUND FOR BLOOD TYPE ',
                  style: textTheme.bodyLarge
                ),
                Row(
                  children: [
                    Text(
                      selectedBloodType,
                      style: textTheme.bodyLarge
                    ),
                    Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: donors.length,
              itemBuilder: (context, index) {
                final donor = donors[index];
                return DonorTile(
                  donor: donor,
                  primaryColor: theme.primaryColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DonorTile extends StatelessWidget {
  final Donor donor;
  final Color primaryColor;

  const DonorTile({
    Key? key,
    required this.donor,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              donor.name,
              style: textTheme.bodyLarge?.copyWith(fontSize: 18.0),
            ),
          ),
          Row(
            children: [
              _buildActionButton(
                icon: Icons.info_outline,
                onPressed: () {},
                isDark: true,
              ),
              SizedBox(width: 16.0),
              _buildActionButton(
                icon: Icons.phone,
                onPressed: () {},
                isDark: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[700] : primaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20.0,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
