import 'package:flutter/material.dart';
import 'package:my_app/provider/blood_inventory_provider.dart';
import 'package:my_app/screens/blood_bank_details_screen.dart';
import 'package:provider/provider.dart';

class BloodBanksScreen extends StatefulWidget {
  const BloodBanksScreen({Key? key}) : super(key: key);

  @override
  State<BloodBanksScreen> createState() => _BloodBanksScreenState();
}

class _BloodBanksScreenState extends State<BloodBanksScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when screen loads
    Future.microtask(() =>
        Provider.of<BloodBankProvider>(context, listen: false)
            .fetchBloodBanks());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final provider = Provider.of<BloodBankProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Blood Banks Near You', style: theme.textTheme.titleMedium,),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Location header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.02,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: theme.primaryColor,
                    size: size.width * 0.06,
                  ),
                  SizedBox(width: size.width * 0.02),
                  Text(
                    provider.currentLocation,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            // Blood banks list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.01,
                ),
                itemCount: provider.bloodBanks.length,
                itemBuilder: (context, index) {
                  final bloodBank = provider.bloodBanks[index];
                  return _buildBloodBankCard(
                    context,
                    bloodBank,
                    size,
                    theme,
                  );
                },
              ),
            ),

            // Emergency contact button
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(size.width * 0.04),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(size.width * 0.03),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need Blood?',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.red[300],
                            ),
                          ),
                          SizedBox(height: size.height * 0.005),
                          Text(
                            'Call Emergency Services',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sos');
                        // Emergency contact action
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Emergency Contact'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodBankCard(
    BuildContext context,
    BloodBank bloodBank,
    Size size,
    ThemeData theme,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: size.height * 0.015),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BloodBankDetailScreen(bloodBank: bloodBank),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bloodBank.name,
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: size.width * 0.045,
                        ),
                        SizedBox(width: size.width * 0.01),
                        Text(
                          '${bloodBank.rating} · ${bloodBank.reviewCount} reviews',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: theme.primaryColor,
                          size: size.width * 0.045,
                        ),
                        SizedBox(width: size.width * 0.01),
                        Expanded(
                          child: Text(
                            bloodBank.address,
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${bloodBank.distance} km',
                    style: theme.textTheme.bodySmall,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: theme.textTheme.bodySmall?.color,
                    size: size.width * 0.04,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
