# HelpFundUs system handoff

## Purpose

HelpFundUs is a Flutter fundraising prototype with onboarding, authentication, guest campaign browsing, donor/fundraiser app-shell modes, campaign discovery/detail flows, and a local donation checkout flow. Campaign and checkout data are local placeholders prepared for later API integration.

## Application entry and navigation

`lib/main.dart` creates `HelpFundUsApp`, configures the theme and global scroll behavior, and opens `AppRoot`.

`AppRoot` is the top-level flow coordinator:

```text
Onboarding
  ├─ Sign in / Create account → AuthFlow
  └─ Browse campaigns first → guest AppShell

AuthFlow → authenticated AppShell
AppShell sign out → Onboarding
```

`SpringPageSwitcher` provides the transitions between root flows. `AppRoot` owns `OnboardingController` and `AuthController`.

## Feature structure

```text
lib/
├── core/
│   ├── animation/
│   ├── scroll/helpfundus_scroll_behavior.dart
│   ├── theme/
│   └── widgets/
├── features/
│   ├── app_shell/
│   │   ├── presentation/app_shell.dart
│   │   ├── presentation/widgets/
│   │   └── state/
│   ├── campaign/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/donor_home/
│   │       ├── screens/explore/
│   │       ├── screens/category_campaigns/
│   │       ├── screens/campaign_detail/
│   │       └── widgets/
│   ├── donation/
│   │   ├── presentation/screens/
│   │   │   ├── choose_donation_amount/
│   │   │   ├── donation_details/
│   │   │   ├── payment_method/
│   │   │   ├── payment_authorization/
│   │   │   ├── payment_processing/
│   │   │   ├── donation_success|pending|failed|receipt|detail/
│   │   │   ├── my_donations/
│   │   │   └── widgets/
│   │   └── state/donation_controller.dart
│   ├── fundraiser/presentation/{home,campaigns}/
│   ├── activity/presentation/activity/
│   ├── inbox/presentation/inbox/
│   ├── account/presentation/account/
│   ├── auth/
│   └── onboarding/
└── app_root.dart
```

### Dependency boundaries

- `app_shell` owns tabs, role/guest state, login gates, online status, and shell navigation.
- `campaign` owns campaign catalog data, repository contracts, discovery, category results, and detail screens.
- `donation` is independent of shell state. It receives campaign display values through constructors and owns checkout state through `DonationController`.
- Domain does not import Flutter presentation code. Campaign presentation currently reads the local catalog; the repository/API placeholders are ready for a backend swap.

## App shell and guest access

`AppShellController` manages donor/fundraiser role, active tab, deep links, and online state.

Guest shell:

- Shows Home, Explore, and Sign In navigation.
- Allows browsing campaign home, explore, categories, campaign detail, gallery, and share UI.
- Donate and fundraiser creation actions show `LoginGate`.
- `LoginGate` routes to Sign In or Register through callbacks supplied by `AppRoot`.

Authenticated donor shell tabs: Home, Explore, Activity, Inbox, Account.

Fundraiser mode swaps the main screens to Fundraiser Home and Campaigns while retaining the shell.

## Campaign feature

### Local data and future API layer

Current local campaign data is in `features/campaign/data/campaign_catalog.dart`.

There are 12 local campaigns with category, status, gradient, campaign story, milestones, updates, gallery, progress, donors, fundraiser and location data.

The campaign domain includes:

- `Campaign`
- `CampaignCategory`
- `CampaignMilestone`
- `CampaignUpdate`
- `CampaignStatus`

`CampaignRepository` exposes all, featured, trending, recent, category, and ID lookup operations. `CampaignRepositoryImpl` currently adapts the local catalog. `CampaignApi` is a non-networking placeholder.

### Campaign navigation

```text
Donor Home / Explore / Category results
  → CampaignDetailScreen(campaign: selectedCampaign)
    ├─ Gallery viewer
    ├─ Campaign milestones
    ├─ Campaign updates
    ├─ Share sheet
    └─ Donate Now → donation flow (or guest login gate)
```

Shared campaign cards stay under `campaign/presentation/widgets/`. Milestone and update cards belong inside the campaign detail flow because they are only used there.

## Donation flow

```text
Campaign Detail: Donate Now
  ├─ Guest → LoginGate
  └─ Authenticated → ChooseDonationAmountScreen
       → DonationDetailsScreen
       → PaymentMethodScreen
       → PaymentAuthorizationScreen
       → PaymentProcessingScreen
       → outcome / receipt screens
```

### Donation state

`DonationController` owns local checkout state:

- selected donation amount
- selected payment method
- donation terms confirmation
- 2.9% fee calculation
- total calculation
- amount validation (`$5` to `$10,000`)

Amount selection intentionally starts empty (`0`): no amount tile is selected and Continue is disabled until a valid amount is selected, entered, or nudged.

### Donation amount screen

`choose_donation_amount/choose_donation_amount_screen.dart` orchestrates the page and navigation. Its local widgets are:

- `campaign_summary.dart`
- `suggested_amounts.dart`
- `custom_amount_input.dart`
- `amount_nudge_controls.dart`
- `fee_summary.dart`
- `donor_requirement_notice.dart`
- `donation_continue_button.dart`

The screen uses campaign progress, predefined amounts, custom input, amount nudges, a fee/campaign-receives summary and donor verification notice.

### Donation details and payment method

`DonationDetailsScreen` includes campaign summary, selected amount, donor information, anonymous donation toggle, optional message, payment summary, terms checkbox and the payment CTA.

`PaymentMethodScreen` includes campaign summary, card/mobile money/bank transfer/wallet choices, fee labels, security guidance, and the payment CTA.

### Shared donation CTA behavior

`presentation/screens/widgets/donation_flow_scaffold.dart` owns the donation header and bottom CTA area.

All donation CTAs use this responsive strategy:

```dart
SafeArea(
  top: false,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: SizedBox(
      width: double.infinity,
      height: 64,
      child: DonationPrimaryButton(...),
    ),
  ),
)
```

The explicit `double.infinity` is important. Without it, `FilledButton` uses its intrinsic label width and appears narrow on Android. The shared button keeps labels centred; long payment labels are constrained to one line and scale down only when needed.

## Scroll behavior

`core/scroll/helpfundus_scroll_behavior.dart` is set globally in `MaterialApp`.

- Android/Fuchsia use a subtle low-opacity glow instead of the Material 3 stretch effect.
- iOS and desktop keep their normal platform behavior.
- `_ShellScrollBehavior` extends the shared behavior and only adds the shell scrollbar, so it cannot re-enable stretch inside shell tabs.

## Key UI conventions

- Theme tokens: `AppColors`, `AppTextStyles`, and `AppDimens` under `core/theme/`.
- Background: `AppColors.background`; cards/sheets: `AppColors.surface` / white.
- Donation flow uses compact cards and fixed SafeArea-aware CTAs to avoid overlapping system navigation areas.
- A `ListTile` inside a decorated card must have a local `Material` ancestor if it is interactive. The anonymous donation checkbox follows this rule to keep ink effects visible and avoid the Flutter assertion.

## Current limitations / next API work

- Campaign catalog, donor identity, payment provider handoff and outcomes are local sample data.
- Pass the selected campaign model through every checkout step once the payment domain is introduced; some later payment/outcome copy remains sample campaign text.
- Connect `CampaignApi` and `CampaignRepositoryImpl` to a real backend without importing presentation code into domain/data.
- Replace local checkout simulation with provider-specific payment status handling and secure server-side validation.

## Validation

Run after changes:

```bash
dart format lib
flutter analyze --no-pub
```

At the time of this handoff, analysis has no build errors introduced by the current work. Existing non-blocking warnings include unused development code, deprecated web online-status APIs, and an unused fundraiser import.
