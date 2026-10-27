import 'package:flutter/material.dart';

import '../data/reservas_repository.dart';
import '../models/espaco.dart';
import '../state/janela_state.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/janela_widgets.dart';
import 'detalhe_screen.dart';
import 'guia_visual_screen.dart';

class AlunoShell extends StatefulWidget {
  const AlunoShell({super.key, required this.state});
  final JanelaState state;
  @override
  State<AlunoShell> createState() => _AlunoShellState();
}

class _AlunoShellState extends State<AlunoShell> {
  int _aba = 0;
  late final TextEditingController _busca = TextEditingController(
    text: widget.state.busca,
  );

  @override
  void dispose() {
    _busca.dispose();
    super.dispose();
  }

  void _selecionar(int aba) => setState(() => _aba = aba);

  Future<void> _detalhe(Espaco espaco) async {
    final reservou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => DetalheScreen(state: widget.state, espaco: espaco),
      ),
    );
    if (mounted && reservou == true) _selecionar(2);
  }

  void _limpar() {
    _busca.clear();
    widget.state.limparFiltros();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.state,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: Text(
          ['Início', 'Espaços', 'Minhas reservas', 'Guia visual'][_aba],
        ),
        actions: [
          IconButton(
            tooltip: 'Sair para a Entrada',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: switch (_aba) {
          0 => _inicio(),
          1 => _espacos(),
          2 => _reservas(),
          _ => const GuiaVisualConteudo(),
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _aba,
        onDestinationSelected: _selecionar,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.meeting_room_outlined),
            label: 'Espaços',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            label: 'Reservas',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette_outlined),
            label: 'Guia',
          ),
        ],
      ),
    ),
  );

  Widget _inicio() {
    final dados = widget.state.repository;
    final contagens = dados.contagens;
    return ConteudoJanela(
      children: [
        const Text(
          'Seu próximo intervalo começa aqui.',
          style: AppText.screenTitle,
        ),
        const CabecalhoSecao(
          'Painel do momento',
          descricao: 'Campus piloto · agenda simulada',
        ),
        Text(
          '${contagens[StatusEspaco.livre]} de ${dados.inventario.length} espaços livres agora no campus piloto.',
          style: AppText.body,
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final status in StatusEspaco.values) ...[
          PainelJanela(
            child: Row(
              children: [
                Text(
                  '${contagens[status]}',
                  style: AppText.numberXL.copyWith(color: corStatus(status)),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(child: SeloStatus(status)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        const SizedBox(height: AppSpacing.md),
        BotaoJanela(
          texto: 'Encontrar um espaço',
          icone: Icons.search,
          onPressed: () => _selecionar(1),
        ),
        const CabecalhoSecao(
          'Sua agenda',
          descricao: 'As reservas ficam nesta sessão. Fechar o app restaura os dados simulados.',
        ),
        BotaoJanela(
          texto: 'Ver minhas reservas',
          secundario: true,
          onPressed: () => _selecionar(2),
        ),
      ],
    );
  }

  Widget _espacos() {
    final estado = widget.state;
    final dados = estado.repository;
    final filtrados = estado.filtrados;
    return ConteudoJanela(
      children: [
        const Text('Encontre seu lugar.', style: AppText.screenTitle),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _busca,
          onChanged: estado.buscar,
          decoration: const InputDecoration(
            labelText: 'Buscar espaço',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
          child: Text('Andar', style: AppText.label),
        ),
        SingleChildScrollView(
          key: const ValueKey('filtros-andar'),
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              ChoiceChip(
                label: const Text('Todos os andares'),
                selected: estado.andar == null,
                onSelected: (_) => estado.filtrarAndar(null),
              ),
              for (final andar in dados.andares)
                ChoiceChip(
                  label: Text('$andarº andar'),
                  selected: estado.andar == andar,
                  onSelected: (_) => estado.filtrarAndar(andar),
                ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
          child: Text('Tipo', style: AppText.label),
        ),
        SingleChildScrollView(
          key: const ValueKey('filtros-tipo'),
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              ChoiceChip(
                label: const Text('Todos os tipos'),
                selected: estado.tipo == null,
                onSelected: (_) => estado.filtrarTipo(null),
              ),
              for (final tipo in TipoEspaco.values)
                ChoiceChip(
                  label: Text(rotuloTipo[tipo]!),
                  selected: estado.tipo == tipo,
                  onSelected: (_) => estado.filtrarTipo(tipo),
                ),
            ],
          ),
        ),
        if (estado.andar != null ||
            estado.tipo != null ||
            estado.busca.trim().isNotEmpty)
          TextButton(onPressed: _limpar, child: const Text('Limpar filtros')),
        CabecalhoSecao(
          'Espaços encontrados',
          descricao:
              '${filtrados.length} de ${dados.inventario.length} espaços',
        ),
        if (filtrados.isEmpty)
          EstadoVazio(
            mensagem: 'Nenhum espaço combina com estes filtros. Limpe os filtros para consultar outros andares e tipos.',
            acao: 'Ver todos os espaços',
            onPressed: _limpar,
          ),
        for (final espaco in filtrados)
          CardEspaco(
            key: ValueKey('espaco-${espaco.id}'),
            espaco: espaco,
            situacao: dados.situacao(espaco.id),
            onTap: () => _detalhe(espaco),
          ),
      ],
    );
  }

  Widget _reservas() {
    final dados = widget.state.repository;
    final reservas = dados.minhasReservas;
    return ConteudoJanela(
      children: [
        const Text('Seu tempo, reservado.', style: AppText.screenTitle),
        const SizedBox(height: AppSpacing.lg),
        const Text('Reservas de hoje · campus piloto', style: AppText.body),
        const SizedBox(height: AppSpacing.lg),
        if (reservas.isEmpty)
          EstadoVazio(
            mensagem: 'Nenhuma reserva por aqui. Consulte os espaços e escolha um horário livre.',
            acao: 'Encontrar um espaço',
            onPressed: () => _selecionar(1),
          ),
        for (final reserva in reservas)
          LinhaHorario(
            key: ValueKey('reserva-${reserva.id}'),
            horario: reserva.horario,
            descricao: dados.espaco(reserva.espacoId).nome,
            acao: BotaoJanela(
              texto: 'Cancelar reserva',
              secundario: true,
              onPressed: () async {
                final confirmou = await confirmarAcao(
                  context,
                  titulo: 'Cancelar reserva?',
                  mensagem:
                      '${dados.espaco(reserva.espacoId).nome}, das ${reserva.horario.rotulo}. O horário fica livre para outra pessoa.',
                  confirmar: 'Confirmar cancelamento',
                );
                if (!mounted || !confirmou) return;
                try {
                  widget.state.cancelar(reserva.id);
                  if (!mounted) return;
                  mostrarMensagem(
                    context,
                    'Reserva cancelada. O horário voltou a ficar livre.',
                  );
                } on RegraReserva catch (erro) {
                  if (!mounted) return;
                  mostrarMensagem(context, erro.toString());
                }
              },
            ),
          ),
      ],
    );
  }
}
