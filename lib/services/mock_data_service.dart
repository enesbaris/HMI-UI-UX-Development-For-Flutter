import 'dart:async';
import 'dart:math';
import '../models/vehicle_state.dart';
import '../models/can_device.dart';
import '../models/detected_object.dart';
import 'package:flutter/material.dart';

class MockDataService {
  final _controller = StreamController<VehicleState>.broadcast();
  Stream<VehicleState> get stateStream => _controller.stream;
  Timer? _timer;
  bool _isAuto = false;
  bool _isEmergency = false;
  final Random _rnd = Random();

  void startSimulating() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (_isEmergency) {
        _controller.add(_getEmergencyState());
        return;
      }

      double time = (t.tick % 200) / 10.0; 
      double currentSpeed = time <= 10 ? time * 6 : 60 - ((time - 10) * 6);
      double battery = 94.2 - (t.tick / 5000);

      _controller.add(VehicleState(
        speed: currentSpeed,
        batteryLevel: battery,
        range: battery * 4.2,
        lidarData: List.generate(7, (_) => 1.5 + _rnd.nextDouble() * 3.5),
        cellVoltages: List.generate(24, (_) => 3.3 + _rnd.nextDouble() * 0.15),
        cellTemps: List.generate(24, (_) => 32.0 + _rnd.nextDouble() * 8.0),
        canLines: {
          1: [CanDevice(name: "ECU_MAIN", isConnected: true, temperature: 40.5, lastMessage: "SYNC_OK")],
          2: [CanDevice(name: "LiDAR_A", isConnected: true, temperature: 38.2, lastMessage: "DATA_TX")],
          3: [CanDevice(name: "DRV_MOTOR", isConnected: true, temperature: 45.0 + (currentSpeed/2), lastMessage: "PWM_ON")],
        },
        isAutonomous: _isAuto,
        isEmergency: false,
        leftSignal: (t.tick % 15 < 7) && currentSpeed > 0,
        rightSignal: false,
        detections: _isAuto ? [DetectedObject(label: "ENGEL", box: const Rect.fromLTWH(140, 90, 80, 50), confidence: 0.98, color: const Color(0xFF00FFF2))] : [],
      ));
    });
  }

  VehicleState _getEmergencyState() => VehicleState(
    speed: 0, batteryLevel: 94.0, range: 400,
    lidarData: List.filled(7, 0),
    cellVoltages: List.filled(24, 3.3),
    cellTemps: List.filled(24, 30.0),
    canLines: {1: [], 2: [], 3: []},
    detections: [], isEmergency: true,
  );

  void toggleAuto(bool v) => _isAuto = v;
  void toggleEmergency(bool v) => _isEmergency = v;
  void dispose() { _timer?.cancel(); _controller.close(); }
}