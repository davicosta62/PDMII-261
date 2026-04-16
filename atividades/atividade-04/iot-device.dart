import 'dart:io';
import 'dart:math';
import 'dart:async';

class IoTDevice {
  static const String serverHost = 'localhost';
  static const int serverPort = 8080;
  static const Duration sendInterval = Duration(seconds: 10);
  
  late Socket socket;
  late Timer timer;
  final Random random = Random();

  Future<void> connectAndStart() async {
    try {
      print('🔥 IoT Device iniciando...');
      print('📡 Conectando ao servidor $serverHost:$serverPort...');
      
      socket = await Socket.connect(serverHost, serverPort);
      print('✅ Conectado ao servidor com sucesso!');
      
      // Inicia o envio periódico de temperaturas
      timer = Timer.periodic(sendInterval, (timer) => sendTemperature());
      
      // Escuta respostas do servidor
      socket.listen(
        (data) {
          final message = String.fromCharCodes(data).trim();
          print('📨 Servidor responde: $message');
        },
        onError: (error) {
          print('❌ Erro na conexão: $error');
          timer.cancel();
          socket.destroy();
        },
        onDone: () {
          print('🔌 Conexão com servidor encerrada');
          timer.cancel();
        },
      );
      
    } catch (e) {
      print('❌ Falha ao conectar: $e');
    }
  }

  Future<void> sendTemperature() async {
    try {
      // Simula temperatura realista (15-35°C)
      double temperature = 25.0 + (random.nextDouble() - 0.5) * 20;
      temperature = double.parse(temperature.toStringAsFixed(1));
      
      final message = 'TEMP:$temperature°C';
      socket.write('$message\n');
      
      print('📤 Enviando: $message (${DateTime.now().toString().substring(11, 19)})');
      
    } catch (e) {
      print('❌ Erro ao enviar temperatura: $e');
    }
  }

  void disconnect() {
    timer.cancel();
    socket.destroy();
    print('🔌 IoT Device desconectado');
  }
}

void main() async {
  final iotDevice = IoTDevice();
  
  ProcessSignal.sigint.watch().listen((signal) {
    print('\n🛑 Sinal de interrupção recebido. Desconectando...');
    iotDevice.disconnect();
    exit(0);
  });
  
  await iotDevice.connectAndStart();
}