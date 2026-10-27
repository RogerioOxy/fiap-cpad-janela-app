import 'espaco.dart';

typedef Relogio = DateTime Function();

DateTime diaDe(DateTime valor) => DateTime(valor.year, valor.month, valor.day);

String hora(DateTime valor) =>
    '${valor.hour.toString().padLeft(2, '0')}h${valor.minute.toString().padLeft(2, '0')}';

/// Intervalos semiabertos: o fim de um uso pode ser o início do seguinte.
class Horario {
  Horario(this.inicio, this.fim) {
    if (!fim.isAfter(inicio)) {
      throw ArgumentError('O fim precisa ser posterior ao início.');
    }
  }

  final DateTime inicio;
  final DateTime fim;
  bool contem(DateTime instante) =>
      !instante.isBefore(inicio) && instante.isBefore(fim);
  bool sobrepoe(Horario outro) =>
      inicio.isBefore(outro.fim) && outro.inicio.isBefore(fim);
  bool igual(Horario outro) => inicio == outro.inicio && fim == outro.fim;
  String get rotulo => '${hora(inicio)} às ${hora(fim)}';
}

class Uso {
  const Uso({
    required this.espacoId,
    required this.horario,
    required this.descricao,
    this.manutencao = false,
  });
  final String espacoId;
  final Horario horario;
  final String descricao;
  final bool manutencao;
}

class Reserva {
  const Reserva({
    required this.id,
    required this.espacoId,
    required this.usuarioId,
    required this.horario,
  });
  final String id;
  final String espacoId;
  final String usuarioId;
  final Horario horario;
}

class SituacaoEspaco {
  const SituacaoEspaco({
    required this.status,
    required this.descricao,
    this.ate,
    this.usoAtual,
    this.proximoUso,
  });
  final StatusEspaco status;
  final String descricao;
  final DateTime? ate;
  final Uso? usoAtual;
  final Uso? proximoUso;
}

class OcupacaoAndar {
  const OcupacaoAndar(this.total, this.ocupados, this.manutencao);
  final int total;
  final int ocupados;
  final int manutencao;
  double get proporcao => total == 0 ? 0 : ocupados / total;
}
