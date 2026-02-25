class CanDevice {
  final String name;
  final bool isConnected;
  final double temperature;
  final String lastMessage;

  CanDevice({
    required this.name, 
    required this.isConnected, 
    required this.temperature, 
    required this.lastMessage
  });
}