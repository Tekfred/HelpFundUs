# HelpFundUs

HelpFundUs is a Flutter crowdfunding application for discovering verified
causes, donating securely, and starting fundraisers.

## App shell

The authenticated UI is implemented in `lib/features/app_shell/` with the
requested feature-first structure. It includes five role-aware tabs:

- Donor: Home, Explore, Activity, Inbox, Account.
- Fundraiser: Home, Campaigns, Activity, Inbox, Account.

The Account tab switches between both roles on the same account. The shell
also provides the animated 84px bottom navigation, unread badges, first-entry
loading treatment, browser online/offline banner, and URI deep-link handling
through `AppShellController.handleDeepLink`.

The Donation-flow brief from the current product specification is recorded as
the next implementation scope; donation screens have not been created in this
app-shell change.

## Animation architecture

Page navigation is handled by
`lib/core/animation/spring_page_switcher.dart`. Every page flow provides a
keyed child, allowing the switcher to retain the outgoing page while the new
page enters.

The shared switcher now uses a continuous horizontal slide by default:

- Forward navigation moves the old page left and the new page in from the
  right.
- Back navigation moves the old page right and the new page in from the left.
- Both pages animate concurrently for 320 ms.
- There is no blank interval between pages.

This default applies to onboarding, authentication, and app-root mode
transitions. The previous fade behavior remains available when a flow
explicitly sets `transitionStyle: PageTransitionStyle.fade`. Fade mode keeps
the old 150 ms exit, 70 ms blank gap, and 180 ms enter timing.

Content inside each page uses
`lib/core/animation/reveal_on_enter.dart`. `RevealOnEnter` is intentionally
separate from the page transition: it fades, rises, and blurs individual
elements into focus using indexed delays. This preserves the onboarding
cascade while the page itself moves normally.

The full implementation history, behavior diagrams, validation results, known
test issues, and continuation notes are in
[`ANIMATION_HANDOFF.md`](ANIMATION_HANDOFF.md).

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
