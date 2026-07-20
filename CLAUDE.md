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

**Pass 3 — Ruby 3.0.5 → 3.3.12, plus clearance 2.7.1 → 2.11.0 (Rails
stays 7.1.6): DONE**
(commits `a2a4e229`, `c404d69e` on `upgrade/ruby-3.3.12`)

- Ruby is pinned via six version-bearing settings across five files; all
  six updated in commit 1: `Gemfile`, `.ruby-version`,
  `.devcontainer/Dockerfile` (`ARG RUBY_VERSION`),
  `.devcontainer/compose.yaml` (**both** the build arg *and* the
  `bundle_cache` volume path, which is version-specific — easy to
  update only one and silently point the gem cache at a nonexistent
  path), and `config/deploy.rb`'s Capistrano `rbenv_ruby`.
  Did **not** touch `.rubocop.yml`'s stale `TargetRubyVersion: 2.6`,
  consistent with both prior passes deferring it.
- Verified locally by installing 3.3.12 via `rbenv` alongside the
  existing 3.0.5 (this devcontainer has `ruby-build`'s `3.3.12`
  definition and usable `rbenv`), reinstalling the pinned bundler
  (2.4.22) under it, then `bundle install`: only the `Gemfile.lock`
  `RUBY VERSION` line changed, no gem versions moved, all
  native-extension gems (nokogiri, ffi, sassc, puma, unicorn, pg,
  bcrypt, mini_racer, **argon2**) recompiled cleanly against the new
  ABI.
- Two runtime-only breaks surfaced via the full RSpec suite (confirmed
  absent on pre-upgrade 3.0.5, fixed as minimal required companions to
  the Ruby bump, not opportunistic cleanup):
  - `net/ftp`, required directly by three sync rake tasks
    (`adoptapet_sync.rake`, `petfinder_sync.rake`,
    `shelterluv_exp.rake`), was a Ruby 3.0 **default gem** (always on
    the load path) but was demoted to a **bundled gem** in Ruby 3.1+ —
    still ships with the Ruby install, but Bundler no longer auto-loads
    it without an explicit Gemfile entry. Added `gem 'net-ftp'`.
  - `Dir.exists?`/`File.exists?` (deprecated since Ruby 2.7) were
    removed outright in Ruby 3.2. Fixed the five call sites:
    `lib/tasks/adoptapet_sync.rake` (×2), `lib/tasks/
    petfinder_sync.rake`, `lib/tasks/shelterluv_exp.rake`, and
    `config/deploy/shared/unicorn.rb.erb` (the Capistrano unicorn
    template, which runs under the same rbenv Ruby on the deploy host,
    so it shares the same floor even though it's not exercised by
    RSpec).
- Commit 2: `clearance` was stuck at 2.7.1 because ≥2.9.0 requires Ruby
  ≥3.1.6. With 3.3.12 active, `bundle update clearance --conservative`
  moved only `clearance` and its own declared deps (`argon2` 2.3.0 →
  2.3.3, `bcrypt` 3.1.20 → 3.1.22, `ffi-compiler` 1.3.2 → 1.4.2); no
  Rails-family gem moved.
  - **Deviated from the original plan**, which expected leaving `gem
    'clearance'` unconstrained and landing on the resolver's choice
    (2.12.0). An unconstrained update *does* resolve cleanly to 2.12.0
    — but that version's `passwords_controller`/`users_controller`
    render `status: :unprocessable_content`, a Rails 7.1-era HTTP status
    symbol that only `Rack::Utils::SYMBOL_TO_STATUS_CODE` in Rack ≥3.0
    recognizes. This app is still on Rack 2.2.10, and even the latest
    2.2.x patch (2.2.23, checked directly against its `lib/rack/
    utils.rb`) never added that symbol — confirmed via the full RSpec
    suite (one failure, `spec/features/clearance/
    visitor_updates_password_spec.rb`), not static analysis, matching
    this repo's standing "clean `bundle install` isn't proof of runtime
    compatibility" rule. Bumping Rack to 3.x to accommodate it would be
    its own real modernization pass (Unicorn/Puma compatibility, other
    middleware) — out of scope here. Pinned `gem 'clearance', '~>
    2.11.0'` instead: the last release before that change, still clears
    the ≥3.1.6 Ruby floor, and is still a substantial real unblock
    (2.7.1 → 2.11.0).
- Full RSpec suite: 742 examples, 0 failures, 12 pending after each
  commit, stable across multiple random seeds — matches the Pass 2
  baseline exactly. `bin/rails zeitwerk:check` clean after each commit.
  Manually booted `bin/rails server` after each commit and confirmed
  `/` (Sprockets + Webpacker `javascript_pack_tag`) and, after commit 2,
  clearance's `/sign_in` route (`SessionsController#new`) all resolve
  with 200s.
- Dockerfile/compose.yaml/deploy.rb changes take effect only on the
  next container rebuild / Capistrano deploy to a host with 3.3.12
  already installed via rbenv — not exercised by this session's
  verification, flagged in the PR description as a pre-deploy
  prerequisite.
- **Post-merge devcontainer rebuild caught a real bug in the above**:
  `.devcontainer/compose.yaml`'s `bundle_cache` named volume was never
  version-qualified, only its mount path was. Docker only auto-populates
  a named volume from the image's build-time content the *first* time
  that volume is created empty; the pre-existing `bundle_cache` volume
  (populated with Ruby 3.0.5's gems from before this pass) got
  remounted as-is onto the new `.../3.3.12/lib/ruby/gems` path, hiding
  the `bundler` gem the Dockerfile installs into the image at that same
  path — surfacing as `postCreateCommand`'s `bundle install` failing
  with `Gem::GemNotFoundException: can't find gem bundler`. Fixed by
  renaming the volume itself to `bundle_cache_3_3_12` (both the service
  mount and the top-level `volumes:` entry), so each Ruby version gets
  its own cache volume and this can't recur on the next Ruby bump. The
  old orphaned `bundle_cache` volume is harmless to leave in place
  (just unused disk) or can be pruned with `docker volume rm`.
- Explicitly deferred/out of scope for this pass (same list as Passes 1
  and 2, still true, not yet addressed): Webpacker replacement,
  kt-paperclip → ActiveStorage migration, Unicorn/Puma reconciliation,
  the `config.load_defaults` catch-up, `.rubocop.yml`'s stale target
  version, CI's Node 16 pin, `webpacker:compile`'s Node 18/OpenSSL 3
  incompatibility in this devcontainer.
- New candidate surfaced by this pass, not yet scheduled: **Rack 2 → 3**
  — needed to eventually let `clearance` move past 2.11.0, and its own
  independent compatibility question for Unicorn/Puma.

**Pass 4 — Rails 7.1.6 → 7.2.3.1 (Ruby stays 3.3.12,
`config.load_defaults` stays frozen at 5.0): DONE**
(commits `213842ed`, `40bd33db`, `c42106d7` on `upgrade/rails-7.2`)

- Pre-flight audit (two Explore passes over Gemfile/Gemfile.lock and all
  config/CI files) found no gem version cap blocking resolution against
  Rails 7.2 — the only resolution blocker was the Gemfile's own `gem
  'rails', '~> 7.1.6'` pin, making this structurally simpler than Pass 1
  or 3 (no *anticipated* forced companion bump, unlike what actually
  happened — see below).
- Commit 1: bumped the Gemfile pin to `~> 7.2.0`, ran `bundle update
  rails --conservative`. Moved only the Rails-family gems to 7.2.3.1 plus
  one new transitive dependency (`useragent`, backing 7.2's opt-in
  `allow_browser`, unused by this app). Reviewed the full lockfile diff
  line by line: `kt-paperclip`, `clearance`, `webpacker`, `audited`,
  `puma`, `unicorn`, `delayed_job`/`delayed_job_active_record`,
  `annotate`, `rack`, `rack-cache`, `sprockets`/`sprockets-rails`, and
  (at this point) `rspec-rails` all stayed put.
- Commit 2: ran `bin/rails app:update`, same rule as Pass 2 — decline
  real customizations and trivial noise, accept only inert scaffolding.
  Declined all of `config/application.rb`, `config/environments/*.rb`,
  the same initializer set as Pass 2, and all binstubs. Also discarded
  several newly-offered files that don't fit the accept list and aren't
  needed by this bump: `bin/rubocop` (a new binstub, unrelated to the
  Rails version), and `public/icon.{png,svg}` +
  `public/406-unsupported-browser.html` (Rails' new default
  favicon/`allow_browser` rejection-page scaffolding — this app already
  has its own favicon setup in `app/views/layouts/_favicons.html.erb`
  and doesn't use `allow_browser`). Accepted only
  `config/initializers/new_framework_defaults_7_2.rb` (verified fully
  commented out, zero non-comment/non-blank lines), matching the
  `_7_0.rb`/`_7_1.rb` precedent. No new guarded migration was offered
  this pass.
- Commit 3 (forced, confirmed via `bin/rails zeitwerk:check`, not
  static analysis): `rspec-rails` 6.0.4's Railtie sets
  `config.action_mailer.preview_path=` (singular) in its
  `rspec_rails.action_mailer` initializer. Rails 7.2 removed that
  deprecated singular alias entirely (only `preview_paths=` remains —
  see `actionmailer-7.2.3.1`'s CHANGELOG: "Remove deprecated
  `config.action_mailer.preview_path`."), so every Rails boot under the
  `test`/`development` groups raised `NoMethodError` on
  `ActionMailer::Base`. `rspec-rails` 6.1.5 branches on
  `Rails::VERSION::STRING >= "7.1.0"` to call `preview_paths=` instead,
  fixing it. Bumped the Gemfile pin `~> 6.0.0` → `~> 6.1.0`; `bundle
  update rspec-rails --conservative` moved only `rspec-rails` and its
  own declared deps (`rspec-core`, `rspec-mocks`) — no Rails-family gem
  moved. This is the exact "newly-surfaced note" Pass 3 flagged
  (rspec-rails 6.0.x's weaker 7.1/7.2-era support) — that note assumed
  the suite wasn't actually blocked without a bump; it was.
- Full RSpec suite: 742 examples, 0 failures, 12 pending across two
  random seeds, both before Commit 3 confirmed the break and after
  confirmed the fix — matches the Pass 3 baseline exactly. `bin/rails
  zeitwerk:check` clean. Manually booted `bin/rails server` and
  confirmed `/` (200) and `/sign_in` (200); confirmed both the Sprockets
  asset (`/assets/application_bs41.debug-*.js`, 200) and the Webpacker
  pack (`/packs/js/application-*.js`, 200) actually resolve, not just
  appear in the HTML.
- Explicitly deferred/out of scope for this pass (same list as Passes 1
  through 3, still true, not yet addressed): Webpacker replacement,
  kt-paperclip → ActiveStorage migration, Unicorn/Puma reconciliation,
  the `config.load_defaults` catch-up, Rack 2 → 3, `.rubocop.yml`'s
  stale target version, CI's Node 16 pin, `webpacker:compile`'s Node
  18/OpenSSL 3 incompatibility in this devcontainer.
- New notes surfaced by this pass, not yet actionable:
  - `delayed_job_active_record` and `annotate` both cap `activerecord <
    8.0` — irrelevant now, will block a future Rails 8 pass.
  - `rspec-rails` is now pinned `~> 6.1.0` (was `~> 6.0.0`, forced
    above); no upper cap blocks going further, but bumping past 6.1.x is
    out of scope unless a future pass is actually blocked without it.

**Pass 5 — Rack 2.2.10 → 3.2.6 (Rails stays 7.2.3.1, Ruby stays
3.3.12): DONE**
(commit on `upgrade/rack-3`)

- Security-motivated: Rack 2.x has an accumulated CVE history
  (multipart temp-file leakage, header-parsing ReDoS, Range-header DoS
  across various 2.2.x releases); Rack 3.x is where active security
  maintenance is concentrated. Requested by the user to start a new
  security-focused modernization phase.
- `rack` is not directly pinned in the `Gemfile` — resolves
  transitively, pulled in by `actionpack`. Two hard blockers forced
  companion bumps, both confirmed in the pre-pass lockfile: `rack-session
  (1.0.2)` and `rackup (1.0.1)` each capped `rack (< 3)`.
  `bundle update rack rack-session rackup --conservative` resolved
  cleanly: `rack` 2.2.10 → 3.2.6, `rack-session` 1.0.2 → 2.1.2 (gained a
  `base64 (>= 0.1.0)` dependency edge — `base64` itself was already in
  the lockfile, unmoved), `rackup` 1.0.1 → 2.3.1 (dropped its `webrick`
  dependency; `webrick` 1.8.2 stayed in the lockfile regardless, pulled
  in independently by `ferrum`/Cuprite). No other gem moved — reviewed
  the full lockfile diff line by line per the standing rule.
  - Ceiling: `actionpack (7.2.3.1)` requires `rack (>= 2.2.4, < 3.3)`,
    so this pass tops out in the 3.0–3.2.x line, not the latest Rack
    release — expected and fine.
  - `unicorn ~> 6.1` and `puma` (resolved 6.5.0) already supported Rack
    3 (since unicorn 6.1.0 / puma 6.0) — no version bump needed for
    either app server.
  - `clearance (2.11.0)`, pinned `~> 2.11.0` since Pass 3, uses
    `status: :unprocessable_entity` throughout, not
    `:unprocessable_content` — so the Rack-3-only
    `SYMBOL_TO_STATUS_CODE` issue that blocked clearance 2.12.0 in
    Pass 3 didn't apply here. No forced clearance bump.
  - Did **not** add an explicit `gem 'rack', ...` line to the
    `Gemfile` — it wasn't pinned before this pass and there's no reason
    introduced by this pass to start pinning it.
- No forced companion-gem code fix was needed this pass (unlike Pass 1,
  3, and 4's Commit 3) — the only diff is the `Gemfile.lock` bump.
- Full RSpec suite: 742 examples, 0 failures, 12 pending, matching the
  fresh pre-pass baseline exactly across two runs with different random
  seeds. Individually re-ran `spec/features/event_management_spec.rb`
  (the `Clearance::BackDoor` `as: admin` regression target, since
  `config/environments/test.rb` wires up both `Clearance::BackDoor` and
  `RackSessionAccess::Middleware`) and all of `spec/features/clearance/`
  (sign-in, sign-out, password reset/update) individually — both clean.
  `bin/rails zeitwerk:check` clean. Manually booted `bin/rails server`
  and confirmed `/` and `/sign_in` returned real 200s, including the
  actual Sprockets and Webpacker asset URLs (not just their presence in
  the HTML). Confirmed no `rack-mini-profiler` boot errors in the dev
  log. Attempted a `RAILS_ENV=production bin/rails runner` boot smoke
  check per the plan; it failed on `ActiveRecord::AdapterNotSpecified`
  because this devcontainer has no `production` database configured —
  a pre-existing environment limitation unrelated to Rack (dev/test
  only), not exercised further.
- Explicitly deferred/out of scope for this pass (same list as Passes 1
  through 4, still true, not yet addressed): Webpacker replacement,
  kt-paperclip → ActiveStorage migration, Unicorn/Puma reconciliation
  (both already independently supported Rack 3, so "already touching
  Rack" wasn't a reason to fold it in), the `config.load_defaults`
  catch-up, Rails 7.2 → 8.0, `.rubocop.yml`'s stale target version, CI's
  Node 16 pin, `webpacker:compile`'s Node 18/OpenSSL 3 incompatibility
  in this devcontainer. Also out of scope, called out explicitly as the
  natural next pass rather than folded in: CI security scanning
  (brakeman, bundler-audit, extending `.github/dependabot.yml` beyond
  `bundler`) — a real, cheap-to-close gap, but unrelated to a version
  bump.

**Next pass: not yet decided**, but CI security scanning (brakeman for
SAST, bundler-audit for known-CVE gem scanning, a `github-actions`
entry in `.github/dependabot.yml`) is the leading candidate — cheap,
decouples entirely from version-bump risk, and continues the user's
stated security focus from Pass 5. Other candidates, roughly in order:
Rails 7.2 → 8.0 (will need to resolve the `delayed_job_active_record`/
`annotate` `activerecord < 8.0` caps first, flagged since Pass 4), gem
staleness cleanup (nokogiri, stripe, mini_racer/libv8-node, honeybadger
— no known active CVEs currently, so lower urgency), Unicorn/Puma
reconciliation, and the `config.load_defaults` catch-up (both
long-deferred, not security-driven, lowest urgency of the group).
Decide based on what's most pressing when picking up the next pass —
don't assume the order above is a commitment.
