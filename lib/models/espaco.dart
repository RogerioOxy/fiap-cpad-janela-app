enum TipoEspaco { sala, laboratorio, auditorio }

enum StatusEspaco { livre, ocupado, manutencao }

const rotuloTipo = {
  TipoEspaco.sala: 'Sala',
  TipoEspaco.laboratorio: 'Laboratório',
  TipoEspaco.auditorio: 'Auditório',
};

const rotuloStatus = {
  StatusEspaco.livre: 'Livre',
  StatusEspaco.ocupado: 'Ocupado',
  StatusEspaco.manutencao: 'Em manutenção',
};

class Espaco {
  const Espaco({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.andar,
    required this.capacidade,
    required this.recursos,
  });

  final String id;
  final String nome;
  final TipoEspaco tipo;
  final int andar;
  final int capacidade;
  final List<String> recursos;
}
