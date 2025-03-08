import 'package:flutter/material.dart';
import 'package:my_app/provider/blood_donation_provider.dart';
import 'package:my_app/provider/find_donor_step_dialog.dart';
import 'package:my_app/provider/home_screen_provider.dart';
import 'package:my_app/screens/finddonor_popup.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/chatbot');
          
        },
        child: Icon(Icons.message),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.errorMessage != null
                ? _buildErrorWidget(provider.errorMessage!)
                : _buildMainContent(context, provider, size, theme),
      ),
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
          Navigator.pushNamed(context, '/sos');
        },
        child: Container(
          height: size.height * 0.07,
          width: size.width * 0.94,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text('Emergency SOS', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
              startDonorFlow(context);
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
                      'INVITE YOUR FRIENDS OR FAMILY MEMBERS TO DONATE BLOOD',
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

// Main application entry point
void startDonorFlow(BuildContext context) {
  final provider = Provider.of<DonorDataProvider>(context, listen: false);
  provider.resetData();
  _showCurrentStepDialog(context);
}

void _showCurrentStepDialog(BuildContext context) {
  final provider = Provider.of<DonorDataProvider>(context, listen: false);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => _buildDialogForStep(dialogContext, provider),
  ).then((_) {
    // Check if we need to show the next dialog
    if (provider.currentStep != DonorFlowStep.bloodType &&
        provider.currentStep != DonorFlowStep.complete) {
      _showCurrentStepDialog(context);
    } else if (provider.currentStep == DonorFlowStep.complete) {
      // Show completion dialog once
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) =>
            _buildDialogForStep(dialogContext, provider),
      );
    }
  });
}

Widget _buildDialogForStep(
    BuildContext dialogContext, DonorDataProvider provider) {
  switch (provider.currentStep) {
    case DonorFlowStep.bloodType:
      return const BloodTypeDialog();
    case DonorFlowStep.address:
      return const AddressDialog();
    case DonorFlowStep.requirement:
      return const RequirementDialog();
    case DonorFlowStep.urgency:
      return const UrgencyDialog();
    
    default:
      return const BloodTypeDialog();
  }
}

// Base Dialog class that all step dialogs extend from
class StepDialog extends StatelessWidget {
  final String title;
  final Widget child;

  const StepDialog({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: mediaQuery.size.width * 0.9,
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: mediaQuery.size.height * 0.8,
        ),
        padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const Divider(),
            Flexible(
              child: SingleChildScrollView(
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BloodTypeDialog extends StatelessWidget {
  const BloodTypeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DonorDataProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    final bloodTypes = [
      'A+',
      'A-',
      'B+',
      'B-',
      'AB+',
      'AB-',
      'O+',
      'O-',
    ];

    return StepDialog(
      title: 'BLOOD TYPE',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: bloodTypes.length,
            itemBuilder: (context, index) {
              final bloodType = bloodTypes[index];
              final isSelected = provider.selectedBloodType == bloodType;

              return GestureDetector(
                onTap: () => provider.selectBloodType(bloodType),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? theme.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      bloodType,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: mediaQuery.size.height * 0.04),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: provider.selectedBloodType != null
                  ? () {
                      provider.goToNextStep();
                      Navigator.of(context).pop();
                    }
                  : null,
              child: const Text('NEXT'),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressDialog extends StatelessWidget {
  const AddressDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DonorDataProvider>(context);
    final mediaQuery = MediaQuery.of(context);

    return StepDialog(
      title: 'LOCATION',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: mediaQuery.size.height * 0.02),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    onChanged: provider.updateLocation,
                    decoration: const InputDecoration(
                      hintText: 'LOCATION',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: mediaQuery.size.width * 0.02),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    onChanged: provider.updateState,
                    decoration: const InputDecoration(
                      hintText: 'STATE',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: mediaQuery.size.height * 0.02),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              onChanged: provider.updateAddress,
              decoration: InputDecoration(
                hintText: 'ADDRESS',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: mediaQuery.size.height * 0.02),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              onChanged: provider.updateHospitalName,
              decoration: InputDecoration(
                hintText: 'HOSPITAL NAME',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: mediaQuery.size.height * 0.04),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    provider.goToPreviousStep();
                    Navigator.of(context).pop();
                  },
                  child: const Text('PREVIOUS'),
                ),
              ),
              SizedBox(width: mediaQuery.size.width * 0.02),
              Expanded(
                child: ElevatedButton(
                  onPressed: provider.address.isNotEmpty &&
                          provider.hospitalName.isNotEmpty
                      ? () {
                          provider.goToNextStep();
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('NEXT'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RequirementDialog extends StatelessWidget {
  const RequirementDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DonorDataProvider>(context);
    final mediaQuery = MediaQuery.of(context);

    return StepDialog(
      title: 'REQUIREMENT',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: mediaQuery.size.height * 0.02),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                provider.updateRequirementDate(date);
              }
            },
            child: TextField(
              enabled: false,
              controller: TextEditingController(
                text: provider.requirementDate != null
                    ? '${provider.requirementDate!.day}/${provider.requirementDate!.month}/${provider.requirementDate!.year}'
                    : '',
              ),
              decoration: InputDecoration(
                hintText: 'DATE',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: mediaQuery.size.height * 0.02),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              hintText: 'BLOOD USED FOR',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            items: const [
              DropdownMenuItem(value: 'Surgery', child: Text('Surgery')),
              DropdownMenuItem(value: 'Accident', child: Text('Accident')),
              DropdownMenuItem(
                  value: 'Cancer Treatment', child: Text('Cancer Treatment')),
              DropdownMenuItem(value: 'Anemia', child: Text('Anemia')),
              DropdownMenuItem(value: 'Childbirth', child: Text('Childbirth')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (value) {
              if (value != null) {
                provider.updateBloodUsedFor(value);
              }
            },
          ),
          SizedBox(height: mediaQuery.size.height * 0.02),
          Row(
            children: [
              Checkbox(
                value: provider.agreedToTerms,
                onChanged: (value) {
                  if (value != null) {
                    provider.toggleTermsAgreement(value);
                  }
                },
              ),
              const Text('I AGREE ALL '),
              TextButton(
                onPressed: () {
                  // Show terms and conditions
                },
                child: const Text('TERMS & CONDITIONS'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
              ),
            ],
          ),
          SizedBox(height: mediaQuery.size.height * 0.04),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    provider.goToPreviousStep();
                    Navigator.of(context).pop();
                  },
                  child: const Text('PREVIOUS'),
                ),
              ),
              SizedBox(width: mediaQuery.size.width * 0.02),
              Expanded(
                child: ElevatedButton(
                  onPressed: provider.requirementDate != null &&
                          provider.bloodUsedFor.isNotEmpty &&
                          provider.agreedToTerms
                      ? () {
                          provider.goToNextStep();
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('NEXT'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UrgencyDialog extends StatelessWidget {
  const UrgencyDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DonorDataProvider>(context);
    final mediaQuery = MediaQuery.of(context);

    return StepDialog(
      title: 'URGENCY',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: mediaQuery.size.height * 0.02),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              hintText: 'TYPE',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            items: const [
              DropdownMenuItem(value: 'Urgent', child: Text('Urgent')),
              DropdownMenuItem(value: 'Moderate', child: Text('Moderate')),
              DropdownMenuItem(value: 'Low', child: Text('Low')),
            ],
            onChanged: (value) {
              if (value != null) {
                provider.updateUrgencyLevel(value);
              }
            },
          ),
          SizedBox(height: mediaQuery.size.height * 0.02),
          Row(
            children: [
              Checkbox(
                value: provider.agreedToTerms,
                onChanged: (value) {
                  if (value != null) {
                    provider.toggleTermsAgreement(value);
                  }
                },
              ),
              const Text('I AGREE ALL '),
              TextButton(
                onPressed: () {
                  // Show terms and conditions
                },
                child: const Text('TERMS & CONDITIONS'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
              ),
            ],
          ),
          SizedBox(height: mediaQuery.size.height * 0.04),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    provider.goToPreviousStep();
                    Navigator.of(context).pop();
                  },
                  child: const Text('PREVIOUS'),
                ),
              ),
              SizedBox(width: mediaQuery.size.width * 0.02),
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      provider.urgencyLevel.isNotEmpty && provider.agreedToTerms
                          ? () async {
                              final success = await provider.submitDonorData();
                              if (success) {
                                provider.goToNextStep();
                                Navigator.pushNamed(context, '/donorlist');
                              }
                            }
                          : null,
                  child: const Text('SUBMIT'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

