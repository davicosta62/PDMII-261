import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson() {
    return {'NomeDependente': _nome};
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map<String, dynamic> toJson() {
    return {
      'NomeFuncionario': _nome,
      'Dependentes': _dependentes.map((f) => f.toJson()).toList(),
    };
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() {
    return {
      'NomeProjeto': _nomeProjeto,
      'Funcionarios': _funcionarios.map((f) => f.toJson()).toList(),
    };
  }
}

void main() {
  Dependente ronaldo = Dependente('Ronaldo Cabral');
  Dependente yuri = Dependente('Iuri da Costa');
  Dependente renan = Dependente('Ronaldo Cabral');
  Dependente ze = Dependente('Zé');
  Dependente bernado = Dependente('Bernado');
  Dependente vitor = Dependente('Vitor');
  Dependente isaque = Dependente('Isaque');
  Dependente arnold = Dependente('Arnold');
  Dependente alex = Dependente('Alexsander');
  Dependente alejandro = Dependente('Aleandro');

  List<Dependente> dependentesRodrigo = [ronaldo, yuri];
  List<Dependente> dependentesFernando = [renan, alex];
  List<Dependente> dependentesMauricio = [ze, bernado];
  List<Dependente> dependentesSamuel = [vitor, isaque];
  List<Dependente> dependentesLeticia = [arnold, alejandro];

  Funcionario rodrigo = Funcionario('Rodrigo', dependentesRodrigo);
  Funcionario fernando = Funcionario('Fernando', dependentesFernando);
  Funcionario mauricio = Funcionario('Mauricio', dependentesMauricio);
  Funcionario samuel = Funcionario('Samuel', dependentesSamuel);
  Funcionario leticia = Funcionario('Leticia', dependentesLeticia);

  List<Funcionario> funcionarios_Sinistros = [
    rodrigo,
    fernando,
    mauricio,
    samuel,
    leticia,
  ];

  EquipeProjeto sinistro = EquipeProjeto(
    'ProjetoSinistro',
    funcionarios_Sinistros,
  );

  var sinistroJson = sinistro.toJson();
  var encoder = JsonEncoder.withIndent('  ');
  print(encoder.convert(sinistroJson));
}
