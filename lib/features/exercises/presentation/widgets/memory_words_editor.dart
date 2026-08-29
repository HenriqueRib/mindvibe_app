import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class MemoryWordsButton extends ConsumerWidget {
  const MemoryWordsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final count = ref
        .watch(memoryWordsProvider)
        .maybeWhen(data: (words) => words.length, orElse: () => 0);
    return TextButton.icon(
      onPressed: () => showMemoryWordsEditor(context, ref),
      icon: const Icon(Icons.playlist_add),
      label: Text(
        count == 0 ? l10n.memoryWordsAdd : l10n.memoryWordsCount(count),
      ),
    );
  }
}

Future<void> showMemoryWordsEditor(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final store = ref.read(memoryWordsStoreProvider);
  final current = [...(await store.read())];
  if (!context.mounted) {
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: _MemoryWordsSheet(
          l10n: l10n,
          initial: current,
          onSave: (words) async {
            await store.save(words);
            ref.invalidate(memoryWordsProvider);
          },
        ),
      );
    },
  );
}

class _MemoryWordsSheet extends StatefulWidget {
  const _MemoryWordsSheet({
    required this.l10n,
    required this.initial,
    required this.onSave,
  });

  final AppLocalizations l10n;
  final List<String> initial;
  final Future<void> Function(List<String> words) onSave;

  @override
  State<_MemoryWordsSheet> createState() => _MemoryWordsSheetState();
}

class _MemoryWordsSheetState extends State<_MemoryWordsSheet> {
  late final List<String> _words = [...widget.initial];
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      return;
    }
    final exists = _words.any(
      (word) => word.toLowerCase() == value.toLowerCase(),
    );
    if (!exists) {
      setState(() => _words.add(value));
      await widget.onSave(_words);
    }
    _controller.clear();
  }

  Future<void> _remove(String word) async {
    setState(() => _words.remove(word));
    await widget.onSave(_words);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.memoryWordsTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.memoryWordsHint,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: l10n.memoryWordsField,
                    ),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(onPressed: _add, icon: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 16),
            if (_words.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  l10n.memoryWordsEmpty,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final word in _words)
                        InputChip(
                          label: Text(word),
                          onDeleted: () => _remove(word),
                        ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            AppButton(
              label: l10n.actionContinue,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
