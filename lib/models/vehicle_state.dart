import 'can_device.dart';
import 'detected_object.dart';

class VehicleState {
  final double speed;
  final double batteryLevel;
  final double range;
  final List<double> lidarData;
  final List<double> cellVoltages;
  final List<double> cellTemps; // Hücre Sıcaklıkları
  final Map<int, List<CanDevice>> canLines;
  final bool isAutonomous;
  final bool isEmergency;
  final bool leftSignal;
  final bool rightSignal;
  final List<DetectedObject> detections;

  VehicleState({
    required this.speed,
    required this.batteryLevel,
    required this.range,
    required this.lidarData,
    required this.cellVoltages,
    required this.cellTemps,
    required this.canLines,
    required this.detections,
    this.isAutonomous = false,
    this.isEmergency = false,
    this.leftSignal = false,
    this.rightSignal = false,
  });

  factory VehicleState.initial() => VehicleState(
    speed: 0, batteryLevel: 94.0, range: 400,
    lidarData: List.filled(7, 0.0),
    cellVoltages: List.filled(24, 3.3),
    cellTemps: List.filled(24, 25.0),
    canLines: {1: [], 2: [], 3: []},
    detections: [],
  );
}