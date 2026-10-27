import '../models/agenda.dart';
import '../models/espaco.dart';

/// Inventário fictício. A Sala 210 não recebe usos nem reservas iniciais.
const espacos = <Espaco>[
  Espaco(
    id: 'S101',
    nome: 'Sala 101',
    tipo: TipoEspaco.sala,
    andar: 1,
    capacidade: 40,
    recursos: ['Projetor', 'Lousa'],
  ),
  Espaco(
    id: 'S104',
    nome: 'Sala 104',
    tipo: TipoEspaco.sala,
    andar: 1,
    capacidade: 32,
    recursos: ['TV', 'Lousa'],
  ),
  Espaco(
    id: 'A101',
    nome: 'Auditório Central',
    tipo: TipoEspaco.auditorio,
    andar: 1,
    capacidade: 180,
    recursos: ['Palco', 'Microfone', 'Projetor'],
  ),
  Espaco(
    id: 'L201',
    nome: 'Lab 201',
    tipo: TipoEspaco.laboratorio,
    andar: 2,
    capacidade: 30,
    recursos: ['Computadores', 'Projetor'],
  ),
  Espaco(
    id: 'L204',
    nome: 'Lab 204',
    tipo: TipoEspaco.laboratorio,
    andar: 2,
    capacidade: 24,
    recursos: ['Computadores', 'Bancadas'],
  ),
  Espaco(
    id: 'S207',
    nome: 'Sala 207',
    tipo: TipoEspaco.sala,
    andar: 2,
    capacidade: 45,
    recursos: ['Projetor', 'Lousa'],
  ),
  Espaco(
    id: 'S210',
    nome: 'Sala 210',
    tipo: TipoEspaco.sala,
    andar: 2,
    capacidade: 28,
    recursos: ['Lousa', 'Tomadas'],
  ),
  Espaco(
    id: 'L305',
    nome: 'Lab 305',
    tipo: TipoEspaco.laboratorio,
    andar: 3,
    capacidade: 30,
    recursos: ['Computadores', 'Rede cabeada'],
  ),
  Espaco(
    id: 'S312',
    nome: 'Sala 312',
    tipo: TipoEspaco.sala,
    andar: 3,
    capacidade: 36,
    recursos: ['TV', 'Lousa'],
  ),
  Espaco(
    id: 'S315',
    nome: 'Sala 315',
    tipo: TipoEspaco.sala,
    andar: 3,
    capacidade: 20,
    recursos: ['Lousa', 'Tomadas'],
  ),
  Espaco(
    id: 'L308',
    nome: 'Lab 308',
    tipo: TipoEspaco.laboratorio,
    andar: 3,
    capacidade: 26,
    recursos: ['Computadores', 'Projetor'],
  ),
  Espaco(
    id: 'S407',
    nome: 'Sala 407',
    tipo: TipoEspaco.sala,
    andar: 4,
    capacidade: 24,
    recursos: ['Projetor', 'Lousa'],
  ),
  Espaco(
    id: 'S412',
    nome: 'Sala 412',
    tipo: TipoEspaco.sala,
    andar: 4,
    capacidade: 16,
    recursos: ['TV', 'Tomadas'],
  ),
  Espaco(
    id: 'A402',
    nome: 'Auditório do 4º andar',
    tipo: TipoEspaco.auditorio,
    andar: 4,
    capacidade: 90,
    recursos: ['Microfone', 'Projetor'],
  ),
  Espaco(
    id: 'L501',
    nome: 'Lab de robótica',
    tipo: TipoEspaco.laboratorio,
    andar: 5,
    capacidade: 18,
    recursos: ['Bancadas', 'Kits de robótica'],
  ),
  Espaco(
    id: 'S504',
    nome: 'Sala de projetos',
    tipo: TipoEspaco.sala,
    andar: 5,
    capacidade: 12,
    recursos: ['Lousa', 'Mesa coletiva'],
  ),
];

/// Oferta do dia, das 07h às 23h. A reserva usa uma faixa inteira de uma hora.
List<Horario> horariosDoDia(DateTime dia) => [
  for (var h = 7; h < 23; h++)
    Horario(
      DateTime(dia.year, dia.month, dia.day, h),
      DateTime(dia.year, dia.month, dia.day, h + 1),
    ),
];

class AgendaMock {
  AgendaMock(DateTime referencia) {
    final dia = diaDe(referencia);
    final horarios = horariosDoDia(dia);
    final ancora = (referencia.hour - 7).clamp(0, horarios.length - 1);
    usos = List.unmodifiable([
      for (final id in ['L204', 'L305'])
        Uso(
          espacoId: id,
          horario: Horario(dia, DateTime(dia.year, dia.month, dia.day + 1)),
          descricao: 'Revisão de equipamentos e rede',
          manutencao: true,
        ),
      for (final id in ['S101', 'S207', 'L308', 'S407'])
        Uso(
          espacoId: id,
          horario: horarios[ancora],
          descricao:
              'Aula de ${id == 'L308' ? 'Redes de Computadores' : 'Engenharia de Software'}',
        ),
      if (ancora + 2 < horarios.length)
        for (final id in ['S104', 'L201', 'S312', 'A402'])
          Uso(
            espacoId: id,
            horario: horarios[ancora + 2],
            descricao: 'Trabalho orientado · 2CCPW',
          ),
    ]);
    reservas = List.unmodifiable([
      for (var i = 0; i < 5; i++)
        Reserva(
          id: 'mock-$i',
          espacoId: ['A101', 'S315', 'S412', 'L501', 'S504'][i],
          usuarioId: i == 2 ? usuarioAtual : 'aluno-${i + 1}',
          horario: horarios[(ancora + i).clamp(0, horarios.length - 1)],
        ),
    ]);
  }

  late final List<Uso> usos;
  late final List<Reserva> reservas;
}

const usuarioAtual = 'aluno-piloto';
