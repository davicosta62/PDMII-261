import 'dart:io';
import 'dart:async';

class TemperatureServer {
  static const int port = 8080;
  late ServerSocket serverSocket;
  final List<Socket> connectedClients = [];

  Future<void> startServer() async {
    try {
      print('🌡️  Servidor de Temperatura iniciando na porta $port...');
      
      serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
      print('✅ Servidor ativo! Aguardando conexões IoT...');
      print('📍 Endereço: ${serverSocket.address.address}:$port');
      
      serverSocket.listen(
        (Socket client) {
          print('🔗 Nova conexão IoT: ${client.remoteAddress.address}:${client.remotePort}');
          connectedClients.add(client);
          
          // Escuta dados do cliente IoT
          client.listen(
            (data) => handleTemperatureData(client, data),
            onError: (error) => handleClientError(client, error),
            onDone: () => handleClientDisconnect(client),
          );
        },
        onError: (error) {
          print('❌ Erro no servidor: $error');
        },
      );
      
    } catch (e) {
      print('❌ Falha ao iniciar servidor: $e');
    }
  }

  void handleTemperatureData(Socket client, List<int> data) {
    final message = String.fromCharCodes(data).trim();
    
    if (message.startsWith('TEMP:')) {
      final temperature = message.substring(5);
      print('🌡️  [$DateTime.now().toString().substring(11, 19)] IoT ${client.remoteAddress.address}: $temperature');
      
      // Envia confirmação para o IoT
      client.write('OK: Temperatura $temperature recebida\n');
    }
  }

  void handleClientError(Socket client, error) {
    print('⚠️  Erro no cliente ${client.remoteAddress.address}: $error');
  }

  void handleClientDisconnect(Socket client) {
    print('🔌 IoT ${client.remoteAddress.address} desconectado');
    connectedClients.remove(client);
    client.destroy();
  }

  void stopServer() {
    print('\n🛑 Encerrando servidor...');
    for (final client in connectedClients) {
      client.destroy();
    }
    serverSocket.close();
    print('✅ Servidor encerrado');
  }
}

void main() async {
  final server = TemperatureServer();
  
  // Captura Ctrl+C para encerrar graciosamente
  ProcessSignal.sigint.watch().listen((signal) {
    print('\n🛑 Sinal de interrupção recebido.');
    server.stopServer();
    exit(0);
  });
  
  await server.startServer();
}