import '../models/agenda.dart';
import '../models/espaco.dart';
import 'espacos_mock.dart';

class RegraReserva implements Exception {
  const RegraReserva(this.mensagem);
  final String mensagem;
  @override
  String toString() => mensagem;
}

/// Fonte única de agenda e reservas durante a sessão, sem persistência.
class ReservasRepository {
  ReservasRepository({Relogio? relogio}) : relogio = relogio ?? DateTime.now;

  final Relogio relogio;
  DateTime? _dia;
  List<Uso> _usos = [];
  final List<Reserva> _reservas = [];
  int _sequencia = 0;

  void _atualizarDia() {
    final agora = relogio();
    final dia = diaDe(agora);
    if (dia == _dia) return;
    final mock = AgendaMock(agora);
    _dia = dia;
    _usos = mock.usos;
    _reservas
      ..clear()
      ..addAll(mock.reservas);
  }

  List<Espaco> get inventario => espacos;
  List<int> get andares =>
      (espacos.map((e) => e.andar).toSet().toList()..sort());
  List<Uso> get usos {
    _atualizarDia();
    return List.unmodifiable(_usos);
  }

  List<Reserva> get reservas {
    _atualizarDia();
    return List.unmodifiable(_reservas);
  }

  Espaco espaco(String id) => espacos.firstWhere(
    (e) => e.id == id,
    orElse: () =>
        throw const RegraReserva('Espaço não encontrado. Escolha outro.'),
  );

  List<Horario> get horarios {
    _atualizarDia();
    return List.unmodifiable(horariosDoDia(_dia!));
  }

  List<Reserva> get minhasReservas =>
      reservas.where((r) => r.usuarioId == usuarioAtual).toList()
        ..sort((a, b) => a.horario.inicio.compareTo(b.horario.inicio));

  List<Uso> agenda(String id) {
    espaco(id);
    final itens = <Uso>[
      ...usos.where((u) => u.espacoId == id),
      ...reservas
          .where((r) => r.espacoId == id)
          .map(
            (r) => Uso(
              espacoId: id,
              horario: r.horario,
              descricao: r.usuarioId == usuarioAtual
                  ? 'Sua reserva'
                  : 'Reserva de aluno',
            ),
          ),
    ];
    itens.sort((a, b) => a.horario.inicio.compareTo(b.horario.inicio));
    return List.unmodifiable(itens);
  }

  SituacaoEspaco situacao(String id) {
    final itens = agenda(id);
    final agora = relogio();
    final atuais = itens.where((u) => u.horario.contem(agora));
    final proximos = itens.where((u) => u.horario.inicio.isAfter(agora));
    final proximo = proximos.isEmpty ? null : proximos.first;
    if (atuais.isNotEmpty) {
      final uso = atuais.first;
      return SituacaoEspaco(
        status: uso.manutencao ? StatusEspaco.manutencao : StatusEspaco.ocupado,
        descricao: uso.manutencao
            ? 'Em manutenção'
            : 'Ocupado até ${hora(uso.horario.fim)}',
        ate: uso.horario.fim,
        usoAtual: uso,
        proximoUso: proximo,
      );
    }
    final fechamento = DateTime(agora.year, agora.month, agora.day, 23);
    final aberto = agora.hour >= 7 && agora.isBefore(fechamento);
    return SituacaoEspaco(
      status: StatusEspaco.livre,
      descricao: aberto
          ? 'Livre até ${hora(proximo?.horario.inicio ?? fechamento)}'
          : 'Fora do horário de abertura: 07h00 às 23h00',
      ate: aberto ? proximo?.horario.inicio ?? fechamento : null,
      proximoUso: proximo,
    );
  }

  Map<StatusEspaco, int> get contagens => {
    for (final status in StatusEspaco.values)
      status: inventario.where((e) => situacao(e.id).status == status).length,
  };

  String? impedimento(String espacoId, Horario faixa) {
    final e = espaco(espacoId);
    final oferta = horarios;
    if (!oferta.any((h) => h.igual(faixa))) {
      return 'Escolha um dos horários oferecidos hoje, das 07h às 23h.';
    }
    if (faixa.inicio.isBefore(relogio())) {
      return 'Esse horário já começou. Escolha o próximo.';
    }
    final bloqueios = usos.where(
      (u) => u.espacoId == espacoId && u.horario.sobrepoe(faixa),
    );
    if (bloqueios.any((u) => u.manutencao)) {
      return '${e.nome} está em manutenção hoje. Nenhum horário pode ser reservado neste espaço.';
    }
    if (minhasReservas.any(
      (r) => r.espacoId == espacoId && r.horario.igual(faixa),
    )) {
      return 'Você já reservou esse horário. Consulte suas reservas.';
    }
    if (bloqueios.isNotEmpty) {
      return 'Ocupado por aula ou uso agendado.';
    }
    if (reservas.any(
      (r) => r.espacoId == espacoId && r.horario.sobrepoe(faixa),
    )) {
      return 'Reservado por outra pessoa.';
    }
    if (minhasReservas.any((r) => r.horario.sobrepoe(faixa))) {
      return 'Você já tem uma reserva nesse intervalo. Escolha outro horário.';
    }
    return null;
  }

  List<Horario> disponiveis(String id) =>
      horarios.where((h) => impedimento(id, h) == null).toList();

  Reserva reservar(String espacoId, Horario faixa) {
    final mensagem = impedimento(espacoId, faixa);
    if (mensagem != null) {
      throw RegraReserva(
        mensagem == 'Reservado por outra pessoa.'
            ? 'Esse horário acabou de ser reservado por outra pessoa. Escolha outro.'
            : mensagem,
      );
    }
    final reserva = Reserva(
      id: 'sessao-${++_sequencia}',
      espacoId: espacoId,
      usuarioId: usuarioAtual,
      horario: faixa,
    );
    _reservas.add(reserva);
    return reserva;
  }

  void cancelar(String reservaId) {
    _atualizarDia();
    final indice = _reservas.indexWhere(
      (r) => r.id == reservaId && r.usuarioId == usuarioAtual,
    );
    if (indice < 0) {
      throw const RegraReserva(
        'Reserva não encontrada. Consulte suas reservas.',
      );
    }
    _reservas.removeAt(indice);
  }

  Map<int, OcupacaoAndar> get ocupacaoPorAndar => {
    for (final andar in andares)
      andar: OcupacaoAndar(
        inventario.where((e) => e.andar == andar).length,
        inventario
            .where(
              (e) =>
                  e.andar == andar &&
                  situacao(e.id).status == StatusEspaco.ocupado,
            )
            .length,
        inventario
            .where(
              (e) =>
                  e.andar == andar &&
                  situacao(e.id).status == StatusEspaco.manutencao,
            )
            .length,
      ),
  };

  /// Demanda declarada por início da reserva, sem inferir presença física.
  Map<int, int> get demandaPorHora => {
    for (var h = 7; h < 23; h++)
      h: reservas.where((r) => r.horario.inicio.hour == h).length,
  };
}
