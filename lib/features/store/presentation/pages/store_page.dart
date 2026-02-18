import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:endless_trivia/core/presentation/widgets/gradient_background.dart';
import 'package:endless_trivia/core/presentation/widgets/glass_container.dart';
import 'package:endless_trivia/features/store/data/services/revenue_cat_service.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:endless_trivia/features/store/presentation/widgets/store_item_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_state.dart';
import 'package:endless_trivia/core/presentation/widgets/custom_snackbar.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  Offerings? _offerings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOfferings();
  }

  Future<void> _fetchOfferings() async {
    final offerings = await RevenueCatService().getOfferings();
    if (mounted) {
      setState(() {
        _offerings = offerings;
        _isLoading = false;
      });
    }
  }

  Future<void> _buyPackage(Package package) async {
    final userId = context.read<AuthBloc>().state.user?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.error(
          message: AppLocalizations.of(context)?.loginToPurchase ??
              'Please log in to purchase',
          context: context,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Get initial tokens from ProfileBloc
      final profileBloc = context.read<ProfileBloc>();
      final initialTokens = profileBloc.state is ProfileLoaded
          ? (profileBloc.state as ProfileLoaded).profile.tokens
          : 0;

      // 2. Perform purchase
      await RevenueCatService().purchasePackage(package, userId);

      // 3. Wait for tokens to increase
      // First, check if the state is already updated (race condition handling)
      bool isUpdated = false;
      if (profileBloc.state is ProfileLoaded) {
        final currentTokens =
            (profileBloc.state as ProfileLoaded).profile.tokens;
        if (currentTokens > initialTokens) {
          isUpdated = true;
        }
      }

      if (!isUpdated) {
        // We expect the backend webhook to update the user's tokens,
        // which will then be reflected in the ProfileBloc via a stream subscription.
        try {
          await profileBloc.stream
              .firstWhere((state) {
                if (state is ProfileLoaded) {
                  return state.profile.tokens > initialTokens;
                }
                return false;
              })
              .timeout(const Duration(seconds: 15));
          isUpdated = true;
        } catch (e) {
          // Timeout or error waiting for tokens.
          // We still consider the purchase successful (RevenueCat succeeded),
          // but the UI update might be delayed.
          debugPrint('Token update timed out or failed: $e');
        }
      }

      if (mounted) {
        if (isUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.success(
              message: AppLocalizations.of(context)?.purchaseSuccessTokensAdded ??
                  'Purchase successful! Tokens added.',
              context: context,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.warning(
              message: AppLocalizations.of(
                    context,
                  )?.purchaseSuccessTokensAddedShortly ??
                  'Purchase successful! Tokens will be added shortly.',
              context: context,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        PurchasesErrorCode? errorCode;
        if (e is PlatformException) {
          errorCode = PurchasesErrorHelper.getErrorCode(e);
        }

        if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
          return;
        }

        if (errorCode == PurchasesErrorCode.paymentPendingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.warning(
              message: AppLocalizations.of(context)
                      ?.purchaseFailedPaymentPendingError ??
                  'Payment pending...',
              context: context,
            ),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.error(
            message: AppLocalizations.of(context)?.purchaseFailed ??
                'Purchase failed',
            context: context,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Future<void> _restorePurchases() async {
  //   setState(() => _isLoading = true);
  //   await RevenueCatService().restorePurchases();
  //   if (mounted) {
  //     setState(() => _isLoading = false);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Purchases restored')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)?.storeTitle ?? 'Store',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.restore, color: Colors.white),
          //   onPressed: _restorePurchases,
          //   tooltip: 'Restore Purchases',
          // ),
        ],
      ),
      body: GradientBackground(
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_offerings == null ||
        _offerings!.current == null ||
        _offerings!.current!.availablePackages.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            GlassContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.storefront_rounded,
                    size: 64,
                    color: Color(0xFF00E5FF),
                  ).animate().scale(
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)?.storeComingSoon ??
                        'Coming Soon',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)?.storeWorkingOnItems ??
                        'We are working on new items!',
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),
            ).animate().slideY(begin: 0.2, end: 0, duration: 500.ms),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _offerings!.current!.availablePackages.length,
      itemBuilder: (context, index) {
        final package = _offerings!.current!.availablePackages[index];
        return StoreItemCard(
          package: package,
          onBuy: () => _buyPackage(package),
          index: index,
        );
      },
    );
  }
}
