import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/app_colors.dart';
import '../../models/vehicle_state.dart';
import '../../services/mock_data_service.dart';
import '../widgets/neon_module.dart';
import '../widgets/turn_signals.dart';
import '../widgets/frost_background.dart';
import '../widgets/dashboard_frame_painter.dart';
import '../widgets/hyper_speedo.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MockDataService _service = MockDataService();
  String _activePage = "ana";

  @override
  void initState() {
    super.initState();
    _service.startSimulating();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VehicleState>(
      stream: _service.stateStream,
      builder: (context, snapshot) {
        final s = snapshot.data ?? VehicleState.initial();
        final speedColor = s.speed <= 20 ? Colors.white : (s.speed <= 40 ? Colors.yellowAccent : AppColors.redNeon);

        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: AspectRatio(
              aspectRatio: 1024 / 600,
              child: CustomPaint(
                painter: DashboardFramePainter(),
                child: Stack(
                  children: [
                    if (!s.isEmergency) FrostBackground(isAutonomous: s.isAutonomous),
                    if (s.isEmergency) _buildEmergencyOverlay(),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Column(
                        children: [
                          _buildTopNav(s),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (_activePage == "ana") ...[
                                  HyperSpeedo(speed: s.speed, color: speedColor),
                                  _buildSidePanels(s),
                                ],
                                if (_activePage != "ana") _buildFullScreenDetail(s),
                              ],
                            ),
                          ),
                          _buildBottomDock(s),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopNav(VehicleState s) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      TurnSignal(isLeft: true, active: s.leftSignal),
      Text(s.isEmergency ? "SİSTEM KESİNTİSİ" : "NOVA DRIVE HYPER-OS v3.0", 
        style: const TextStyle(color: Colors.white, letterSpacing: 6, fontWeight: FontWeight.w900, fontSize: 13)),
      TurnSignal(isLeft: false, active: s.rightSignal),
    ],
  );

  Widget _buildSidePanels(VehicleState s) => Stack(
    children: [
      Positioned(top: 10, left: 0, child: NeonModule(onTap: () => setState(() => _activePage = "bms"), title: "BMS ANALİZ", color: AppColors.energyGreen, 
        content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("%${s.batteryLevel.toStringAsFixed(1)}", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
          Text("${s.range.toInt()} KM MENZİL", style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
        ]))),
      Positioned(bottom: 30, left: 0, child: NeonModule(onTap: () => setState(() => _activePage = "yolo"), title: "YOLO V12", color: AppColors.cyanNeon, 
        content: Text(s.isAutonomous ? "TAKİPTE" : "HAZIR", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))),
      Positioned(top: 10, right: 0, child: NeonModule(onTap: () => setState(() => _activePage = "lidar"), title: "LiDAR RADAR", color: AppColors.cyanNeon, isLeft: false,
        content: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(7, (i) => Container(
          width: 8, height: s.isEmergency ? 2 : (s.lidarData[i] * 18), decoration: BoxDecoration(color: AppColors.cyanNeon, borderRadius: BorderRadius.circular(2)),
        ))))),
      Positioned(bottom: 30, right: 0, child: NeonModule(onTap: () => setState(() => _activePage = "can"), title: "CAN BUS", color: AppColors.blueNeon, isLeft: false,
        content: Text("${s.canLines.length} AKTİF HAT", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))),
    ],
  );

  Widget _buildFullScreenDetail(VehicleState s) => Container(
    width: double.infinity, height: double.infinity,
    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white24)),
    padding: const EdgeInsets.all(20),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(_activePage.toUpperCase(), style: const TextStyle(color: AppColors.cyanNeon, fontSize: 24, fontWeight: FontWeight.w900)),
        IconButton(icon: const Icon(Icons.close_fullscreen, color: Colors.white, size: 35), onPressed: () => setState(() => _activePage = "ana")),
      ]),
      const Divider(color: Colors.white24),
      Expanded(child: _buildPanelContent(s)),
    ]),
  );

  Widget _buildPanelContent(VehicleState s) {
    if (_activePage == "enerji" || _activePage == "bms") return _buildBmsGrid(s);
    if (_activePage == "can") return _buildCanDetailed(s);
    if (_activePage == "lidar") return _buildLidarAnalysis(s);
    return const Center(child: Text("VERİ ALINIYOR...", style: TextStyle(color: Colors.white)));
  }

  Widget _buildCanDetailed(VehicleState s) => Row(
    children: [1, 2, 3].map((h) => Expanded(child: Container(
      margin: const EdgeInsets.all(5), padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("HAT $h", style: const TextStyle(color: AppColors.blueNeon, fontWeight: FontWeight.bold, fontSize: 16)),
        const Divider(color: Colors.white10),
        ...s.canLines[h]!.map((d) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(d.name, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              Text(d.lastMessage, style: const TextStyle(color: Colors.white24, fontSize: 9)),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Icon(Icons.circle, size: 6, color: d.isConnected ? AppColors.energyGreen : AppColors.redNeon),
              Text("${d.temperature.toStringAsFixed(1)}°C", style: const TextStyle(color: Colors.white54, fontSize: 9)),
            ]),
          ]),
        )).toList(),
      ]),
    ))).toList(),
  );

  Widget _buildBmsGrid(VehicleState s) => GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, childAspectRatio: 1.4, crossAxisSpacing: 8, mainAxisSpacing: 8),
    itemCount: 24,
    itemBuilder: (context, i) => Container(
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.energyGreen.withValues(alpha: 0.3))),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("H-${i+1}", style: const TextStyle(color: Colors.white38, fontSize: 8)),
        Text("${s.cellVoltages[i].toStringAsFixed(2)}V", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        Text("${s.cellTemps[i].toStringAsFixed(1)}°C", style: TextStyle(color: s.cellTemps[i] > 45 ? Colors.orange : AppColors.cyanNeon, fontSize: 10, fontWeight: FontWeight.bold)),
      ]),
    ),
  );

  Widget _buildLidarAnalysis(VehicleState s) => Column(children: [
    const Text("LiDAR MODEL MESAFE VERİLERİ", style: TextStyle(color: Colors.white70, letterSpacing: 3, fontSize: 12)),
    const Spacer(),
    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(7, (i) => Column(children: [
      Text("${s.lidarData[i].toStringAsFixed(2)}m", style: const TextStyle(color: AppColors.cyanNeon, fontWeight: FontWeight.bold, fontSize: 20)),
      const Icon(Icons.keyboard_arrow_up, color: Colors.white24),
      Text("S-${i+1}", style: const TextStyle(color: Colors.white30, fontSize: 9)),
    ]))),
    const Spacer(),
  ]);

  Widget _buildBottomDock(VehicleState s) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    _btn("MANUAL", AppColors.blueNeon, !s.isAutonomous && !s.isEmergency, () => _service.toggleAuto(false)),
    const SizedBox(width: 25),
    _btn("OTOPİLOT", AppColors.cyanNeon, s.isAutonomous && !s.isEmergency, () => _service.toggleAuto(true)),
    const SizedBox(width: 30),
    _btn(s.isEmergency ? "SİSTEMİ AÇ" : "ACİL STOP", s.isEmergency ? Colors.amber : AppColors.redNeon, s.isEmergency, 
      () => _service.toggleEmergency(!s.isEmergency), isSharp: true),
  ]);

  Widget _btn(String l, Color c, bool a, VoidCallback t, {bool isSharp = false}) => GestureDetector(
    onTap: t, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
      decoration: BoxDecoration(color: a ? c.withValues(alpha: 0.35) : Colors.transparent, border: Border.all(color: c, width: 2.5), borderRadius: BorderRadius.circular(isSharp ? 4 : 35)),
      child: Text(l, style: TextStyle(color: c, fontWeight: FontWeight.w900, fontSize: 11)),
    ),
  );

  Widget _buildEmergencyOverlay() => Container(
    decoration: BoxDecoration(gradient: RadialGradient(colors: [Colors.red.withValues(alpha: 0.5), Colors.black], radius: 1.2)),
    child: const Center(child: Text("ACİL DURUM\nSİSTEM BEKLEMEDE", textAlign: TextAlign.center, 
        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 6))),
  );
}