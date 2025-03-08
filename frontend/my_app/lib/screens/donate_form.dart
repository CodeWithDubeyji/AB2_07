import 'package:flutter/material.dart';
import 'package:my_app/provider/donate_provider.dart';
import 'package:my_app/provider/home_screen_provider.dart';
import 'package:my_app/provider/nav_bar_provider.dart';
import 'package:provider/provider.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DonateProvider(),
      child: const _DonateScreenContent(),
    );
  }
}

class _DonateScreenContent extends StatelessWidget {
  const _DonateScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<DonateProvider>(context);
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
        title: Text('Donate', style: theme.textTheme.bodyLarge),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              bottomNavProvider.setSelectedIndex(0);
            }),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Column(
            children: [
              // Form Fields
              Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    children: [
                      // Date Field
                      _buildInputField(
                        context: context,
                        label: "Date",
                        suffixIcon: Icons.calendar_today,
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (pickedDate != null) {
                            provider.setDate(pickedDate);
                          }
                        },
                        value: provider.formattedDate,
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Time Field with AM/PM Toggle
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              context: context,
                              label: "Time",
                              suffixIcon: Icons.access_time,
                              onTap: () async {
                                final TimeOfDay? pickedTime =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  provider.setTime(pickedTime);
                                }
                              },
                              value: provider.selectedTime != null
                                  ? "${provider.selectedTime!.hourOfPeriod}:${provider.selectedTime!.minute.toString().padLeft(2, '0')}"
                                  : null,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          _buildAmPmToggle(context, theme, provider),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Time Needed Field
                      _buildInputField(
                        context: context,
                        label: "Time Needed",
                        suffixIcon: Icons.timer,
                        onTap: () {
                          // Show a duration picker or dropdown here
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Select Time Needed'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    '30 minutes',
                                    '1 hour',
                                    '2 hours',
                                    '3 hours',
                                    '4+ hours',
                                  ]
                                      .map((time) => ListTile(
                                            title: Text(time),
                                            onTap: () {
                                              provider.setTimeNeeded(time);
                                              Navigator.pop(context);
                                            },
                                          ))
                                      .toList(),
                                ),
                              );
                            },
                          );
                        },
                        value: provider.selectedTimeNeeded,
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Location Field
                      _buildInputField(
                        label: "Location",
                        suffixIcon: Icons.location_on,
                        context: context,
                        onTap: () {
                          // Show a location picker here
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Select Location'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    'Andheri',
                                    'Bandra',
                                    'Bhandup',
                                    'Borivali',
                                    'Vasai',
                                  ]
                                      .map((location) => ListTile(
                                            title: Text(location),
                                            onTap: () {
                                              provider.setLocation(location);
                                              Navigator.pop(context);
                                            },
                                          ))
                                      .toList(),
                                ),
                              );
                            },
                          );
                        },
                        value: provider.selectedLocation,
                      ),
                    ],
                  ),
                ),
              ),

              // Error message
              if (provider.status == DonationStatus.error)
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.02),
                  child: Text(
                    provider.errorMessage,
                    style: TextStyle(color: Colors.red[700], fontSize: 14),
                  ),
                ),

              _buildCampaignDropdown(context, provider),

              const Spacer(),

              // Donate Button
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  onPressed: provider.isFormValid
                      ? () async {
                          final success = await provider.submitDonation();
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Donation scheduled successfully!')),
                            );
                            Navigator.pop(context);
                            // Navigate back or to confirmation screen
                            // Navigator.of(context).pop();
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: theme.colorScheme.onPrimary,
                    //disabledBackgroundColor: theme.primaryColor.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: provider.status == DonationStatus.loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Donate',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmPmToggle(
      BuildContext context, ThemeData theme, DonateProvider provider) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenWidth * 0.12,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
              text: 'AM',
              isSelected: provider.selectedAmPm == 'AM',
              onTap: () => provider.setAmPm('AM'),
              theme: theme,
              context: context),
          _buildToggleButton(
              text: 'PM',
              isSelected: provider.selectedAmPm == 'PM',
              onTap: () => provider.setAmPm('PM'),
              theme: theme,
              context: context),
        ],
      ),
    );
  }

  Widget _buildCampaignDropdown(BuildContext context, DonateProvider provider) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.03, horizontal: screenWidth * 0.045),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.025, vertical: screenWidth * 0.02),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            'List of available campaigns on this date',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          value: provider.selectedCampaign,
          items: provider.availableCampaigns.map((String campaign) {
            return DropdownMenuItem<String>(
              value: campaign,
              child: Text(
                campaign,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: provider.selectedTime != null
              ? (String? newValue) {
                  provider.setSelectedCampaign(newValue);
                }
              : null,
          icon: Icon(
            Icons.arrow_drop_down,
            color: provider.selectedTime != null
                ? theme.primaryColor
                : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeData theme,
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.12,
        height: screenWidth * 0.12,
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData suffixIcon,
    required VoidCallback onTap,
    String? value,
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenWidth * 0.05),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            if (value != null)
              Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.02),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
            Icon(
              suffixIcon,
              color: Colors.grey.shade500,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
