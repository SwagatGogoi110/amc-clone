import 'package:flutter/foundation.dart';

class VehicleDetailsProvider extends ChangeNotifier{
  Map<String, dynamic>? _vehicleDetails;

  Map<String, dynamic>? get vehicleDetails => _vehicleDetails;

  void setVehicleDetails(Map<String, dynamic> details){
    _vehicleDetails = details;
    notifyListeners();
  }
}