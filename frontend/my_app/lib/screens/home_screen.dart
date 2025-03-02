import 'package:flutter/material.dart';
import 'package:my_app/provider/home_screen_provider.dart';
import 'package:my_app/theme/theme.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Fetch data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<HomeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.errorMessage != null
                ? _buildErrorWidget(provider.errorMessage!)
                : _buildMainContent(context, provider, size, theme),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, provider),
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
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
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Provider.of<HomeProvider>(context, listen: false).fetchData();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(
      BuildContext context, HomeProvider provider, Size size, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, provider),
          const SizedBox(height: 16),
          _buildCarousel(context, provider, size),
          const SizedBox(height: 24),
          _buildActionButtons(context),
          const SizedBox(height: 24),
          build_SosButton(context, theme),
          const SizedBox(height: 24),
          _buildDonationRequests(context, provider, size, theme),
          const SizedBox(height: 24),
          _buildInviteFriends(context, theme),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeProvider provider) {
    return Column(
      children: [
        SizedBox(height: 27),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WELCOME',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        provider.userName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {
                          Navigator.pushNamed(context, '/notification');
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
            ],
          ),
        ),
      ],
    );
  }

  Widget build_SosButton(BuildContext context, dynamic theme) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          String selectedBloodGroup = 'B+';
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Emergency SOS', style: theme.textTheme.titleLarge),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Are you sure you want to send an emergency SOS?'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Select your blood group: ',
                          style: theme.textTheme.bodyLarge),
                      SizedBox(
                        width: 8,
                      ),
                      DropdownButton<String>(
                        value: selectedBloodGroup,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedBloodGroup = newValue!;
                          });
                        },
                        items: <String>[
                          'A+',
                          'A-',
                          'B+',
                          'B-',
                          'AB+',
                          'AB-',
                          'O+',
                          'O-'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('CANCEL',
                      style: TextStyle(color: AppTheme.primaryColor)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('SOS sent successfully', style: TextStyle(color: Colors.white),),
                        backgroundColor: theme.colorScheme.onPrimary,
                      ));
                  },
                  child: Text('SEND SOS',
                      style: TextStyle(color: AppTheme.primaryColor)),
                ),
              ],
            ),
          );
        },
        child: Container(
          height: size.height * 0.07,
          width: size.width * 0.94,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text('Emergency SOS', style: theme.textTheme.titleLarge),
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel(
      BuildContext context, HomeProvider provider, Size size) {
    return SizedBox(
      height: size.height * 0.22,
      child: PageView.builder(
        controller: _pageController,
        itemCount: provider.carouselItemCount,
        onPageChanged: (index) {
          provider.setCurrentCarouselPage(index);
        },
        itemBuilder: (context, index) {
          final item = provider.carouselItems[index];
          return _buildCarouselItem(context, item, size);
        },
      ),
    );
  }

  Widget _buildCarouselItem(
      BuildContext context, Map<String, dynamic> item, Size size) {
    final theme = Theme.of(context);

    if (item['type'] == 'message') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: size.width - 32,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              if (item['hasImage'])
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: size.width * 0.4,
                    height: size.height * 0.2,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    // Image would go here in a real app
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['title'],
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      item['subtitle'],
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['actionText'],
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Event type card
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: size.width - 32,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomPaint(
                    painter: BloodBagPainter(AppTheme.primaryColor),
                    size: const Size(50, 60),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['title'],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['date'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item['time'],
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            context,
            icon: Icons.local_hospital_outlined,
            label: 'HOSPITALS',
            onTap: () {
              Navigator.pushNamed(context, '/campaign');
            },
            width: size.width * 0.28,
          ),
          _buildActionButton(
            context,
            icon: Icons.bloodtype_outlined,
            label: 'DONATE',
            onTap: () {
              Navigator.pushNamed(context, '/donate');
            },
            width: size.width * 0.28,
          ),
          _buildActionButton(
            context,
            icon: Icons.person_search_outlined,
            label: 'FIND DONOR',
            onTap: () {
              String selectedBloodGroup = 'B+';
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Find Donor',
                      style: Theme.of(context).textTheme.titleLarge),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Select your blood group:',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 16),
                      DropdownButton<String>(
                        value: selectedBloodGroup,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedBloodGroup = newValue!;
                          });
                        },
                        items: <String>[
                          'A+',
                          'A-',
                          'B+',
                          'B-',
                          'AB+',
                          'AB-',
                          'O+',
                          'O-'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('CANCEL',
                          style: TextStyle(color: AppTheme.primaryColor)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/donorlist');
                        // Implement search functionality here
                      },
                      child: Text('SEARCH',
                          style: TextStyle(color: AppTheme.primaryColor)),
                    ),
                  ],
                ),
              );
            },
            width: size.width * 0.28,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required double width,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDonationRequests(
      BuildContext context, HomeProvider provider, Size size, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'DONATION REQUST',
            style: theme.textTheme.titleSmall,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: size.height * 0.14,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: provider.donationRequests.length,
            itemBuilder: (context, index) {
              final request = provider.donationRequests[index];
              return _buildDonationRequestCard(context, request, size);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDonationRequestCard(
      BuildContext context, Map<String, dynamic> request, Size size) {
    return Container(
      width: size.width * 0.82,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        request['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          request['hospital'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  request['timeAgo'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      request['bloodGroup'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteFriends(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_add,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INVITE A FRIEND',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'INVITE YOUR FRIENDS OR FAMILY MEMBERS TO DONATE A BLOOD',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, HomeProvider provider) {
    final theme = Theme.of(context);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Home icon
          IconButton(
            icon: Icon(
              Icons.home_outlined,
              color: provider.selectedTabIndex == 0
                  ? AppTheme.primaryColor
                  : theme.textTheme.bodySmall?.color,
              size: 26,
            ),
            onPressed: () => provider.setSelectedTabIndex(0),
          ),

          // Center blood drop button
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFF333333),
              shape: BoxShape.circle,
            ),
            child: IconButton(
                icon: const Icon(
                  Icons.water_drop_outlined,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  provider.setSelectedTabIndex(1);
                  Navigator.pushNamed(context, '/donate');
                }),
          ),

          // Profile icon
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: provider.selectedTabIndex == 2
                  ? AppTheme.primaryColor
                  : theme.textTheme.bodySmall?.color,
              size: 26,
            ),
            onPressed: () {
              provider.setSelectedTabIndex(2);
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
    );
  }
}

// Custom painter for blood bag icon
class BloodBagPainter extends CustomPainter {
  final Color color;

  BloodBagPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw the blood bag bottom part
    final Path bagPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.3)
      ..lineTo(size.width * 0.2, size.height * 0.9)
      ..lineTo(size.width * 0.8, size.height * 0.9)
      ..lineTo(size.width * 0.8, size.height * 0.3)
      ..close();

    canvas.drawPath(bagPath, paint);

    // Draw the top connector part (outline)
    final Paint outlinePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Path topPath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.3)
      ..lineTo(size.width * 0.3, size.height * 0.1)
      ..lineTo(size.width * 0.7, size.height * 0.1)
      ..lineTo(size.width * 0.7, size.height * 0.3);

    canvas.drawPath(topPath, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
