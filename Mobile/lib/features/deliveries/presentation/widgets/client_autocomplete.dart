import 'package:flutter/material.dart';
import 'package:name_avatar/name_avatar.dart';
import 'package:route_pulse_mobile/core/themes/app_colors.dart';
import 'package:route_pulse_mobile/core/themes/app_typography.dart';
import 'package:route_pulse_mobile/features/client/domain/entities/client.dart';

class ClientAutocompleteView extends StatelessWidget {
  final Iterable<Client> options;
  final Function(Client option) onSelect;

  const ClientAutocompleteView({
    super.key,
    required this.options,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 3,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 48,
            maxHeight: 200,
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            itemCount: options.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final option = options.elementAt(index);

              return ListTile(
                leading: NameAvatar(
                  name: option.name,
                  radius: 24,
                  isTwoChar: true,
                ),
                dense: true,
                title: Text(
                  option.name,
                  style: TextStyle(fontSize: AppTypography.body),
                ),
                subtitle: Text(
                  option.phoneNumber,
                  style: TextStyle(
                    color: AppColors.mutedForeground,
                    fontSize: AppTypography.small,
                  ),
                ),
                onTap: () => onSelect(option),
              );
            },
          ),
        ),
      ),
    );
  }
}
