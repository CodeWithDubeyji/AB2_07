import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Provider for Blood Bank data
class BloodBankProvider with ChangeNotifier {
  List<BloodBank> _bloodBanks = [
    BloodBank(
      id: '1',
      name: 'LifeFlow Blood Center',
      address: '123 Medical Parkway, San Francisco, CA',
      distance: 1.2,
      rating: 4.8,
      reviewCount: 124,
      latitude: 37.773972,
      longitude: -122.431297,
      phoneNumber: '+1 (415) 555-1234',
      email: 'info@lifeflowblood.org',
      operationHours: 'Mon-Fri: 8AM-8PM, Sat-Sun: 9AM-5PM',
      description: 'LifeFlow Blood Center is a state-of-the-art facility dedicated to collecting and distributing blood products throughout the Bay Area. We offer a comfortable donation experience with minimal wait times.',
      bloodInventory: [
        BloodInventoryItem(type: 'A+', units: 45, status: InventoryStatus.wellStocked),
        BloodInventoryItem(type: 'A-', units: 12, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'B+', units: 23, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'B-', units: 5, status: InventoryStatus.lowSupply),
        BloodInventoryItem(type: 'O+', units: 38, status: InventoryStatus.wellStocked),
        BloodInventoryItem(type: 'O-', units: 8, status: InventoryStatus.lowSupply),
        BloodInventoryItem(type: 'AB+', units: 15, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'AB-', units: 3, status: InventoryStatus.lowSupply),
      ],
    ),
    BloodBank(
      id: '2',
      name: 'RedCross Blood Bank',
      address: '456 Health Avenue, San Francisco, CA',
      distance: 2.5,
      rating: 4.5,
      reviewCount: 98,
      latitude: 37.783972,
      longitude: -122.441297,
      phoneNumber: '+1 (415) 555-2345',
      email: 'sanfran@redcross.org',
      operationHours: 'Mon-Fri: 9AM-7PM, Sat: 10AM-4PM, Sun: Closed',
      description: 'The Red Cross Blood Bank is part of a nationwide network providing essential blood services. Our center serves the community with regular blood drives and donation opportunities.',
      bloodInventory: [
        BloodInventoryItem(type: 'A+', units: 32, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'A-', units: 9, status: InventoryStatus.lowSupply),
        BloodInventoryItem(type: 'B+', units: 28, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'B-', units: 7, status: InventoryStatus.lowSupply),
        BloodInventoryItem(type: 'O+', units: 52, status: InventoryStatus.wellStocked),
        BloodInventoryItem(type: 'O-', units: 12, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'AB+', units: 11, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'AB-', units: 4, status: InventoryStatus.lowSupply),
      ],
    ),
    BloodBank(
      id: '3',
      name: 'CityLife Blood Services',
      address: '789 Community Blvd, San Francisco, CA',
      distance: 3.1,
      rating: 4.3,
      reviewCount: 67,
      latitude: 37.763972,
      longitude: -122.421297,
      phoneNumber: '+1 (415) 555-3456',
      email: 'contact@citylifeblood.com',
      operationHours: 'Mon-Thu: 8AM-6PM, Fri: 8AM-8PM, Sat: 9AM-3PM, Sun: Closed',
      description: 'CityLife Blood Services is a community-focused center providing blood collection and testing services. We pride ourselves on our efficient processes and friendly staff.',
      bloodInventory: [
        BloodInventoryItem(type: 'A+', units: 28, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'A-', units: 7, status: InventoryStatus.lowSupply),
        BloodInventoryItem(type: 'B+', units: 19, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'B-', units: 4, status: InventoryStatus.lowSupply),
        BloodInventoryItem(type: 'O+', units: 31, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'O-', units: 9, status: InventoryStatus.lowSupply),
        BloodInventoryItem(type: 'AB+', units: 8, status: InventoryStatus.lowSupply),
        BloodInventoryItem(type: 'AB-', units: 2, status: InventoryStatus.lowSupply),
      ],
    ),
    BloodBank(
      id: '4',
      name: 'Bay Area Donation Center',
      address: '321 Bay Street, San Francisco, CA',
      distance: 4.7,
      rating: 4.6,
      reviewCount: 83,
      latitude: 37.793972,
      longitude: -122.411297,
      phoneNumber: '+1 (415) 555-4567',
      email: 'info@bayareadonation.org',
      operationHours: 'Mon-Fri: 7AM-9PM, Sat-Sun: 8AM-6PM',
      description: 'Bay Area Donation Center is a modern facility offering comprehensive blood services. We use the latest technology to ensure a safe and comfortable donation experience.',
      bloodInventory: [
        BloodInventoryItem(type: 'A+', units: 41, status: InventoryStatus.wellStocked),
        BloodInventoryItem(type: 'A-', units: 13, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'B+', units: 25, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'B-', units: 6, status: InventoryStatus.lowSupply),
        BloodInventoryItem(type: 'O+', units: 47, status: InventoryStatus.wellStocked),
        BloodInventoryItem(type: 'O-', units: 15, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'AB+', units: 12, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'AB-', units: 5, status: InventoryStatus.lowSupply),
      ],
    ),
    BloodBank(
      id: '5',
      name: 'Golden Gate Blood Bank',
      address: '555 Golden Gate Ave, San Francisco, CA',
      distance: 5.3,
      rating: 4.2,
      reviewCount: 42,
      latitude: 37.753972,
      longitude: -122.451297,
      phoneNumber: '+1 (415) 555-5678',
      email: 'contact@goldengateblood.org',
      operationHours: 'Mon-Fri: 9AM-5PM, Sat: 10AM-2PM, Sun: Closed',
      description: 'Golden Gate Blood Bank serves the southern San Francisco area. We focus on making blood donation accessible to all community members with extended hours and mobile donation units.',
      bloodInventory: [
        BloodInventoryItem(type: 'A+', units: 22, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'A-', units: 6, status: InventoryStatus.lowSupply),
        BloodInventoryItem(type: 'B+', units: 18, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'B-', units: 3, status: InventoryStatus.lowSupply),
        BloodInventoryItem(type: 'O+', units: 29, status: InventoryStatus.adequate),
        BloodInventoryItem(type: 'O-', units: 7, status: InventoryStatus.lowSupply),
        BloodInventoryItem(type: 'AB+', units: 9, status: InventoryStatus.lowSupply),
        BloodInventoryItem(type: 'AB-', units: 2, status: InventoryStatus.lowSupply),
      ],
    ),
  ];

  String _currentLocation = 'San Francisco, CA';

  List<BloodBank> get bloodBanks => _bloodBanks;
  String get currentLocation => _currentLocation;

  void setCurrentLocation(String location) {
    _currentLocation = location;
    notifyListeners();
  }

  // This method would fetch real data from your backend
  Future<void> fetchBloodBanks() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    // In reality, you'd make a network request and parse the response here
    notifyListeners();
  }
}

// Blood Bank Model
class BloodBank {
  final String id;
  final String name;
  final String address;
  final double distance;
  final double rating;
  final int reviewCount;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String email;
  final String operationHours;
  final String description;
  final List<BloodInventoryItem> bloodInventory;

  BloodBank({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.email,
    required this.operationHours,
    required this.description,
    required this.bloodInventory,
  });
}

// Blood Inventory Model
enum InventoryStatus {
  wellStocked,
  adequate,
  lowSupply,
}

class BloodInventoryItem {
  final String type;
  final int units;
  final InventoryStatus status;

  BloodInventoryItem({
    required this.type,
    required this.units,
    required this.status,
  });

  Color get statusColor {
    switch (status) {
      case InventoryStatus.wellStocked:
        return Colors.green;
      case InventoryStatus.adequate:
        return Colors.orange;
      case InventoryStatus.lowSupply:
        return Colors.red;
    }
  }

  String get statusText {
    switch (status) {
      case InventoryStatus.wellStocked:
        return 'Well Stocked';
      case InventoryStatus.adequate:
        return 'Supply Adequate';
      case InventoryStatus.lowSupply:
        return 'Low Supply';
    }
  }

  Color get typeColor {
    switch (type) {
      case 'A+':
        return Colors.red;
      case 'A-':
        return Colors.redAccent;
      case 'B+':
        return Colors.blue;
      case 'B-':
        return Colors.blueAccent;
      case 'AB+':
        return Colors.purple;
      case 'AB-':
        return Colors.purpleAccent;
      case 'O+':
        return Colors.green;
      case 'O-':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }
}