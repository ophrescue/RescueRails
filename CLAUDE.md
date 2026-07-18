# RescueRails (Operation Paws for Homes)

## App overview

RescueRails is the web app for Operation Paws for Homes, a dog/cat rescue.
It has a public site (adoption listings, applications, donations) and an
internal admin/staff system (`app/controllers/dogs/manager`,
`app/controllers/cats/manager`, dashboards) for managing dogs, cats,
adopters, volunteers, and staff. No admin-engine gem (ActiveAdmin/RailsAdmin)
is used — the admin UI is hand-built.

The app is ~13 years old (`db/migrate` goes back to 2011) and has never, in
its history, gone past Rails 6.1 — see "Upgrade roadmap" below.

**Stack:**
- Ruby 3.0.5, Rails 7.1.6 (as of the pass recorded below)
- PostgreSQL, `pg` gem
- Auth: **Clearance** (not Devise) — see `config/initializers/clearance.rb`
- File uploads: **kt-paperclip** (not ActiveStorage, though activestorage
  ships with Rails regardless)
- Background jobs: **DelayedJob** (not Sidekiq)
- Asset pipeline: **dual** Sprockets + Webpacker 5 (deprecated/unmaintained
  but still functional)
- Production app server: **Unicorn** (prod-only Gemfile group); **Puma**
  only in dev/test — a pre-existing inconsistency, not yet reconciled
- Deploy: Capistrano (not containers/Kamal) — the `.devcontainer/` setup
  is local-dev-only, unrelated to how production is deployed
- Tests: RSpec (~108 spec files across models/controllers/requests/
  features/mailers), FactoryBot, Capybara + Cuprite (headless Chrome)
  for feature/system specs, SimpleCov

**Key directories:** `app/models` (49), `app/controllers` (35, with
`cats/`/`dogs/` namespaces), `app/jobs`, `app/services`, `spec/` (mirrors
app/ plus `spec/features` for Capybara specs), `lib/` (custom autoloaded
code — Clearance guards, password strategy, Paperclip interpolations —
added to autoload/eager_load paths explicitly via
`config.paths.add 'lib', eager_load: true` in `config/application.rb`).

## Working conventions

This app is mid-way through a multi-pass dependency modernization
(everything was badly out of date: EOL Ruby, EOL Rails, deprecated gems).
Ground rules for every pass:

- **Limit changes to what's required for that specific upgrade.** Don't
  opportunistically bump unrelated gems, don't fix unrelated papercuts,
  don't fold in adjacent modernization work unless the current pass is
  literally blocked without it. If something forces an out-of-scope
  change, do the minimal version of it and say so explicitly in the
  commit message — don't let it expand further.
- **Rails major-version bumps happen one version at a time** (6.1 → 7.0 →
  7.1/7.2 → 8.0, not 6.1 → 8.0 directly).
- **Don't bump `config.load_defaults` in the same pass as a Rails version
  bump.** This app's `config/application.rb` has been stuck at
  `load_defaults 5.0` since long before this upgrade effort started, so
  catching it up is its own dedicated future pass with its own test
  cycle — not something to absorb silently while also swapping the
  framework version.
- **Verification gate: full RSpec suite, compared against a baseline
  captured before the change.** With ~108 spec files this is cheap enough
  to always run in full rather than by subset. Use `bin/rails` / `bin/rspec`
  binstubs, **not** `bundle exec rails` / `bundle exec rspec` — the latter
  fail with "command not found" in this devcontainer environment for
  unclear reasons; the binstubs work correctly.
- **Scoped `bundle update <gem> <gem> --conservative`, never a bare
  `bundle update`.** Review the resulting `Gemfile.lock` diff line by
  line — if gems outside the intended set move, stop and investigate
  before proceeding; don't wave it through.
- Runtime gem incompatibilities can exist even when `bundle install`
  resolves cleanly — a gem's version constraints not capping a newer
  Rails doesn't mean its code is actually compatible with it. Don't treat
  a successful `bundle update` as proof the app still works; the RSpec
  suite is the real gate.
- **One PR per pass, staged into a few reviewable commits** (e.g. forced
  companion-gem bumps in one commit, the core framework bump in another),
  not one PR per gem and not a single squashed commit.
- When investigating a boot/spec failure, check whether it reproduces on
  the *pre-upgrade* code (`git stash` / a clean checkout of the prior
  commit) before assuming it's caused by the change in progress — several
  issues found during Pass 1 (an empty dead model file, a Node/webpacker
  incompatibility) turned out to be pre-existing and unrelated.

## Upgrade roadmap / log

**Pass 1 — Rails 6.1.7.10 → 7.0.10 (Ruby stays 3.0.5): DONE**
(commits `48293d36`, `e0f56f7b` on `upgrade/rails-7.0`)

- Bumped `audited` (~> 4.5 → ~> 5.0): 4.10.0 hard-capped `activerecord < 6.2`,
  couldn't resolve against Rails 7 at all. Ran `audited:upgrade` generator
  (one migration, reorders two index column pairs on `audits`).
  - Confirmed hard-blocker; not opportunistic.
- Bumped `kt-paperclip` (~> 6 → ~> 7.2, resolved 7.3.0): 6.4.2's
  `AttachmentSizeValidator` referenced `ActiveModel::Validations::
  NumericalityValidator::CHECKS`, which Rails 7.0 renamed to
  `COMPARE_CHECKS`. This doesn't fail at `bundle install` time (no
  version cap in the gemspec), only at runtime as a `NameError` on any
  model with a Paperclip attachment — was responsible for ~70 of the
  RSpec suite's post-upgrade failures. kt-paperclip 7.2.0+ added the
  version-branch fix. Side benefit: drops the abandoned/yanked-version
  `mimemagic` dependency in favor of `marcel`.
  - Confirmed hard-blocker (discovered via full-suite failures, not
    static analysis); not opportunistic.
- Core Rails bump. Did **not** touch `config.load_defaults` (stays at
  5.0). Required one code fix: Rails 7.0 removed the classic
  `ActiveSupport::Dependencies` autoloader fallback that let
  `config/initializers/clearance.rb` reference `lib/`-autoloaded
  constants (`PasswordStrategies::WoofBark`, `Clearance::
  LockedAccountGuard`/`LogLastLoginAt`) directly at initializer-load
  time. Wrapped that initializer's body in
  `Rails.application.reloader.to_prepare`, per Rails' own upgrade guide.
- Full RSpec suite: 742 examples, 0 failures, 12 pending — matches the
  pre-upgrade baseline exactly.
- Explicitly deferred/out of scope for this pass (still true, not yet
  addressed):
  - **Webpacker replacement** (deprecated, unmaintained, but Rails 7.0
    still runs it fine).
  - **kt-paperclip → ActiveStorage migration.**
  - **Unicorn/Puma reconciliation** (prod uses Unicorn, dev/test uses Puma).
  - **Eventual Ruby bump** (3.0.5 is EOL; Rails 7.0 only required staying
    ≥ 2.7, so this pass didn't need it).
  - **Eventual `config.load_defaults` catch-up** (currently frozen at 5.0
    despite running Rails 7.0 code) — its own dedicated pass.
  - Pre-existing, unrelated-to-this-upgrade papercuts noticed along the
    way, still unaddressed: `.rubocop.yml` has a stale
    `TargetRubyVersion: 2.6`; CI (`.github/workflows/main.yml`) pins
    Node 16 (EOL) while the devcontainer already uses Node 18; an empty
    dead file at `app/models/animal.rb` fails `zeitwerk:check` (but not
    the real test/CI suites, which never eager-load); `webpacker:compile`
    fails in this Node 18 devcontainer due to an OpenSSL 3/Webpack 4
    digest-algorithm incompatibility, independent of Ruby/Rails version.
    (The `animal.rb` dead file was since removed in commit `f942b929`,
    unrelated to either upgrade pass — `zeitwerk:check` is clean as of
    Pass 2.)

**Pass 2 — Rails 7.0.10 → 7.1.6 (Ruby stays 3.0.5): DONE**
(commit `a67837b6` on `upgrade/rails-7.1`)

- `bundle update rails --conservative` moved only the Rails-family gems
  and their standard transitive dependencies (`rack-session`, `rackup`,
  `irb`, `psych`, `tsort`, etc.). `clearance` stayed at 2.7.1 (as
  expected — versions ≥ 2.9.0 require Ruby ≥ 3.1.6), and `kt-paperclip`,
  `audited`, `webpacker`, `puma`, `unicorn`, `delayed_job`/
  `delayed_job_active_record` were all unaffected. No forced
  companion-gem bump was needed this pass.
- Ran `bin/rails app:update` and declined every offered file change.
  Each conflicting file (`config/application.rb`, `config/environments/
  *.rb`, `config/initializers/{assets,content_security_policy,
  filter_parameter_logging,inflections,permissions_policy}.rb`, the
  binstubs) mixed trivial quote-style/comment-wording noise with either
  real app customizations that must be preserved (Paperclip/S3 config,
  mail settings, rack-cache, the `lib` eager-load path, `Clearance::
  BackDoor`/`RackSessionAccess::Middleware` in `test.rb`) or new-default
  opt-ins that belong in the generated `new_framework_defaults_7_1.rb`
  rather than being force-applied. Accepted only that file (fully
  commented out, same treatment as `_7_0.rb`) and the auto-copied,
  guarded (`return unless table_exists?`) ActiveStorage migration
  (`RemoveNotNullOnActiveStorageBlobsChecksum`), matching the pattern of
  prior auto-copied ActiveStorage migrations already in this app's
  history (this app has no `active_storage_blobs` table, so it's a
  no-op).
  - Caution for future passes: this devcontainer's local (untracked)
    `.bundle/config` had `BUNDLE_BIN: "bin"` set, which makes any
    `bundle install`/`update` regenerate Bundler-style binstubs for
    *every* gem in the bundle — clobbering this app's custom `bin/rails`
    (which needs its Rails-generated `APP_PATH`/`require_relative
    "../config/boot"` form, not Bundler's generic stub) and littering
    `bin/` with dozens of unrelated stubs (`bin/puma`, `bin/rubocop`,
    etc.). Not a repo-tracked setting, so it won't reproduce elsewhere,
    but reverted the clobbered/created files and ran
    `bundle config unset bin` this session to stop it recurring.
- Required one app-code fix, found via the full RSpec suite (36
  failures) and confirmed absent on the pre-upgrade commit: Rails 7.1
  changed `config.i18n.raise_on_missing_translations = true` (set in
  this app's `development.rb`/`test.rb`) to also globally override
  `I18n.exception_handler`, so bare `I18n.t()` calls now raise on any
  missing key — not just the view/controller `t`/`translate` helpers as
  in 7.0 (`activesupport-7.1.6/lib/active_support/i18n_railtie.rb`'s
  `setup_raise_on_missing_translations_config`, replacing 7.0's
  `forward_raise_on_missing_translations_config` which only patched the
  ActionView/ActionController helpers). `app/helpers/
  application_helper.rb`'s `title` method calls `I18n.t` directly for a
  per-action title key that doesn't exist for most actions (only
  `new`/`edit`/`index` are defined per controller in `config/locales/
  en.yml`). Fixed with `default: nil`, which sidesteps the exception
  path entirely — a per-call `raise: false` option does **not** work
  here, since I18n only consults it on the raise/throw path; once
  neither is set it falls through to `config.exception_handler`, which
  is the handler Rails 7.1 globally overrides. As a side effect, this
  also makes the pre-existing (previously dead, since `I18n.t` never
  actually returned `nil` before) `@title.nil?` fallback to
  `base_title` finally work, instead of baking a "translation missing:
  ..." string into the page `<title>` as Rails 7.0 silently did.
- Full RSpec suite: 742 examples, 0 failures, 12 pending — matches the
  fresh Pass-2 baseline exactly, across two consecutive runs with
  different random seeds. `bin/rails zeitwerk:check` passes cleanly.
  Manually booted `bin/rails server` and confirmed both the Sprockets
  asset pipeline and the Webpacker `javascript_pack_tag` resolve with
  200s on the same page.
- Explicitly deferred/out of scope for this pass (same list as Pass 1,
  still true, not yet addressed): Webpacker replacement, kt-paperclip →
  ActiveStorage migration, Unicorn/Puma reconciliation, the Ruby version
  bump, the `config.load_defaults` catch-up, and the other pre-existing
  papercuts noted above (`.rubocop.yml` stale target version, CI's
  Node 16 pin, `webpacker:compile`'s Node 18/OpenSSL 3 incompatibility
  in this devcontainer).

**Next pass: not yet decided.** Candidates, in roughly the order they'd
naturally come up: Rails 7.1 → 7.2 (note: 7.2 raises Rails' minimum Ruby
floor, so it may force the Ruby version bump to happen in the same pass
rather than staying single-purpose like Passes 1 and 2), or the deferred
`config.load_defaults` catch-up, or the Ruby version bump on its own.
Decide based on what's most pressing (security support windows, blocking
a needed feature, etc.) when picking up the next pass — don't assume the
order above is a commitment.
