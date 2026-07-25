import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_pulse_mobile/core/utils/app_toast.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';
import 'package:route_pulse_mobile/features/client/presentation/notifiers/delete_client_notifier.dart';
import 'package:route_pulse_mobile/features/client/presentation/notifiers/get_clients_list_notifier.dart';
import 'package:route_pulse_mobile/shared/states/http_state.dart';
import 'package:route_pulse_mobile/shared/widgets/confirm_delete_dialog.dart';

class DeleteClientDialog extends ConsumerWidget {
  final Client client;

  const DeleteClientDialog({super.key, required this.client});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deleteClientProvider);
    final vm = ref.read(deleteClientProvider.notifier);

    ref.listen(deleteClientProvider, (previous, next) {
      if (previous is HttpLoading && next is HttpSuccess) {
        AppToast.success(context, next.message ?? 'Client supprimé');

        ref.read(getClientsListProvider.notifier).refetch();

        if (context.mounted) Navigator.pop(context, true);
        return;
      }

      if (next is HttpError) AppToast.error(context, next.message);
    });

    return ConfirmDeleteDialog(
      title: 'Supprimer le client',
      message:
          'Voulez-vous vraiment supprimer ${client.name} ? Cette action est irréversible.',
      isLoading: state is HttpLoading,
      onConfirm: () => vm.submit(client.id),
    );
  }
}
