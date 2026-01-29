import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:endless_trivia/core/services/locale_service.dart';

// Events
abstract class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object?> get props => [];
}

class LoadLocale extends LocaleEvent {}

class ChangeLocale extends LocaleEvent {
  final String languageCode;

  const ChangeLocale(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

// State
class LocaleState extends Equatable {
  final Locale? locale;

  const LocaleState(this.locale);

  @override
  List<Object?> get props => [locale];
}

// Bloc
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final LocaleService _localeService;

  LocaleBloc(this._localeService) : super(const LocaleState(null)) {
    on<LoadLocale>(_onLoadLocale);
    on<ChangeLocale>(_onChangeLocale);
  }

  void _onLoadLocale(LoadLocale event, Emitter<LocaleState> emit) {
    final locale = _localeService.getLocale();
    emit(LocaleState(locale));
  }

  Future<void> _onChangeLocale(ChangeLocale event, Emitter<LocaleState> emit) async {
    await _localeService.setLocale(event.languageCode);
    emit(LocaleState(Locale(event.languageCode)));
  }
}
