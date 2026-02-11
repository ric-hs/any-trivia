import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ToggleMuteSounds extends SettingsEvent {
  final bool isMuted;

  const ToggleMuteSounds(this.isMuted);

  @override
  List<Object> get props => [isMuted];
}
