import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_blob_background.dart';
import '../controllers/psychologist_controller.dart';
import '../controllers/psychologist_state.dart';
import '../widgets/emergency_hotline_card.dart';
import '../widgets/psychologist_card.dart';

class NearbyPsychologistsPage extends ConsumerStatefulWidget {
  const NearbyPsychologistsPage({
    super.key,
    this.onBack,
  });

  final VoidCallback? onBack;

  @override
  ConsumerState<NearbyPsychologistsPage> createState() =>
      _NearbyPsychologistsPageState();
}

class _NearbyPsychologistsPageState
    extends ConsumerState<NearbyPsychologistsPage> {
  final TextEditingController _searchController = TextEditingController();

  static const _cities = [
    'Semua',
    'Batam',
    'Malang',
    'Jakarta',
    'Bandung',
    'Surabaya',
    'Medan',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(psychologistControllerProvider);
    final notifier = ref.read(psychologistControllerProvider.notifier);
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final goBack = widget.onBack ?? () => Navigator.of(context).maybePop();

    return Scaffold(
      backgroundColor: colors.background,
      body: AppBlobBackground(
        subtle: true,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar
              _buildTopBar(context, l10n, goBack),

              // Scrollable Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: notifier.initLocationAndData,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.ui(AppSpacing.lg),
                      vertical: context.ui(AppSpacing.sm),
                    ),
                    children: [
                      // Banner Hotline Bantuan Darurat
                      const EmergencyHotlineCard(),
                      SizedBox(height: context.ui(AppSpacing.md)),

                      // Kartu Deteksi Lokasi
                      _buildLocationCard(context, l10n, state, notifier),
                      SizedBox(height: context.ui(AppSpacing.md)),

                      // Search Bar
                      _buildSearchBar(context, l10n, notifier),
                      SizedBox(height: context.ui(AppSpacing.sm)),

                      // Filter Kota Chips
                      _buildCityChips(context, l10n, state, notifier),
                      SizedBox(height: context.ui(AppSpacing.md)),

                      // Judul List & Total Hasil
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              l10n.nearbyAvailableListTitle,
                              style: AppTextStyles.title(context).copyWith(
                                fontSize: context.ui(16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: context.ui(8)),
                          Text(
                            l10n.nearbyCountFound(state.psychologists.length),
                            style: TextStyle(
                              fontSize: context.ui(12),
                              color: colors.body,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.ui(AppSpacing.sm)),

                      // List Items atau Loading/Empty View
                      if (state.isLoading)
                        Padding(
                          padding: EdgeInsets.all(context.ui(AppSpacing.xl)),
                          child: const Center(child: CircularProgressIndicator()),
                        )
                      else if (state.psychologists.isEmpty)
                        _buildEmptyView(context, l10n)
                      else
                        ...state.psychologists.map(
                          (psy) => PsychologistCard(
                            key: ValueKey(psy.id),
                            psychologist: psy,
                          ),
                        ),
                      SizedBox(height: context.ui(AppSpacing.xl)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    AppLocalizations l10n,
    VoidCallback goBack,
  ) {
    final colors = AppColors.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.ui(AppSpacing.sm),
        context.ui(AppSpacing.xs),
        context.ui(AppSpacing.md),
        context.ui(AppSpacing.xs),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: goBack,
            tooltip: l10n.nearbyPsychologistsBackTooltip,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: colors.navy,
              size: context.ui(20),
            ),
          ),
          SizedBox(width: context.ui(AppSpacing.xs)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.nearbyPsychologistsTitle,
                  style: TextStyle(
                    fontSize: context.ui(18),
                    fontWeight: FontWeight.bold,
                    color: colors.navy,
                  ),
                ),
                Text(
                  l10n.nearbyPsychologistsSubtitle,
                  style: TextStyle(
                    fontSize: context.ui(12),
                    color: colors.body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(
    BuildContext context,
    AppLocalizations l10n,
    PsychologistState state,
    PsychologistController notifier,
  ) {
    final colors = AppColors.of(context);
    return Container(
      padding: EdgeInsets.all(context.ui(AppSpacing.md)),
      decoration: BoxDecoration(
        color: colors.blob.withOpacity(0.5),
        borderRadius: BorderRadius.circular(context.ui(14)),
        border: Border.all(color: colors.border.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(
            state.hasGpsLocation
                ? Icons.my_location_rounded
                : Icons.location_city_rounded,
            color: state.hasGpsLocation ? colors.leaf : colors.primary,
            size: context.ui(22),
          ),
          SizedBox(width: context.ui(AppSpacing.sm)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.hasGpsLocation
                      ? l10n.nearbyLocationGpsActive
                      : l10n.nearbyLocationFallback,
                  style: TextStyle(
                    fontSize: context.ui(11),
                    color: colors.body,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  state.locationLabel,
                  style: TextStyle(
                    fontSize: context.ui(13),
                    fontWeight: FontWeight.w600,
                    color: colors.navy,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (state.isLocating)
            SizedBox(
              width: context.ui(18),
              height: context.ui(18),
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          else
            IconButton(
              icon: Icon(Icons.refresh_rounded, size: context.ui(20)),
              tooltip: l10n.nearbyRefreshGpsTooltip,
              onPressed: notifier.initLocationAndData,
              color: colors.primary,
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    AppLocalizations l10n,
    PsychologistController notifier,
  ) {
    final colors = AppColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(context.ui(12)),
        border: Border.all(color: colors.border.withOpacity(0.5)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: notifier.setSearchQuery,
        decoration: InputDecoration(
          hintText: l10n.nearbySearchPlaceholder,
          hintStyle: TextStyle(
            fontSize: context.ui(13),
            color: colors.body.withOpacity(0.6),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colors.body,
            size: context.ui(20),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    notifier.setSearchQuery('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: context.ui(12)),
        ),
      ),
    );
  }

  Widget _buildCityChips(
    BuildContext context,
    AppLocalizations l10n,
    PsychologistState state,
    PsychologistController notifier,
  ) {
    final colors = AppColors.of(context);
    return SizedBox(
      height: context.ui(38),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _cities.length,
        separatorBuilder: (_, __) => SizedBox(width: context.ui(8)),
        itemBuilder: (context, index) {
          final city = _cities[index];
          final isSelected = state.selectedCity.toLowerCase() == city.toLowerCase();
          final displayCity = city == 'Semua' ? l10n.nearbyCityAll : city;

          return ChoiceChip(
            label: Text(
              displayCity,
              style: TextStyle(
                fontSize: context.ui(12),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : colors.navy,
              ),
            ),
            selected: isSelected,
            selectedColor: colors.primary,
            backgroundColor: colors.surface,
            side: BorderSide(
              color: isSelected ? colors.primary : colors.border.withOpacity(0.5),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.ui(20)),
            ),
            onSelected: (_) => notifier.setCityFilter(city),
          );
        },
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context, AppLocalizations l10n) {
    final colors = AppColors.of(context);
    return Container(
      padding: EdgeInsets.all(context.ui(AppSpacing.xl)),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: context.ui(48),
            color: colors.body.withOpacity(0.4),
          ),
          SizedBox(height: context.ui(AppSpacing.sm)),
          Text(
            l10n.nearbyEmptyTitle,
            style: TextStyle(
              fontSize: context.ui(14),
              fontWeight: FontWeight.bold,
              color: colors.navy,
            ),
          ),
          SizedBox(height: context.ui(AppSpacing.xs)),
          Text(
            l10n.nearbyEmptySubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.ui(12),
              color: colors.body,
            ),
          ),
        ],
      ),
    );
  }
}
