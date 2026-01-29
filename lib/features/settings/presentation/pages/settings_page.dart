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
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // User ID
          _buildInfoTile(
            l10n.userIdLabel,
            _truncate(widget.userId),
            Icons.person_outline,
          ),
          const SizedBox(height: 16),
          // Device ID
          _buildInfoTile(
            l10n.deviceIdLabel,
            _truncate(_deviceId),
            Icons.devices_outlined,
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
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
                Navigator.of(context).pop(); // Go back before sign out completes
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
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFBB86FC)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
