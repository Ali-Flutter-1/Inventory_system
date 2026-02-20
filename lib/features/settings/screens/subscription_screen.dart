import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';

enum SubscriptionPlan { free, monthly, pro, premium }

class _PlanData {
  const _PlanData({
    required this.key,
    required this.price,
    this.intervalKey,
    this.badgeKey,
    required this.features,
    required this.glassColors,
    this.glowColor,
    this.icon,
  });

  final String key;
  final String price;
  final String? intervalKey;
  final String? badgeKey;
  final List<String> features;
  final List<Color> glassColors;
  final Color? glowColor;
  final IconData? icon;
}

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionPlan _selectedPlan = SubscriptionPlan.free;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<_PlanData> _buildPlans(String Function(String) t) {
    return [
      _PlanData(
        key: 'planFree',
        price: '0',
        intervalKey: 'freeForever',
        badgeKey: null,
        icon: Icons.star_outline_rounded,
        features: [
          t('upToProducts').replaceAll('{count}', '50'),
          t('upToEmployees').replaceAll('{count}', '2'),
          t('expenseTracking'),
          t('basicReports'),
          t('oneLocation'),
          t('emailSupport'),
        ],
        glassColors: [
          AppTheme.accent.withValues(alpha: 0.22),
          AppTheme.primary.withValues(alpha: 0.12),
        ],
        glowColor: AppTheme.primary.withValues(alpha: 0.25),
      ),
      _PlanData(
        key: 'planMonthly',
        price: '9.99',
        intervalKey: 'perMonth',
        badgeKey: null,
        icon: Icons.calendar_month_rounded,
        features: [
          t('upToProducts').replaceAll('{count}', '500'),
          t('upToEmployees').replaceAll('{count}', '10'),
          t('advancedReports'),
          '3 ${t('locations')}',
          t('exportData'),
          t('prioritySupport'),
        ],
        glassColors: [
          AppTheme.accent.withValues(alpha: 0.22),
          AppTheme.primary.withValues(alpha: 0.12),
        ],
        glowColor: AppTheme.primary.withValues(alpha: 0.25),
      ),
      _PlanData(
        key: 'planPro',
        price: '79',
        intervalKey: 'perYear',
        badgeKey: 'bestValue',
        icon: Icons.workspace_premium_rounded,
        features: [
          t('upToProducts').replaceAll('{count}', '2000'),
          t('upToEmployees').replaceAll('{count}', '50'),
          t('customReports'),
          '10 ${t('locations')}',
          t('apiAccess'),
          t('prioritySupport'),
        ],
        glassColors: [
          AppTheme.accent.withValues(alpha: 0.22),
          AppTheme.primary.withValues(alpha: 0.12),
        ],
        glowColor: AppTheme.primary.withValues(alpha: 0.25),
      ),
      _PlanData(
        key: 'planPremium',
        price: '199',
        intervalKey: 'perYear',
        badgeKey: 'allIncluded',
        icon: Icons.diamond_rounded,
        features: [
          t('unlimitedProducts'),
          t('unlimitedEmployees'),
          t('analyticsDashboard'),
          t('multiCompany'),
          t('apiAccess'),
          t('dedicatedSupport'),
        ],
        glassColors: [
          AppTheme.accent.withValues(alpha: 0.22),
          AppTheme.primary.withValues(alpha: 0.12),
        ],
        glowColor: AppTheme.primary.withValues(alpha: 0.25),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppLocalizations.tr(context, key);
    final theme = Theme.of(context);
    final plans = _buildPlans(t);
    const cardWidth = 300.0;
    const cardSpacing = 16.0;
    const horizontalPadding = 20.0;

    return AppScaffold(
      showDrawer: false,
      title: t('subscription'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryDark,
              Color(0xFF1A2744),
              AppTheme.primary,
              Color(0xFF0F1A38),
            ],
            stops: [0.0, 0.35, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                t('choosePlan'),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 24),
              // Horizontal scrolling plan cards
              SizedBox(
                height: 420,
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                  itemCount: plans.length,
                  separatorBuilder: (_, __) => const SizedBox(width: cardSpacing),
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final planEnum = SubscriptionPlan.values[index];
                    final isSelected = _selectedPlan == planEnum;
                    return SizedBox(
                      width: cardWidth,
                      child: _PlanCard(
                        plan: plan,
                        planKey: plan.key,
                        t: t,
                        theme: theme,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedPlan = planEnum),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Scroll indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  plans.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: SubscriptionPlan.values[i] == _selectedPlan ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: SubscriptionPlan.values[i] == _selectedPlan
                          ? AppTheme.gold
                          : Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // CTA button with glass effect
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.gold.withValues(alpha: 0.9),
                            AppTheme.gold,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.gold.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${t('upgrade')} – Coming soon'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppTheme.primary,
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                              t('getStarted'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.planKey,
    required this.t,
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  final _PlanData plan;
  final String planKey;
  final String Function(String) t;
  final ThemeData theme;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: plan.glassColors,
              ),
              border: Border.all(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.25),
                width: isSelected ? 2.5 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
                if (plan.glowColor != null)
                  BoxShadow(
                    color: plan.glowColor!,
                    blurRadius: isSelected ? 28 : 18,
                    spreadRadius: isSelected ? 2 : 0,
                    offset: const Offset(0, 8),
                  ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon + badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          plan.icon ?? Icons.inventory_2_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const Spacer(),
                      if (plan.badgeKey != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.gold.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            t(plan.badgeKey!),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Plan name
                  Text(
                    t(planKey),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        plan.price == '0'
                            ? t('freeForever')
                            : '\$${plan.price}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.gold,
                          fontSize: 22,
                        ),
                      ),
                      if (plan.intervalKey != null && plan.price != '0') ...[
                        const SizedBox(width: 4),
                        Text(
                          t(plan.intervalKey!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Features
                  ...plan.features.map((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 18,
                              color: AppTheme.success.withValues(alpha: 0.95),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                feature,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
