import 'package:flutter/material.dart';

import '../data/reservas_repository.dart';
import '../models/agenda.dart';
import '../models/espaco.dart';
import '../state/janela_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/janela_widgets.dart';

class ReservaScreen extends StatefulWidget {
  const ReservaScreen({
    super.key,
    required this.state,
    required this.espaco,
    required this.horario,
  });
  final JanelaState state;
  final Espaco espaco;
  final Horario horario;
  @override
  State<ReservaScreen> createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  bool _confirmada = false;
  String? _erro;

  void _confirmar() {
    if (_confirmada) return;
    try {
      widget.state.reservar(widget.espaco.id, widget.horario);
      setState(() {
        _confirmada = true;
        _erro = null;
      });
    } on RegraReserva catch (erro) {
      setState(() => _erro = erro.mensagem);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_confirmada ? 'Reserva confirmada' : 'Resumo da reserva'),
    ),
    body: SafeArea(
      child: ConteudoJanela(
        children: [
          if (_confirmada) ...[
            const Icon(
              Icons.check_circle_outline,
              color: AppColors.statusLivre,
              semanticLabel: 'Reserva concluída',
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Reservado: ${widget.espaco.nome}, das ${widget.horario.rotulo}.',
              style: AppText.screenTitle,
            ),
          ] else
            const Text('Confira seu intervalo.', style: AppText.screenTitle),
          const SizedBox(height: AppSpacing.xl),
          LinhaHorario(
            horario: widget.horario,
            descricao:
                '${widget.espaco.nome} · ${widget.espaco.andar}º andar · ${widget.espaco.capacidade} lugares',
          ),
          Text(
            'Use o espaço até ${hora(widget.horario.fim)}. Depois desse horário, libere para o próximo uso.',
            style: AppText.body,
          ),
          const SizedBox(height: AppSpacing.xl),
          if (_erro != null) ...[
            Semantics(
              liveRegion: true,
              child: Text(
                _erro!,
                style: AppText.body.copyWith(color: AppColors.statusOcupado),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            BotaoJanela(
              texto: 'Escolher outro horário',
              secundario: true,
              onPressed: () => Navigator.pop(context),
            ),
          ],
          if (!_confirmada && _erro == null)
            BotaoJanela(texto: 'Confirmar reserva', onPressed: _confirmar),
          if (_confirmada)
            BotaoJanela(
              texto: 'Ver minhas reservas',
              onPressed: () => Navigator.pop(context, true),
            ),
        ],
      ),
    ),
  );
}
