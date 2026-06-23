import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() =>
      _UsuariosScreenState();
}

class _UsuariosScreenState
    extends State<UsuariosScreen> {

  late Future<List<Usuario>> usuarios;

  @override
  void initState() {
    super.initState();
    usuarios = ApiService.buscarUsuarios();
  }

  Future<void> atualizar() async {
    setState(() {
      usuarios = ApiService.buscarUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
      ),

      body: RefreshIndicator(
        onRefresh: atualizar,

        child: FutureBuilder<List<Usuario>>(

          future: usuarios,

          builder: (context, snapshot) {

            if (snapshot.connectionState ==
                ConnectionState.waiting) {

              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {

              return Center(
                child: Text(
                  'Erro: ${snapshot.error}',
                ),
              );
            }

            if (!snapshot.hasData ||
                snapshot.data!.isEmpty) {

              return const Center(
                child: Text(
                  'Nenhum usuário encontrado',
                ),
              );
            }

            final lista = snapshot.data!;

            return ListView.builder(
              itemCount: lista.length,

              itemBuilder: (context, index) {

                final usuario = lista[index];

                return Card(
                  margin: const EdgeInsets.all(8),

                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        usuario.id.toString(),
                      ),
                    ),

                    title: Text(usuario.nome),

                    subtitle: Text(
                      usuario.email,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}