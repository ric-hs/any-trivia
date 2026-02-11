import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/core/localization/bloc/locale_bloc.dart';
import 'package:endless_trivia/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:endless_trivia/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:endless_trivia/features/settings/presentation/bloc/settings_event.dart';
import 'package:endless_trivia/features/settings/presentation/bloc/settings_state.dart';
import 'package:endless_trivia/features/auth/presentation/bloc/auth_event.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:endless_trivia/core/services/device_info_service.dart';
import 'package:endless_trivia/core/di/injection_container.dart' as di;
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final String userId;

  const SettingsPage({super.key, required this.userId});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _deviceId;

  @override
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

  Future<void> _contactSupport() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'contacto@ricardohs.com',
      query: 'subject=Endless%20Trivia%20Support',
    );

    if (!await launchUrl(emailLaunchUri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch email app')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => di.sl<SettingsBloc>()..add(LoadSettings()),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  // Sound Settings
                  Text(
                    l10n.sound,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                    return SwitchListTile(
                      title: Text(l10n.soundEffects),
                      value: !state.isSoundMuted,
                      onChanged: (bool value) {
                        context.read<SettingsBloc>().add(ToggleMuteSounds(!value));
                      },
                      secondary: Icon(
                        state.isSoundMuted ? Icons.volume_off : Icons.volume_up,
                        color: const Color(0xFFBB86FC),
                      ),
                      activeColor: const Color(0xFFBB86FC),
                      contentPadding: EdgeInsets.zero,
                    );
                    },
                  ),
                  const SizedBox(height: 32),
  
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
                          backgroundColor: Color(0xFFD300F9).withValues(alpha: 0.1),
                          foregroundColor: Color(0xFFD300F9),
                          side: const BorderSide(color: Color(0xFFD300F9)),
                          elevation: 0
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
  
            // Contact Support
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _contactSupport,
                icon: const Icon(Icons.email_outlined),
                label: Text(l10n.contactSupport),
              ),
            ),
            const SizedBox(height: 24),
            // Discrete IDs
            Center(
              child: Opacity(
                opacity: 0.3,
                child: Column(
                  children: [
                    Text(
                      '${l10n.userIdLabel}: ${widget.userId}',
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
      ),
    );
  }
}
