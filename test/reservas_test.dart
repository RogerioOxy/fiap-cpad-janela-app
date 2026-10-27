import 'package:flutter_test/flutter_test.dart';
import 'package:janela_app/data/espacos_mock.dart';
import 'package:janela_app/data/reservas_repository.dart';
import 'package:janela_app/models/agenda.dart';
import 'package:janela_app/models/espaco.dart';
import 'package:janela_app/state/janela_state.dart';

void main() {
  late DateTime agora;
  late ReservasRepository repository;
  late JanelaState state;
  Horario faixa(int h) =>
      Horario(DateTime(2026, 10, 27, h), DateTime(2026, 10, 27, h + 1));

  setUp(() {
    agora = DateTime(2026, 10, 27, 14);
    repository = ReservasRepository(relogio: () => agora);
    state = JanelaState(repository: repository);
  });
  tearDown(() => state.dispose());

  test('R01: inventário cobre tipos, andares, recursos e todos os status', () {
    expect(repository.inventario.length, 16);
    expect(repository.andares, [1, 2, 3, 4, 5]);
    expect(
      repository.inventario.map((e) => e.tipo).toSet(),
      TipoEspaco.values.toSet(),
    );
    expect(
      repository.inventario.every(
        (e) => e.recursos.isNotEmpty && e.capacidade > 0,
      ),
      isTrue,
    );
    expect(repository.contagens.values.every((n) => n > 0), isTrue);
    expect(repository.reservas.any((r) => r.usuarioId != usuarioAtual), isTrue);
    expect(repository.minhasReservas, hasLength(1));
  });

  test('R02: painel do momento tem contagem exata e muda ao reservar', () {
    expect(repository.contagens, {
      StatusEspaco.livre: 9,
      StatusEspaco.ocupado: 5,
      StatusEspaco.manutencao: 2,
    });
    state.reservar('S210', faixa(14));
    expect(repository.contagens, {
      StatusEspaco.livre: 8,
      StatusEspaco.ocupado: 6,
      StatusEspaco.manutencao: 2,
    });
  });

  test('R03: livre o dia todo, livre até uso, ocupado e manutenção', () {
    expect(repository.situacao('S210').descricao, 'Livre até 23h00');
    expect(repository.situacao('S104').descricao, 'Livre até 16h00');
    expect(repository.situacao('S101').descricao, 'Ocupado até 15h00');
    expect(repository.situacao('L204').status, StatusEspaco.manutencao);
    expect(repository.situacao('S104').usoAtual, isNull);
    expect(repository.situacao('S101').usoAtual, isNotNull);
    expect(repository.situacao('S104').proximoUso!.horario.inicio.hour, 16);
    expect(repository.disponiveis('L204'), isEmpty);
  });

  test('R04: filtros combinam andar, tipo e busca, e podem ser limpos', () {
    state.filtrarAndar(3);
    expect(state.filtrados.map((e) => e.id), ['L305', 'S312', 'S315', 'L308']);
    state.filtrarTipo(TipoEspaco.sala);
    expect(state.filtrados.map((e) => e.id), ['S312', 'S315']);
    state.buscar('  SALA 312  ');
    expect(state.filtrados.single.id, 'S312');
    state.buscar('inexistente');
    expect(state.filtrados, isEmpty);
    state.limparFiltros();
    expect(state.filtrados, hasLength(16));
    expect(state.andar, isNull);
    expect(state.tipo, isNull);
    expect(state.busca, isEmpty);
  });

  test('R05: detalhe tem dados físicos, agenda ordenada e oferta do dia', () {
    final e = repository.espaco('L201');
    expect(e.andar, 2);
    expect(e.capacidade, 30);
    expect(e.recursos, contains('Computadores'));
    expect(repository.horarios, hasLength(16));
    expect(repository.horarios.first.rotulo, '07h00 às 08h00');
    expect(repository.horarios.last.rotulo, '22h00 às 23h00');
    expect(
      repository.agenda('L201').single.descricao,
      'Trabalho orientado · 2CCPW',
    );
  });

  test('R06: reserva é inserida e remove a oferta no mesmo instante', () {
    final r = state.reservar('S210', faixa(14));
    expect(r.usuarioId, usuarioAtual);
    expect(repository.minhasReservas, contains(r));
    expect(
      repository.disponiveis('S210').any((h) => h.igual(faixa(14))),
      isFalse,
    );
    expect(repository.situacao('S210').usoAtual!.descricao, 'Sua reserva');
  });

  test('R07: rejeita horário ocupado por aula, outro aluno e manutenção', () {
    for (final id in ['S101', 'A101', 'L204']) {
      final antes = repository.reservas.length;
      expect(() => state.reservar(id, faixa(14)), throwsA(isA<RegraReserva>()));
      expect(repository.reservas.length, antes);
    }
    expect(
      repository.impedimento('L204', faixa(15)),
      contains('está em manutenção hoje'),
    );
    expect(
      repository.impedimento('A101', faixa(14)),
      'Reservado por outra pessoa.',
    );
  });

  test('R08: duplicata e sobreposição do próprio usuário são bloqueadas', () {
    state.reservar('S210', faixa(14));
    expect(
      repository.impedimento('S210', faixa(14)),
      contains('Você já reservou'),
    );
    expect(
      () => state.reservar('S210', faixa(14)),
      throwsA(isA<RegraReserva>()),
    );
    expect(
      repository.impedimento('S104', faixa(14)),
      contains('nesse intervalo'),
    );
    expect(
      () => state.reservar('S104', faixa(14)),
      throwsA(isA<RegraReserva>()),
    );
    expect(repository.minhasReservas, hasLength(2));
  });

  test(
    'R09: horários adjacentes são permitidos e limite final é exclusivo',
    () {
      state.reservar('S210', faixa(14));
      state.reservar('S104', faixa(15));
      expect(faixa(14).sobrepoe(faixa(15)), isFalse);
      expect(faixa(14).contem(DateTime(2026, 10, 27, 15)), isFalse);
      expect(repository.minhasReservas, hasLength(3));
    },
  );

  test(
    'R10: recusa intervalo parcial, passado, outro dia e espaço inválido',
    () {
      for (final h in [
        faixa(13),
        Horario(DateTime(2026, 10, 27, 14, 30), DateTime(2026, 10, 27, 15)),
        Horario(DateTime(2026, 10, 28, 14), DateTime(2026, 10, 28, 15)),
        Horario(DateTime(2026, 10, 27, 23), DateTime(2026, 10, 28)),
      ]) {
        expect(() => state.reservar('S210', h), throwsA(isA<RegraReserva>()));
      }
      expect(
        () => state.reservar('inexistente', faixa(14)),
        throwsA(isA<RegraReserva>()),
      );
      expect(() => Horario(agora, agora), throwsArgumentError);
      final parcial = Horario(
        DateTime(2026, 10, 27, 14, 30),
        DateTime(2026, 10, 27, 15, 30),
      );
      expect(parcial.sobrepoe(faixa(14)), isTrue);
      expect(parcial.sobrepoe(faixa(15)), isTrue);
    },
  );

  test('R11: cancelamento devolve horário, status e contagem de demanda', () {
    final antes = repository.demandaPorHora[14];
    final r = state.reservar('S210', faixa(14));
    expect(repository.demandaPorHora[14], antes! + 1);
    state.cancelar(r.id);
    expect(
      repository.disponiveis('S210').any((h) => h.igual(faixa(14))),
      isTrue,
    );
    expect(repository.situacao('S210').status, StatusEspaco.livre);
    expect(repository.demandaPorHora[14], antes);
    expect(() => state.cancelar(r.id), throwsA(isA<RegraReserva>()));
  });

  test('R12: cancelamento não remove reserva de outra pessoa', () {
    final outra = repository.reservas.firstWhere(
      (r) => r.usuarioId != usuarioAtual,
    );
    expect(() => state.cancelar(outra.id), throwsA(isA<RegraReserva>()));
    expect(repository.reservas, contains(outra));
  });

  test(
    'R13: coordenação agrega por andar e hora com mock e novas reservas',
    () {
      final andar = repository.ocupacaoPorAndar[2]!;
      expect(andar.total, 4);
      expect(andar.ocupados, 1);
      expect(andar.manutencao, 1);
      expect(andar.proporcao, 0.25);
      expect(repository.demandaPorHora[14], 1);
      expect(repository.demandaPorHora[15], 1);
      expect(repository.demandaPorHora.values.reduce((a, b) => a + b), 5);
      final r = state.reservar('S210', faixa(14));
      expect(repository.ocupacaoPorAndar[2]!.proporcao, 0.5);
      expect(repository.demandaPorHora[14], 2);
      state.cancelar(r.id);
      expect(repository.ocupacaoPorAndar[2]!.proporcao, 0.25);
      expect(repository.demandaPorHora[14], 1);
    },
  );

  test('R14: relógio avança sem recriar mock durante o dia', () {
    final r = state.reservar('S210', faixa(15));
    agora = DateTime(2026, 10, 27, 15, 30);
    expect(repository.situacao('S101').status, StatusEspaco.livre);
    expect(repository.situacao('S210').status, StatusEspaco.ocupado);
    expect(repository.minhasReservas, contains(r));
    expect(
      () => state.reservar('S104', faixa(15)),
      throwsA(isA<RegraReserva>()),
    );
    agora = DateTime(2026, 10, 27, 16);
    expect(repository.situacao('S210').status, StatusEspaco.livre);
    expect(repository.situacao('S104').status, StatusEspaco.ocupado);
  });

  test('R15: relógio cobre madrugada, fechamento e virada do dia', () {
    for (final h in [0, 6, 7, 12, 22, 23]) {
      final r = ReservasRepository(
        relogio: () => DateTime(2026, 12, 31, h, 30),
      );
      expect(r.horarios.first.inicio, DateTime(2026, 12, 31, 7));
      expect(r.horarios.last.fim, DateTime(2026, 12, 31, 23));
      expect(r.contagens.values.reduce((a, b) => a + b), 16);
      if (h == 23) expect(r.disponiveis('S210'), isEmpty);
      if (h < 7 || h >= 23) {
        expect(r.situacao('S210').descricao, contains('Fora do horário'));
      }
    }
    state.reservar('S210', faixa(14));
    agora = DateTime(2026, 10, 28, 8);
    expect(repository.reservas.any((r) => r.id.startsWith('sessao-')), isFalse);
    expect(repository.horarios.first.inicio.day, 28);
  });

  test(
    'R16: sessão nova restaura mock e coleções não permitem mutação externa',
    () {
      final r = state.reservar('S210', faixa(14));
      final nova = ReservasRepository(relogio: () => agora);
      expect(nova.reservas.any((e) => e.id == r.id), isFalse);
      expect(() => repository.reservas.clear(), throwsUnsupportedError);
      expect(() => repository.usos.clear(), throwsUnsupportedError);
      expect(() => repository.inventario.clear(), throwsUnsupportedError);
      expect(
        () => repository.inventario.first.recursos.clear(),
        throwsUnsupportedError,
      );
    },
  );

  test(
    'R17: estado notifica alterações e não notifica operações rejeitadas',
    () {
      var notificacoes = 0;
      state.addListener(() => notificacoes++);
      state.filtrarAndar(2);
      state.filtrarTipo(TipoEspaco.sala);
      state.buscar('210');
      final r = state.reservar('S210', faixa(14));
      expect(notificacoes, 4);
      expect(
        () => state.reservar('L204', faixa(14)),
        throwsA(isA<RegraReserva>()),
      );
      expect(notificacoes, 4);
      state.cancelar(r.id);
      state.limparFiltros();
      state.atualizar();
      expect(notificacoes, 7);
    },
  );
}
