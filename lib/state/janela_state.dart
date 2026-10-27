import 'package:flutter/foundation.dart';

import '../data/reservas_repository.dart';
import '../models/agenda.dart';
import '../models/espaco.dart';

class JanelaState extends ChangeNotifier {
  JanelaState({ReservasRepository? repository})
    : repository = repository ?? ReservasRepository();

  final ReservasRepository repository;
  int? _andar;
  TipoEspaco? _tipo;
  String _busca = '';
  int? get andar => _andar;
  TipoEspaco? get tipo => _tipo;
  String get busca => _busca;

  List<Espaco> get filtrados => repository.inventario
      .where(
        (e) =>
            (_andar == null || e.andar == _andar) &&
            (_tipo == null || e.tipo == _tipo) &&
            e.nome.toLowerCase().contains(_busca.trim().toLowerCase()),
      )
      .toList();

  void filtrarAndar(int? valor) {
    _andar = valor;
    notifyListeners();
  }

  void filtrarTipo(TipoEspaco? valor) {
    _tipo = valor;
    notifyListeners();
  }

  void buscar(String valor) {
    _busca = valor;
    notifyListeners();
  }

  void limparFiltros() {
    _andar = null;
    _tipo = null;
    _busca = '';
    notifyListeners();
  }

  Reserva reservar(String espacoId, Horario horario) {
    final reserva = repository.reservar(espacoId, horario);
    notifyListeners();
    return reserva;
  }

  void cancelar(String reservaId) {
    repository.cancelar(reservaId);
    notifyListeners();
  }

  /// Permite à interface renovar consultas de relógio sem alterar reservas.
  void atualizar() => notifyListeners();
}
