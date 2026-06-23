import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class ApiService {
  static Future<List<Usuario>> buscarUsuarios() async {
    try {
      // Se ainda estiver usando o delay para o print de carregamento, mantenha-o aqui:
      // await Future.delayed(const Duration(seconds: 3));

      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      if (response.statusCode == 200) {
        List<dynamic> dados = jsonDecode(response.body);
        return dados.map((json) => Usuario.fromJson(json)).toList();
      } else {
        // Trata erros de resposta do servidor (ex: erro 500 ou 404)
        throw Exception('Erro no servidor (${response.statusCode}).');
      }
    } on SocketException {
      // 🌐 Captura EXATAMENTE a falta de internet/rede desligada
      throw Exception('Não foi possível conectar. Verifique sua conexão com a internet e tente novamente.');
    } catch (e) {
      // ⚠️ Captura qualquer outro erro genérico imprevisto
      throw Exception('Algo deu errado. Por favor, tente novamente mais tarde.');
    }
  }
}