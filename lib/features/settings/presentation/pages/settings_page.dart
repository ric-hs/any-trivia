import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/core/localization/bloc/locale_bloc.dart';
import 'package:endless_trivia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:endless_trivia/features/auth/presentation/bloc/auth_event.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:endless_trivia/core/services/device_info_service.dart';
import 'package:endless_trivia/core/di/injection_container.dart' as di;

class SettingsPage extends StatefulWidget {
  final String userId;

  const SettingsPage({super.key, required this.userId});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _deviceId;

  @override
  void initState() {
    super.initState();
    _loadDeviceId();
  }

  Future<void> _loadDeviceId() async {
    final deviceId = await di.sl<DeviceInfoService>().getHardwareId();
    if (mounted) {
      setState(() {
        _deviceId = deviceId;
      });
    }
  }

  String _truncate(String? text, {int length = 8}) {
    if (text == null || text.isEmpty) return '---';
    if (text.length <= length) return text;
    return '${text.substring(0, length)}...';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                // Language Selection
                Text(
                  l10n.language,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<LocaleBloc, LocaleState>(
                  builder: (context, state) {
                    final currentLocale =
                        state.locale ?? Localizations.localeOf(context);
                    return RadioGroup<String>(
                      groupValue: currentLocale.languageCode,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<LocaleBloc>().add(ChangeLocale(value));
                        }
                      },
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: Text(l10n.english),
                            value: 'en',
                            contentPadding: EdgeInsets.zero,
                            activeColor: const Color(0xFFBB86FC),
                          ),
                          RadioListTile<String>(
                            title: Text(l10n.spanish),
                            value: 'es',
                            contentPadding: EdgeInsets.zero,
                            activeColor: const Color(0xFFBB86FC),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 48),

                // Sign Out
                if (kDebugMode) ...[
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.logout),
                      label: Text(l10n.signOut),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withValues(alpha: 0.1),
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Discrete IDs
          Center(
            child: Opacity(
              opacity: 0.3,
              child: Column(
                children: [
                  Text(
                    '${l10n.userIdLabel}: ${_truncate(widget.userId)}',
                    style: const TextStyle(fontSize: 10),
                  ),
                  Text(
                    '${l10n.deviceIdLabel}: ${_truncate(_deviceId)}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 48),
        ],
      ),
    );
  }
}
