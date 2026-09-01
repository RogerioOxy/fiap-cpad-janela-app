// Dados simulados dos espaços do campus.
//
// O enunciado do Checkpoint 5 diz que o protótipo funciona com dados mockados,
// sem necessidade de backend real, e HTTP não foi visto nas aulas 13 a 16.
// Então a fonte de verdade deste app é este arquivo: Dart puro, sem pacote.
//
// Em produção a fonte seria a grade horária da instituição, via API. Duplicar
// horário à mão é o jeito mais rápido de o app ficar errado, e o README
// registra isso como limitação consciente.
//
// Convenção de nomes: identificadores de domínio em português e sem acento
// (`Espaco`, `usoAtual`), seguindo o estilo do próprio professor nas aulas
// (`Perfil`, `CardPerfil`, `_contador`). Todo texto que aparece na interface
// leva acentuação correta, porque é o que a pessoa lê na tela.

/// Um espaço reservável do campus: sala, laboratório ou auditório.
class Espaco {
  final String id;
  final String nome;
  final TipoEspaco tipo;
  final int andar;
  final int capacidade;
  final StatusEspaco status;

  /// O que ocupa o espaço agora. `null` quando o espaço está livre.
  final String? usoAtual;

  /// Horário em que o espaço volta a ser usado, no formato `'15h40'`.
  ///
  /// Só faz sentido quando o status é [StatusEspaco.livre]. `null` significa
  /// livre pelo resto do turno, e a interface trata esse caso com texto próprio
  /// em vez de esconder a informação.
  ///
  /// É `String` e não `DateTime` de propósito: cálculo com data não foi ensinado
  /// nas aulas 13 a 16, e o app nunca precisa computar duração, apenas exibir
  /// até quando o espaço está livre.
  final String? livreAte;

  /// Horário em que o espaço fica livre. Só faz sentido quando o status é
  /// [StatusEspaco.ocupado].
  final String? livreApartirDe;

  /// Faixas de horário que o aluno pode reservar neste espaço.
  final List<String> horarios;

  const Espaco({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.andar,
    required this.capacidade,
    required this.status,
    this.usoAtual,
    this.livreAte,
    this.livreApartirDe,
    this.horarios = const [],
  });
}

/// Tipo do espaço. Enum em vez de `String` para o filtro não depender de
/// comparação de texto, que quebra em silêncio quando alguém erra a grafia.
enum TipoEspaco { sala, laboratorio, auditorio }

/// Situação do espaço no momento da consulta.
///
/// Os três valores têm cor própria na interface, mas cor nunca é o único
/// sinal: cada status também tem ícone e rótulo em texto, porque status
/// comunicado só por cor exclui quem tem deficiência de percepção de cor.
enum StatusEspaco { livre, ocupado, manutencao }

/// Rótulo de cada tipo, para exibir na interface.
const Map<TipoEspaco, String> rotuloTipo = {
  TipoEspaco.sala: 'Sala',
  TipoEspaco.laboratorio: 'Laboratório',
  TipoEspaco.auditorio: 'Auditório',
};

/// Rótulo de cada status. É o sinal textual que acompanha a cor.
const Map<StatusEspaco, String> rotuloStatus = {
  StatusEspaco.livre: 'Livre',
  StatusEspaco.ocupado: 'Ocupado',
  StatusEspaco.manutencao: 'Em manutenção',
};

/// Os espaços do campus piloto.
///
/// A lista cobre de propósito os três status, os três tipos, quatro andares e
/// os turnos de tarde e noite. Dado simulado só serve se exercitar todos os
/// caminhos da interface, incluindo os dois casos-limite: o espaço livre pelo
/// resto do turno (`livreAte` nulo) e o espaço em manutenção, que não oferece
/// horário nenhum.
const List<Espaco> espacos = [
  // ---------- 1º andar ----------
  Espaco(
    id: 'S101',
    nome: 'Sala 101',
    tipo: TipoEspaco.sala,
    andar: 1,
    capacidade: 40,
    status: StatusEspaco.ocupado,
    usoAtual: 'Algoritmos e Estrutura de Dados · 1CCPM',
    livreApartirDe: '15h40',
    horarios: ['15h40 às 17h10', '17h20 às 18h50', '19h às 20h30'],
  ),
  Espaco(
    id: 'S104',
    nome: 'Sala 104',
    tipo: TipoEspaco.sala,
    andar: 1,
    capacidade: 32,
    status: StatusEspaco.livre,
    livreAte: '15h40',
    horarios: ['14h às 15h30'],
  ),
  Espaco(
    id: 'A101',
    nome: 'Auditório Central',
    tipo: TipoEspaco.auditorio,
    andar: 1,
    capacidade: 180,
    status: StatusEspaco.ocupado,
    usoAtual: 'Palestra de abertura da Semana de Tecnologia',
    livreApartirDe: '18h',
    horarios: ['18h às 19h30', '19h40 às 21h10'],
  ),

  // ---------- 2º andar ----------
  Espaco(
    id: 'L201',
    nome: 'Lab 201',
    tipo: TipoEspaco.laboratorio,
    andar: 2,
    capacidade: 30,
    status: StatusEspaco.livre,
    livreAte: '17h20',
    horarios: ['14h às 15h30', '15h40 às 17h10'],
  ),
  Espaco(
    id: 'L204',
    nome: 'Lab 204',
    tipo: TipoEspaco.laboratorio,
    andar: 2,
    capacidade: 24,
    status: StatusEspaco.manutencao,
    usoAtual: 'Troca de equipamento, previsão de retorno amanhã',
  ),
  Espaco(
    id: 'S207',
    nome: 'Sala 207',
    tipo: TipoEspaco.sala,
    andar: 2,
    capacidade: 45,
    status: StatusEspaco.ocupado,
    usoAtual: 'Banco de Dados · 3CCPN',
    livreApartirDe: '20h40',
    horarios: ['20h40 às 22h10'],
  ),
  Espaco(
    id: 'S210',
    nome: 'Sala 210',
    tipo: TipoEspaco.sala,
    andar: 2,
    capacidade: 28,
    status: StatusEspaco.livre,
    // Sem `livreAte`: livre pelo resto do turno.
    horarios: ['14h às 15h30', '15h40 às 17h10', '17h20 às 18h50'],
  ),

  // ---------- 3º andar ----------
  Espaco(
    id: 'L305',
    nome: 'Lab 305',
    tipo: TipoEspaco.laboratorio,
    andar: 3,
    capacidade: 30,
    status: StatusEspaco.manutencao,
    usoAtual: 'Manutenção da rede elétrica, sem previsão',
  ),
  Espaco(
    id: 'S312',
    nome: 'Sala 312',
    tipo: TipoEspaco.sala,
    andar: 3,
    capacidade: 36,
    status: StatusEspaco.livre,
    livreAte: '15h40',
    horarios: ['14h às 15h30'],
  ),
  Espaco(
    id: 'S315',
    nome: 'Sala 315',
    tipo: TipoEspaco.sala,
    andar: 3,
    capacidade: 20,
    status: StatusEspaco.livre,
    livreAte: '19h',
    horarios: ['14h às 15h30', '15h40 às 17h10', '17h20 às 18h50'],
  ),
  Espaco(
    id: 'L308',
    nome: 'Lab 308',
    tipo: TipoEspaco.laboratorio,
    andar: 3,
    capacidade: 26,
    status: StatusEspaco.ocupado,
    usoAtual: 'Redes de Computadores · 2CCPW',
    livreApartirDe: '17h20',
    horarios: ['17h20 às 18h50', '19h às 20h30'],
  ),

  // ---------- 4º andar ----------
  Espaco(
    id: 'S407',
    nome: 'Sala 407',
    tipo: TipoEspaco.sala,
    andar: 4,
    capacidade: 24,
    status: StatusEspaco.ocupado,
    usoAtual: 'Engenharia de Software · 4CCPM',
    livreApartirDe: '15h40',
    horarios: ['15h40 às 17h10', '17h20 às 18h50'],
  ),
  Espaco(
    id: 'S412',
    nome: 'Sala 412',
    tipo: TipoEspaco.sala,
    andar: 4,
    capacidade: 16,
    status: StatusEspaco.livre,
    livreAte: '17h20',
    horarios: ['14h às 15h30', '15h40 às 17h10'],
  ),
  Espaco(
    id: 'A402',
    nome: 'Auditório do 4º andar',
    tipo: TipoEspaco.auditorio,
    andar: 4,
    capacidade: 90,
    status: StatusEspaco.livre,
    livreAte: '19h',
    horarios: ['14h às 15h30', '15h40 às 17h10', '17h20 às 18h50'],
  ),
];

/// Andares que aparecem no filtro, derivados da lista e não digitados à mão.
///
/// Número digitado à mão desencontra da lista assim que um espaço é adicionado,
/// e a interface passa a oferecer filtro que não acha nada.
List<int> get andaresDisponiveis {
  final andares = espacos.map((e) => e.andar).toSet().toList();
  andares.sort();
  return andares;
}

/// Quantos espaços estão em cada status. Alimenta o painel do momento.
int contarPorStatus(StatusEspaco status) {
  return espacos.where((e) => e.status == status).length;
}
