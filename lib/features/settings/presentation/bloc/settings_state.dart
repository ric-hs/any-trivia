import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool isSoundMuted;

  const SettingsState({this.isSoundMuted = false});

  SettingsState copyWith({bool? isSoundMuted}) {
    return SettingsState(
      isSoundMuted: isSoundMuted ?? this.isSoundMuted,
    );
  }

  @override
  List<Object> get props => [isSoundMuted];
}
