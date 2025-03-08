import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:my_app/provider/blood_inventory_provider.dart';
import 'package:latlong2/latlong.dart';

class BloodBankDetailScreen extends StatelessWidget {
  final BloodBank bloodBank;

  const BloodBankDetailScreen({
    Key? key,
    required this.bloodBank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(bloodBank.name, style: theme.textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map view
              SizedBox(
                height: size.height * 0.25,
                width: double.infinity,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(bloodBank.latitude, bloodBank.longitude),
                    initialZoom: 14.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: size.width * 0.1,
                          height: size.width * 0.1,
                          point: LatLng(bloodBank.latitude, bloodBank.longitude),
                          child: Icon(
                            Icons.location_on,
                            color: theme.primaryColor,
                            size: size.width * 0.08,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Blood bank details
              Padding(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bloodBank.name,
                                style: theme.textTheme.titleLarge,
                              ),
                              SizedBox(height: size.height * 0.01),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: size.width * 0.05,
                                  ),
                                  SizedBox(width: size.width * 0.01),
                                  Text(
                                    '${bloodBank.rating} · ${bloodBank.reviewCount} reviews',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.03,
                            vertical: size.width * 0.015,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${bloodBank.distance} km',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: size.height * 0.025),
                    
                    // Description
                    Text(
                      'About',
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      bloodBank.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                    
                    SizedBox(height: size.height * 0.025),
                    
                    // Contact information
                    Text(
                      'Contact Information',
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: size.height * 0.01),
                    _buildInfoRow(
                      context,
                      Icons.location_on,
                      bloodBank.address,
                      size,
                      theme,
                    ),
                    SizedBox(height: size.height * 0.01),
                    _buildInfoRow(
                      context,
                      Icons.phone,
                      bloodBank.phoneNumber,
                      size,
                      theme,
                    ),
                    SizedBox(height: size.height * 0.01),
                    _buildInfoRow(
                      context,
                      Icons.email,
                      bloodBank.email,
                      size,
                      theme,
                    ),
                    SizedBox(height: size.height * 0.01),
                    _buildInfoRow(
                      context,
                      Icons.access_time,
                      bloodBank.operationHours,
                      size,
                      theme,
                    ),
                    
                    SizedBox(height: size.height * 0.025),
                    
                    // Blood inventory
                    Text(
                      'Blood Inventory',
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: size.height * 0.01),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: size.width * 0.03,
                      mainAxisSpacing: size.width * 0.03,
                      ),
                      itemCount: bloodBank.bloodInventory.length,
                      itemBuilder: (context, index) {
                      final item = bloodBank.bloodInventory[index];
                      return StatefulBuilder(
                        builder: (context, setState) {
                        bool isSelected = false;
                        return GestureDetector(
                          onTap: () {
                          setState(() {
                            isSelected = !isSelected;
                          });
                          },
                          child: Card(
                          color: isSelected ? Colors.red : Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.03),
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                              children: [
                                Icon(
                                Icons.water_drop,
                                color: item.typeColor,
                                size: size.width * 0.06,
                                ),
                                SizedBox(width: size.width * 0.01),
                                Text(
                                item.type,
                                style: theme.textTheme.titleMedium,
                                ),
                              ],
                              ),
                              SizedBox(height: size.height * 0.01),
                              Text(
                              '${item.units} units',
                              style: theme.textTheme.bodyLarge,
                              ),
                              Text(
                              item.statusText,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: item.statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ],
                            ),
                          ),
                          ),
                        );
                        },
                      );
                      },
                    ),
                    
                    SizedBox(height: size.height * 0.03),
                    
                    // Request donation button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          SnackBar snackBar = SnackBar(
                            content: Text('Donation request sent!'),
                            backgroundColor: Colors.green,
                          );
                          Navigator.pushNamed(context, '/navbar');
                          // Request donation action
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Request Donation',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String text,
    Size size,
    ThemeData theme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: theme.primaryColor,
          size: size.width * 0.05,
        ),
        SizedBox(width: size.width * 0.02),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildBloodTypeCard(
    BuildContext context,
    BloodInventoryItem item,
    Size size,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.water_drop,
                  color: item.typeColor,
                  size: size.width * 0.06,
                ),
                SizedBox(width: size.width * 0.01),
                Text(
                  item.type,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              '${item.units} units',
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              item.statusText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: item.statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}