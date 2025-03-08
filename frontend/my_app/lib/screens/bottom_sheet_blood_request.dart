// main.dart

import 'package:flutter/material.dart';
import 'package:my_app/provider/blood_donation_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Donation App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFF1654),
          secondary: Color(0xFFFF1654),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFFF1654)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF1654),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Donation'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showBloodTypeSheet(context);
          },
          child: const Text('Start Donation Process'),
        ),
      ),
    );
  }
}

// Step 1: Blood Type Selection Sheet
void showBloodTypeSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const BloodTypeSelectionSheet(),
  );
}

class BloodTypeSelectionSheet extends StatelessWidget {
  const BloodTypeSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BloodDonationProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // List of blood types
    final List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BLOOD TYPE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Wrap(
          spacing: screenWidth * 0.03,
          runSpacing: MediaQuery.of(context).size.height * 0.015,
          children: bloodTypes.map((type) {
            bool isSelected = provider.formData.bloodType == type;
            return GestureDetector(
              onTap: () {
                provider.setBloodType(type);
              },
              child: Container(
                width: (screenWidth - screenWidth * 0.15) / 4,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black54,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            showAddressSheet(context);
          },
          child: const Text('NEXT'),
        ),
      ],
    );
  }
}

// Step 2: Address Details Sheet
void showAddressSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const AddressSheet(),
  );
}

class AddressSheet extends StatelessWidget {
  const AddressSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BloodDonationProvider>(context);
    final formData = provider.formData;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LOCATION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'LOCATION',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) => provider.setLocation(value),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'STATE',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) => provider.setState(value),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              TextField(
                decoration: InputDecoration(
                  hintText: 'ADDRESS',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  suffixIcon: Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onChanged: (value) => provider.setAddress(value),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              TextField(
                decoration: InputDecoration(
                  hintText: 'HOSPITAL NAME',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  suffixIcon: Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onChanged: (value) => provider.setHospitalName(value),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showBloodTypeSheet(context);
              },
              child: Text(
                'PREVIOUS',
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: formData.isAddressValid
                  ? () {
                      Navigator.pop(context);
                      showRequirementSheet(context);
                    }
                  : null,
              child: const Text('NEXT'),
            ),
          ],
        ),
      ],
    );
  }
}

// Step 3: Requirement Sheet
void showRequirementSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const RequirementSheet(),
  );
}

class RequirementSheet extends StatelessWidget {
  const RequirementSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BloodDonationProvider>(context);
    final formData = provider.formData;

    // Blood use options
    final List<String> bloodUseOptions = [
      'Surgery',
      'Accident',
      'Cancer Treatment',
      'Childbirth',
      'Anemia',
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Requirement',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'REQUIREMENT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              GestureDetector(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    provider.setDate(pickedDate);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          formData.date != null
                              ? DateFormat('yyyy-MM-dd').format(formData.date!)
                              : 'DATE',
                          style: TextStyle(
                            color: formData.date != null
                                ? Colors.black
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'BLOOD USED FOR',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                value: formData.bloodUseFor,
                icon: const Icon(Icons.arrow_drop_down),
                items: bloodUseOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    provider.setBloodUseFor(value);
                  }
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                children: [
                  Checkbox(
                    value: formData.agreeToTerms,
                    onChanged: (value) {
                      if (value != null) {
                        provider.setAgreeToTerms(value);
                      }
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  const Text(
                    'I AGREE ALL ',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    'TERMS & CONDITIONS',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showAddressSheet(context);
              },
              child: Text(
                'PREVIOUS',
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: formData.isRequirementValid
                  ? () {
                      Navigator.pop(context);
                      showUrgencySheet(context);
                    }
                  : null,
              child: const Text('SUBMIT'),
            ),
          ],
        ),
      ],
    );
  }
}

// Step 4: Urgency Sheet
void showUrgencySheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const UrgencySheet(),
  );
}

class UrgencySheet extends StatelessWidget {
  const UrgencySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BloodDonationProvider>(context);
    final formData = provider.formData;

    // Urgency levels
    final List<String> urgencyLevels = ['Critical', 'Moderate', 'Low'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Requirement',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'URGENCY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'TYPE',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                value: formData.urgency,
                icon: const Icon(Icons.arrow_drop_down),
                items: urgencyLevels.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    provider.setUrgency(value);
                  }
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                children: [
                  Checkbox(
                    value: formData.agreeToTerms,
                    onChanged: (value) {
                      if (value != null) {
                        provider.setAgreeToTerms(value);
                      }
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  const Text(
                    'I AGREE ALL ',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    'TERMS & CONDITIONS',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showRequirementSheet(context);
              },
              child: Text(
                'PREVIOUS',
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: formData.isUrgencyValid
                  ? () async {
                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                      // Submit form
                      final success = await provider.submitForm();

                      // Close loading dialog
                      if (context.mounted) Navigator.of(context).pop();
                      // Close urgency sheet
                      Navigator.of(context).pop();

                      // Show result dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            success ? 'Success!' : 'Error',
                          ),
                          content: Text(
                            success
                                ? 'Your blood donation request has been submitted successfully.'
                                : 'There was an error submitting your request. Please try again.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  : null,
              child: const Text('SUBMIT'),
            ),
          ],
        ),
      ],
    );
  }
}
