import 'package:flutter/material.dart';
import 'package:my_app/provider/find_donors_provider.dart';
import 'package:provider/provider.dart';

// Provider for managing state


// Main Screen Widget

class FindDonorsContent extends StatefulWidget {
  const FindDonorsContent({Key? key}) : super(key: key);

  @override
  State<FindDonorsContent> createState() => _FindDonorsContentState();
}

class _FindDonorsContentState extends State<FindDonorsContent> {
  // Mock donor data
  final List<Map<String, dynamic>> donors = [
    {
      'id': 1,
      'name': 'Michael S.',
      'bloodType': 'O+',
      'distance': '0.8 km',
      'lastDonation': '3 months ago',
      'available': true,
    },
    {
      'id': 2,
      'name': 'Sarah J.',
      'bloodType': 'A-',
      'distance': '1.2 km',
      'lastDonation': '5 months ago',
      'available': true,
    },
    {
      'id': 3,
      'name': 'David L.',
      'bloodType': 'B+',
      'distance': '2.5 km',
      'lastDonation': '2 months ago',
      'available': false,
    },
    {
      'id': 4,
      'name': 'Emily T.',
      'bloodType': 'AB+',
      'distance': '3.4 km',
      'lastDonation': '1 year ago',
      'available': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Equivalent to useEffect to scroll to top
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // In Flutter, this is usually handled by the framework
      // But we could add specific scroll behavior here if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FindDonorsProvider>(context);
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate responsive padding
    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Donors'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blur Container for filters
              BlurContainer(
                child: Padding(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header and filter button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Find Blood Donors',
                            style: theme.textTheme.titleLarge,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.filter_list),
                              onPressed: () {},
                              iconSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Blood Type Selector
                      BloodTypeSelector(
                        onSelect: provider.selectBloodType,
                        selectedType: provider.selectedBloodType,
                      ),
                      const SizedBox(height: 16),
                      
                      // Distance Slider
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Max Distance: ${provider.distance.toInt()} km',
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Slider(
                            value: provider.distance,
                            min: 1,
                            max: 20,
                            divisions: 19,
                            activeColor: theme.primaryColor,
                            inactiveColor: theme.colorScheme.secondary.withOpacity(0.3),
                            onChanged: provider.updateDistance,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('1 km', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                                Text('10 km', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                                Text('20 km', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Location Map
                      Container(
                        height: screenHeight * 0.2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('Map View'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: verticalPadding * 2),
              
              // Nearby Donors section
              Text(
                'Nearby Donors',
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: verticalPadding),
              
              // Donor List
              donors.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: donors.length,
                    itemBuilder: (context, index) {
                      final donor = donors[index];
                      final bool isAvailable = donor['available'] as bool;
                      
                      return Padding(
                        padding: EdgeInsets.only(bottom: verticalPadding),
                        child: BlurContainer(
                          opacity: isAvailable ? 1.0 : 0.7,
                          child: Padding(
                            padding: EdgeInsets.all(horizontalPadding),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Blood Type Badge
                                Container(
                                  width: screenWidth * 0.12,
                                  height: screenWidth * 0.12,
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    donor['bloodType'] as String,
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: horizontalPadding),
                                
                                // Donor Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Name and Availability Status
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            donor['name'] as String,
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isAvailable
                                                ? Colors.green.withOpacity(0.1)
                                                : Colors.grey.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: isAvailable
                                                      ? Colors.green
                                                      : Colors.grey,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  isAvailable ? 'Available' : 'Unavailable',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: isAvailable
                                                      ? Colors.green.shade700
                                                      : Colors.grey.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      
                                      // Distance and Last Donation
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 14,
                                            color: theme.hintColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            donor['distance'] as String,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: theme.hintColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text(
                                              '•',
                                              style: TextStyle(color: theme.hintColor),
                                            ),
                                          ),
                                          Text(
                                            'Last donation: ${donor['lastDonation']}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: theme.hintColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      
                                      // Action Buttons
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          _buildIconButton(
                                            icon: Icons.message,
                                            isAvailable: isAvailable,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 8),
                                          _buildIconButton(
                                            icon: Icons.phone,
                                            isAvailable: isAvailable,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: isAvailable ? () {} : null,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isAvailable
                                                ? theme.primaryColor
                                                : Colors.grey.shade300,
                                              foregroundColor: isAvailable
                                                ? Colors.white
                                                : Colors.grey.shade700,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 8,
                                              ),
                                              minimumSize: Size.zero,
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                            child: const Text(
                                              'Request',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : BlurContainer(
                    child: Padding(
                      padding: EdgeInsets.all(horizontalPadding * 1.5),
                      child: Column(
                        children: [
                          Text(
                            'No donors found nearby.',
                            style: TextStyle(color: theme.hintColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters or increasing the distance.',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.hintColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
      
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required bool isAvailable,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isAvailable
            ? color.withOpacity(0.1)
            : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 16,
          color: isAvailable ? color : Colors.grey,
        ),
        onPressed: isAvailable ? () {} : null,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
      ),
    );
  }
}

// Custom BlurContainer widget (similar to the React version)
class BlurContainer extends StatelessWidget {
  final Widget child;
  final double opacity;

  const BlurContainer({
    Key? key,
    required this.child,
    this.opacity = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

// Blood Type Selector Component
class BloodTypeSelector extends StatelessWidget {
  final Function(String) onSelect;
  final String selectedType;

  const BloodTypeSelector({
    Key? key,
    required this.onSelect,
    required this.selectedType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Blood Type',
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: bloodTypes.map((type) {
            final isSelected = selectedType == type;
            return InkWell(
              onTap: () => onSelect(type),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.primaryColor
                      : theme.colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: isSelected
                      ? null
                      : Border.all(color: theme.dividerColor),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}