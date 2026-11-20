# RescueRails (Operation Paws for Homes)

## App overview

RescueRails is the web app for Operation Paws for Homes, a dog/cat rescue.
It has a public site (adoption listings, applications, donations) and an
internal admin/staff system (`app/controllers/dogs/manager`,
`app/controllers/cats/manager`, dashboards) for managing dogs, cats,
adopters, volunteers, and staff. No admin-engine gem (ActiveAdmin/RailsAdmin)
is used — the admin UI is hand-built.

The app is ~13 years old (`db/migrate` goes back to 2011) and had never, in
its history, gone past Rails 6.1 until the upgrade passes logged in
"Upgrade roadmap" below.

**Stack:**
- Ruby 3.3.12, Rails 8.0.5.2 (as of Pass 14 below; `config.load_defaults`
  is still frozen at 5.0)
- PostgreSQL, `pg` gem
- Auth: **Clearance** (not Devise) — see `config/initializers/clearance.rb`
- File uploads: **kt-paperclip** (not ActiveStorage, though activestorage
  ships with Rails regardless)
- Background jobs: **DelayedJob** (not Sidekiq)
- Asset pipeline: Sprockets, with JS bundled via **jsbundling-rails +
  esbuild** (Webpacker replaced in Pass 9) plugging into the same
  Sprockets manifest/precompile flow — one pipeline, not two
- App server: **Puma** everywhere (dev/test/staging/production — clustered,
  3 workers x 5 threads in deployed envs; Unicorn removed in Pass 11)
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
- **This repo is public (open source) — never write infrastructure or
  secret information into it, including this file's upgrade log.** No
  host names/IPs, server filesystem paths, socket/unit file locations,
  provisioning-repo locations, credentials or key material (not even
  partial or "redacted" values), and no output pasted from production
  hosts. Describe such things generically ("the production hosts", "the
  Puma unit") and keep specifics out of commits, PR text and docs. Deploy
  target hosts live in a gitignored file (`config/deploy/
  production_hosts.rb`, template alongside as `.sample`) — see README.md
  "Deploying".
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
  - Ceiling: `actionpack (7.2.3.1)` requires `rack (>= 2.2.4, < 3.3)`.
    This permits the resolved `3.2.6` and excludes only a future
    `3.3.x` line, which hadn't shipped as of this pass — `3.2.6` is
    itself the latest Rack release published to date.
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

**Pass 6 — bundler-audit: known-CVE gem scan + remediation (no Rails/Ruby
version change): DONE**
(commits `882e34bb`, `df1773ad`, `da2e3c1d` on `upgrade/bundler-audit`)

- Narrowed scope of the "CI security scanning" candidate flagged after
  Pass 5: gems only (bundler-audit), not brakeman/SAST — a separate
  future pass — and no permanent CI gate yet, by explicit user choice.
  Motivated by the same concern that shaped this whole log: a model's
  training-data knowledge of CVEs goes stale, and this pass's date
  (2026-07-20) is 6+ months past this session's knowledge cutoff, so
  the actual `ruby-advisory-db` (live-fetched, last updated 2026-07-18)
  was the only trustworthy source — not a manual read of the lockfile.
- Commit 1: added `bundler-audit` (0.9.3) to the `Gemfile`'s
  `:development` group, alongside `rubocop` and friends — same
  reasoning as those: a dev-only tool kept in the repo for repeat use,
  not wired into CI this pass. Lockfile diff was just `bundler-audit` +
  its own already-satisfied deps (`bundler`, `thor`).
- `bundle exec bundle-audit update && bundle-audit check` against the
  Pass-5 lockfile found **84 advisories across 15 gems** — far more
  than expected from a stale mental model of this lockfile, which is
  exactly the point of running the real tool instead of guessing:
  `nokogiri` alone accounted for 48 (libxml2 UAF/DoS advisories,
  1.17.2 → needed 1.19.4), plus `net-imap`, `websocket-driver`,
  `crass`, `faraday`, `concurrent-ruby`, `yard`, `uri`, `puma`, `thor`,
  `rails-html-sanitizer`, `loofah`, `addressable`, `aws-sdk-s3`, and
  `bootstrap`.
- Commit 2: remediated the 14 gems fixable via a straight `bundle
  update <gems...> --conservative` with no Gemfile pin changes —
  `nokogiri`, `net-imap`, `websocket-driver`, `crass`, `faraday`,
  `concurrent-ruby`, `yard`, `uri`, `puma`, `thor`,
  `rails-html-sanitizer`, `loofah`, `addressable`, `aws-sdk-s3`. Found
  one forced companion via the standing "clean resolve isn't proof"
  pattern: `--conservative` alone left `aws-sdk-s3` at 1.177.0, short of
  the required 1.208.0, because its fix needs `aws-sdk-core >= 3.234.0`
  and conservative mode won't bump an unlisted gem — adding
  `aws-sdk-core`/`aws-sdk-kms` to the same update call let it reach
  1.228.0. `puma` (6.5.0 → 8.0.2, a major-version jump) is safe here
  specifically because this app only runs Puma in dev/test — production
  uses `unicorn` (per the Pass-1-era stack note), so it has no
  production blast radius. Full lockfile diff reviewed line by line:
  only these gems and their own declared deps moved.
- Commit 3 (the one real surprise this pass): `bootstrap`'s Gemfile pin
  (`~> 4.3.1`) only ever allowed the exact vulnerable version
  (CVE-2024-6531, XSS) — the fix needs `> 4.6.2`. Rather than jump to
  Bootstrap 5 (breaking: drops jQuery, renames every `data-*` attribute
  to `data-bs-*`, out of scope for a CVE pass), loosened the pin to
  `>= 4.6.2.1', '< 4.7'` to land on 4.6.2.1, the last 4.x release with
  the fix. Deliberately not `~> 4.6.2` — that pessimistic form only
  bounds the version *above* 4.7, it doesn't exclude the vulnerable
  4.6.2 exact release from being re-resolved below the patched
  4.6.2.1, so the floor is pinned explicitly at the patched version.
  Discovered a real latent fragility doing this: `bootstrap` 4.6.2.1
  dropped its own runtime dependency on `sassc-rails`, and
  `sassc-rails`/`sprockets`/`sprockets-rails`/`tilt` were **never
  declared directly in this app's Gemfile** — they'd only ever been
  present because `bootstrap` pulled `sassc-rails` in transitively.
  Bumping bootstrap alone silently dropped all four from
  `Gemfile.lock`, which would have broken this app's actual Sprockets
  asset pipeline (`app/assets/stylesheets/application_bs41.scss`, the
  same asset referenced in Pass 4's server-boot check) on the next
  clean `bundle install` in CI/production. Confirmed by reproducing the
  drop in isolation before fixing it. Fixed by adding `gem
  'sassc-rails'` directly to the Gemfile so this app's real dependency
  is explicit — not a bootstrap-version-bump workaround, a correction
  of a pre-existing undeclared dependency the bump happened to expose.
- Full RSpec suite: 742 examples, 0 failures, 12 pending, stable across
  three different random seeds (two before finalizing commit
  boundaries, one re-run against the exact final three-commit state) —
  matches the Pass 5 baseline exactly, captured fresh via `git stash`
  immediately before this pass's first change. `bin/rails
  zeitwerk:check` clean. Manually booted `bin/rails server` (on a
  separate port/pidfile from the devcontainer's own already-running dev
  server, left untouched) and confirmed `/` and `/sign_in` both
  resolved 200s with real Sprockets-compiled asset output, not just
  presence in the HTML.
- One anomaly investigated and ruled pre-existing, per the standing
  "check whether it reproduces on the pre-upgrade code" rule: the
  manual server-boot check logged a `SystemStackError` inside a
  background `newrelic_rpm` agent thread
  (`NewRelic::Agent::StatsEngine::StatsHash#record`), not on the
  request thread — both smoke-tested pages still returned real 200s.
  Reproduced identically on the unmodified pre-pass code (confirmed via
  `git stash`, re-running the same server-boot check, same stack
  trace). This app has no `config/newrelic.yml`, so the agent runs on
  bare defaults with (presumably) no license key in this devcontainer —
  unrelated to any gem this pass touched, not investigated further
  here, but worth a note if a future pass ever touches
  `newrelic_rpm`/`concurrent-ruby` again.
- Post-remediation `bundle-audit check`: 0 vulnerabilities. No
  `.bundler-audit.yml` ignores were needed — every advisory found had a
  real, in-scope fix landed this pass.
- Explicitly deferred/out of scope for this pass: brakeman/SAST (own
  future pass), wiring `bundle-audit` into `.github/workflows/main.yml`
  as a CI gate (by user choice this pass — tool is available locally/in
  dev only), `.github/dependabot.yml`'s `github-actions` ecosystem
  entry (a different concern than gem CVEs), Ruby-language CVEs (not a
  gem, out of this pass's explicit "known-CVE gems" framing), and the
  full standing list from Passes 1–5: Webpacker replacement,
  kt-paperclip → ActiveStorage, Unicorn/Puma reconciliation,
  `config.load_defaults` catch-up, Rails 7.2 → 8.0, `.rubocop.yml`'s
  stale target version, CI's Node 16 pin, `webpacker:compile`'s Node
  18/OpenSSL 3 devcontainer incompatibility.

**Pass 7 — Production incident: Unicorn 6.1.0 crashing on Rack 3
multi-value `Set-Cookie` headers, breaking all logins (no Rails/Ruby
version change): DONE**

- User-reported symptom: production sign-in silently stopped working,
  with **no error in `production.log`**. Per this file's own "stop if
  you can't find it" instruction, looked for the production
  provisioning (ansible) playbooks to review NGINX/Unicorn config — they
  aren't available in this environment, so no ansible/NGINX review was
  possible or, as it turned out, necessary.
- Root cause, confirmed by reading the actual installed gem source (not
  guessed from version numbers) and reproduced locally: Pass 5's Rack
  2.2.10 → 3.2.6 bump changed how a **second** `Set-Cookie` header is
  represented — `Rack::Utils.set_cookie_header!` in `rack-3.2.6/lib/
  rack/utils.rb` stores it as an **Array** of strings, where Rack 2
  always used a single `"\n"`-joined String. `unicorn` is pinned `~>
  6.1` and resolves to `6.1.0` — confirmed via `gem list unicorn
  --remote --all` to still be **the latest gem release available**, no
  6.2+ exists. Its `Unicorn::HttpResponse#http_response_write`
  (`unicorn-6.1.0/lib/unicorn/http_response.rb:43`) only ever checked
  `value =~ /\n/`, a String-only check left over from the Rack 2 world,
  and raises `NoMethodError: undefined method '=~' for an instance of
  Array` on any response carrying 2+ `Set-Cookie` headers. This is a
  known, still-unreleased upstream gap — the real fix exists merged but
  unshipped in any unicorn gem, at
  [Shopify/unicorn#5](https://github.com/Shopify/unicorn/pull/5).
  - Pass 5's claim that "unicorn ~> 6.1 ... already supported Rack 3
    (since unicorn 6.1.0)" was correct for general request handling but
    missed this specific multi-`Set-Cookie` code path — Pass 5's manual
    boot checks only hit plain `GET /` and `GET /sign_in`, never an
    actual sign-in `POST`, so the crash never surfaced until real
    production login traffic hit it.
  - Because Unicorn's response-writer builds the entire header buffer
    before writing anything to the socket, a mid-loop crash here means
    **nothing** is written — Unicorn's own rescue path sends a bare
    fallback 500 with no headers at all. The client never receives any
    `Set-Cookie`, so sign-in appears to succeed application-side (no
    Rails exception, nothing in `production.log`) while the browser
    never actually gets a session. The crash itself is logged only to
    Unicorn's own error log, not Rails'.
  - Confirmed this is unrelated to the `clearance` 2.7.1 → 2.11.0 bump
    (Pass 3): nothing in that version range's `CHANGELOG.md` or `lib/
    clearance/session.rb` touches cookie/session-writing code. Also
    unrelated to NGINX: the crash happens entirely inside the Unicorn
    worker serializing its own response, before NGINX ever sees
    anything but a broken connection.
  - Locally reproduced (per this file's standing "confirm before
    assuming" rule) by booting real `unicorn` against this app
    (`bundle exec unicorn` itself fails in this devcontainer the same
    way `bundle exec rails`/`bundle exec rspec` do — worked around with
    `ruby -e 'require "bundler/setup"; load Gem.bin_path("unicorn",
    "unicorn")'`) and driving a real sign-in `POST` through it: got the
    identical stack trace, line number and all. Rack's own header hash
    for a real `GET /sign_in` in this devcontainer confirmed the
    `Array` shape directly (`["_RescueRails_session=...",
    "__profilin=p%3Dt;..."]` — the second cookie here is
    `rack-mini-profiler`'s dev-only cookie; in production it's
    Clearance's `remember_token` cookie, set alongside the session
    cookie on every sign-in).
- Fix: `config/initializers/unicorn_rack3_cookie_fix.rb`, guarded by
  `if defined?(Unicorn::HttpResponse)` (a no-op everywhere Unicorn isn't
  loaded — dev/test Puma, console, rake tasks). Uses
  `Unicorn::HttpResponse.prepend` to reproduce the unreleased
  Shopify/unicorn#5 fix verbatim: same `http_response_write` body, with
  an added `when Array` branch ahead of the existing `\n`-splitting
  branch. Chosen over switching production to Puma (bigger change,
  needs the unreachable ansible repo to update Capistrano/systemd) or
  rolling back Rack 3 (would undo Pass 5's CVE remediation) — a
  deliberate, minimal, targeted patch for an unreleased upstream gap,
  same pattern as Pass 1's kt-paperclip and Pass 4's rspec-rails forced
  fixes.
- Verified by repeating the exact same local repro (real `unicorn`
  process, real sign-in `POST`) after adding the fix: no crash, the
  response carries all of `remember_token`, `_RescueRails_session`, and
  `__profilin` as three intact `Set-Cookie` headers, and a follow-up
  request using the resulting cookie jar shows the user actually signed
  in ("Sign out" link present). Full RSpec suite: 742 examples, 0
  failures, 12 pending — matches the Pass 6 baseline exactly (expected:
  these specs run under Puma/rack-test and don't exercise Unicorn at
  all, so this is a regression check, not a fix verification).
  `bin/rails zeitwerk:check` clean.
- Explicitly out of reach this pass: actually deploying this fix and
  restarting/rolling the production Unicorn workers — this session has
  no access to the provisioning repo or any production host, so
  that remains a manual follow-up for the user.
- Sharpens the existing "Unicorn/Puma reconciliation" roadmap item from
  a version-gap footnote into a confirmed-broken-in-production gap:
  Unicorn's Rack 3 support has a real, unfixed hole with no upstream
  gem release in sight, while Puma already handles this correctly and
  is already running in dev/test. Bumps that reconciliation up the
  priority list below.

**Pass 8 — Unicorn → Puma production migration (code only; host cutover
is a manual follow-up): DONE**
(commits `5d67b109`, `44949fbb`, `088f9e5a`, `5969e5fc` on
`upgrade/puma-production`)

- Directly answers the priority Pass 7 raised: Puma becomes the
  actively-deployed production app server, wired all the way through
  Capistrano/systemd/nginx/monit. Unicorn is deliberately **not**
  deleted — kept installed-but-inactive as a same-day rollback path,
  per explicit user decision — so a future pass removes it once
  production has run stably on Puma for a while.
- Topology: **clustered, 3 workers x 5 threads**, matching Unicorn's
  existing 3-worker capacity exactly (chosen over a single-process
  multi-threaded model specifically because this codebase already has
  years of proven fork-safety under Unicorn's `preload_app true` +
  `before_fork`/`after_fork` AR reconnect — Puma's `preload_app!` +
  `before_fork`/`before_worker_boot` is a near-literal translation of
  the same pattern, not a novel concurrency model for this app).
  `database.yml`'s hardcoded `pool: 20` already covers 3×5=15
  connections without changes.
- Commit 1: new `config/deploy/shared/puma.rb.erb` (Capistrano-rendered,
  following the exact precedent of `unicorn.rb.erb` — `config/unicorn.rb`
  has never been a checked-in file, so neither is a production
  `config/puma.rb`; the dev/test static file only gained an explanatory
  comment) and `config/systemd/puma.service.erb`. Two signal choices
  verified against Puma's actual semantics rather than copied from
  Unicorn by analogy: `ExecReload` sends `USR2` (Puma's full hot-restart
  re-exec, needed because `USR1`'s phased restart doesn't pick up a new
  `Gemfile.lock` from a fresh Capistrano release) and `KillSignal =
  SIGTERM` — **not** `SIGQUIT` copied from Unicorn's unit, since Puma's
  signal polarity is the reverse of Unicorn's (Unicorn: `QUIT` graceful,
  `TERM` fast; Puma: `TERM` graceful, `QUIT` fast). Copying `SIGQUIT`
  verbatim would have silently turned every deploy/stop into a hard
  connection drop. Also moved the `puma` gem out of the dev/test-only
  Gemfile group to top-level, pinned `~> 8.0` (resolved version, 8.0.2,
  didn't move) — it now needs to run everywhere, not just dev/test.
  `unicorn` stays exactly where it is in `group :production`, since
  this repo's `capistrano-bundler` default (`bundle_without:
  development:test`, never overridden) means anything outside those two
  groups always installs on staging/production — moving Unicorn
  anywhere to mark it "dormant" would make it vanish from the next
  `bundle install` and defeat the whole rollback premise. "Dormant" is
  expressed at the systemd/nginx layer only.
- Commit 2: the actual cutover switch. `config/deploy.rb`'s
  `deploy:restart` hook now drives `systemd:puma:reload-or-restart`
  instead of Unicorn's — deliberately not kept alongside Unicorn's
  hook, since leaving both would spin dormant Unicorn back up on every
  deploy. `Capfile` registers a third `capistrano-systemd-multiservice`
  instance for `puma`, additive to the existing `unicorn`/`delayed_job`
  ones. Verified directly from the installed gem source
  (`capistrano-systemd-multiservice-0.1.0.beta13`) that these are
  **system-scoped** systemd units (installed system-wide, managed via
  `sudo systemctl`), not user-scoped as a first pass at this plan assumed —
  `new_service` defaults `service_type: 'system'`, and `unicorn.service.erb`
  itself declaring `User = deploy`/`Group = deploy` is itself
  system-scoped-only evidence. Unit filenames follow `<application>_<name>`
  (`application` is `RescueRails`), so the new unit is
  `RescueRails_puma.service`. `setup_config.cap` now
  invokes `systemd:puma:setup` alongside (not replacing)
  `systemd:unicorn:setup` — both services end up installed+enabled on
  disk after a deploy, only Puma is actively started/restarted by the
  pipeline. `production.rb`/`staging.rb` gained `puma_worker_count`/
  `puma_min_threads`/`puma_max_threads` (3/5/5) alongside the existing
  `unicorn_worker_count`.
- Commit 3: `nginx.conf.erb`'s upstream/location swapped from Unicorn's
  socket to Puma's as a straight swap, not a
  flag-driven toggle — a boolean would still need a host-side re-render
  to take effect, buying nothing over a plain revert, and a true
  emergency rollback happens by hand-editing the live rendered file
  directly either way. `monit.erb`'s per-worker check loop was dropped
  entirely (nothing to watch under Puma — no manual per-worker PID
  files like Unicorn's `after_fork` hack, and Puma's own
  `worker_shutdown_timeout`/restart handling is exactly why Unicorn
  needed monit's external `kill_worker` mechanism and Puma doesn't).
  The master-process check now watches Puma's pidfile and routes
  start/stop through `systemctl` directly (in-repo, unlike Unicorn's
  init script, which wasn't tracked in this repo). Unicorn's monit check group was removed rather than kept
  alongside — alerting/restarting a service that's intentionally
  stopped would just be noise.
- Commit 4 (found via manual verification, not static analysis):
  `puma.rb.erb`'s `on_worker_boot`/`on_restart` hooks logged deprecation
  warnings under the pinned Puma 8.0.2 — `before_worker_boot`/
  `before_restart` are the current names (confirmed in the installed
  gem's `lib/puma/dsl.rb`), same behavior. Fixed before this ever became
  a real production concern, per the standing "verify before trusting"
  pattern.
- Full RSpec suite: 742 examples, 0 failures, 12 pending — matches the
  Pass 7 baseline exactly. `bin/rails zeitwerk:check` clean. As this
  file's own conventions predict, the suite is a **regression check
  only** — it runs via rack-test and never boots a real app-server
  socket, exactly the blind spot that let Pass 7's incident through
  undetected. The verification that actually mattered was manual: hand-
  rendered `puma.rb.erb`'s `fetch()` values into a scratch config
  (3 workers x 5 threads, `preload_app!`, a throwaway local Unix
  socket) and booted real Puma against the real app, the same
  `bundle exec`-workaround pattern Pass 7 used
  (`ruby -e 'require "bundler/setup"; load Gem.bin_path(...)'` — though
  for signal-restart testing this had to be swapped for invoking the
  resolved `puma` executable path directly, since the `-e`-wrapped form
  broke Puma's `USR2` re-exec with a `NameError` on its own `-C` flag,
  a devcontainer-specific invocation artifact unrelated to the app
  itself). Confirmed: 3 real preloaded workers forked; `GET /` and
  `GET /sign_in` both real 200s over the socket; a real sign-in `POST`
  to `/sessions` returned 3 genuine `Set-Cookie` headers
  (`remember_token`, `_RescueRails_session`, `__profilin`) — the exact
  multi-cookie shape that crashed Unicorn in Pass 7 — followed by an
  authenticated request showing the actual "Sign out" link, closing the
  Pass 7 loop end-to-end; several AR-backed requests spread across all
  3 workers with no stale-connection errors (validates the
  `before_fork`/`before_worker_boot` reconnect hooks); `SIGUSR2` against
  the real executable produced a clean graceful worker shutdown +
  re-exec + socket-inherited reboot with new worker PIDs, and a
  follow-up request still returned 200 (validates `ExecReload`);
  `SIGTERM` produced a clean graceful shutdown with no crash (validates
  `KillSignal`). One pre-existing, unrelated anomaly reproduced during
  this testing exactly as Pass 6 already documented it: a
  `SystemStackError` inside a background `newrelic_rpm` agent thread,
  not the request thread — not investigated further here, already
  understood as pre-existing.
- **Explicitly out of reach this pass, same wall Pass 7 hit**: this
  session has no access to the production/staging hosts or the
  ansible/nginx-provisioning repo, so none of `cap staging deploy:setup_config`, `cap
  staging deploy`, or the production equivalent were run. Required
  manual follow-up, in order: deploy to **staging first**, exercise it
  over real HTTP (not just a local socket) through at least one more
  deploy cycle to prove the `USR2`/monit paths under real repeated
  restarts, *then* deploy to both production hosts. Rollback needs
  **both** stopping the Puma unit and starting the Unicorn unit **and**
  either a hand-edited live `nginx.conf`
  (fastest) or a tracked `git revert` + re-render (auditable) — stopping
  Puma and starting Unicorn alone does not move nginx's traffic back on
  its own, since Unicorn's monit check was removed in this pass and
  its systemd unit is merely installed, not actively managed.
- Flagged at the time as out of scope: `.env.production`/`.env.staging`
  contain live-looking AWS/Mailchimp/Honeybadger/eSignatures/reCAPTCHA
  credentials. **Correction (Pass 12):** this entry originally said they
  were "committed directly in the repo" — they are not. Both are
  gitignored (`.env.*`) and have never appeared in git history; they are
  local-only files. (The tracked `.env` is a separate question — see
  Pass 12.)
- New candidates surfaced by this pass, not yet scheduled: deleting the
  now-dormant Unicorn files (gem, `unicorn.rb.erb`,
  `unicorn.service.erb`, the Rack3 cookie monkeypatch at
  `config/initializers/unicorn_rack3_cookie_fix.rb`) once production has
  run stably on Puma for a while — explicitly deferred, not this pass.

**Pass 9 — Webpacker → jsbundling-rails + esbuild (no Rails/Ruby version
change): DONE**
(commits `d81e58c9`, `b7df5a9b`, `023bed91` on
`upgrade/webpacker-to-jsbundling`)

- Closes the last major item on the "explicitly deferred" list carried
  since Pass 1. Investigation found an unusually small Webpacker
  footprint to migrate: only 2 packs (`application`, `volunteer_app`),
  referenced from exactly 2 view call sites; zero custom webpack config
  (`config/webpack/*.js` were pure passthroughs); no React/Vue/
  TypeScript, just Stimulus 2.0 and one file of plain DOM JS; HMR
  explicitly disabled (`webpacker.yml`'s `hmr: false`) and the non-HMR
  dev server documented as optional; CSS/SCSS was never handled by
  Webpacker at all — 100% Sprockets + `sassc-rails`, untouched by this
  pass.
- Chose jsbundling-rails + esbuild over Shakapacker (keeps the full
  webpack toolchain alive for no benefit here — this app exercises none
  of webpack's extra power) and Vite Ruby (its strengths — HMR, SPA dev
  speed — don't apply; this app uses neither), confirmed with the user
  up front. esbuild has effectively no dependencies of its own, and
  jsbundling-rails plugs into the same Sprockets manifest/precompile
  flow already used for CSS, collapsing the app from two asset
  pipelines to one.
- Commit 1: `Gemfile`/`Gemfile.lock` gem swap only — removed `webpacker
  (~> 5.2, >= 5.2.1)`, added `jsbundling-rails`. Reviewed the lockfile
  diff line by line per the standing rule: only `webpacker` and its own
  declared deps (`rack-proxy`, `semantic_range`) dropped; no
  Rails-family gem moved.
- Commit 2: the actual JS migration.
  - `app/javascript/packs/{application,volunteer_app}.js` flattened to
    `app/javascript/` per jsbundling-rails convention. The Stimulus
    entry point could **not** keep the name `application.js`: Sprockets
    already serves an unrelated `app/assets/javascripts/application.js`
    (the legacy jQuery pipeline, wired through `app/assets/config/
    manifest.js`'s `//= link application.js`), and reusing that name for
    the esbuild output would collide with it. Renamed to `stimulus.js`.
  - A second, less obvious collision was hit and fixed during
    verification (found via an actual `yarn build` run producing a
    suspiciously tiny/empty bundle, not by inspection): the first
    attempt named the entry point `app/javascript/controllers.js`,
    which collides with the sibling `app/javascript/controllers/`
    directory — `import "./controllers"` from within `controllers.js`
    resolves to *itself* (Node/esbuild resolution tries the exact
    `.js` file before the directory's `index.js`), producing a
    circular self-import that silently compiled to an empty IIFE with
    no error. Renamed the entry point to `stimulus.js` a second time
    (this time for the collision-avoidance reason above, not the
    Sprockets one) to sidestep both problems at once.
  - `app/javascript/controllers/index.js` dropped webpack's
    `require.context`-based auto-loader (no esbuild equivalent) for an
    explicit `import`/`register` of the one real controller
    (`hello_controller.js`) — proportionate given there was only ever
    one controller to wire up. Left the `stimulus` npm package at
    `^2.0.0`; upgrading to `@hotwired/stimulus`/`stimulus-rails` for
    manifest generation wasn't needed to unblock this and is deferred,
    not folded in.
  - `package.json`/`yarn.lock`: `@rails/webpacker` and
    `webpack-dev-server` (and their full webpack 4/babel/postcss-loader
    transitive tree) replaced with `esbuild` alone — `yarn.lock` dropped
    from 8371 to 1358 lines, a concrete instance of exactly the kind of
    large, unaudited third-party JS dependency tree the Pass 6
    bundler-audit work was reacting to, just never swept because it
    lives in `yarn.lock` rather than `Gemfile.lock`. `mjml` (the
    Node-side compiler behind `format.mjml` mailer responders —
    unrelated to JS bundling) was left untouched.
  - Deleted now-dead Webpacker generator boilerplate:
    `config/webpacker.yml`, `config/webpack/`, `babel.config.js`,
    `postcss.config.js`/`.postcssrc.yml` (a pre-existing duplicate pair,
    confirmed dead once Webpacker's loader chain is gone),
    `.browserslistrc`, `bin/webpack`, `bin/webpack-dev-server`. Added
    the standard jsbundling-rails `bin/dev` + `Procfile.dev`, replacing
    the old optional `bin/webpack-dev-server` workflow in `README.md`.
  - `app/assets/config/manifest.js` gained `//= link_tree ../builds`;
    `config/application.rb`'s existing extension-based
    `config.assets.precompile` list already covers anything `.js`/`.css`
    at the load path's top level, so no further precompile-list change
    was needed — confirmed via an actual `assets:precompile` run.
  - Views: both `javascript_pack_tag` call sites (main layout,
    volunteer app form) became `javascript_include_tag`. No
    Turbolinks/Turbo in this app, so no `data-turbo-track` attribute
    was needed.
- Commit 3: CI's explicit `bundle exec rails webpacker:compile` step
  became `yarn build`; `config/deploy.rb`'s pre-existing
  `deploy:yarn_install` hook mechanism is unchanged (still needs to run
  before asset precompile, just installs esbuild's toolchain now
  instead of Webpacker's) — only its stale comment was updated;
  `README.md`'s dev-setup section swapped the optional
  `bin/webpack-dev-server` mention for `yarn build --watch`.
- Commit 4 (forced, found only after pushing — not caught locally):
  CI's `yarn install` failed outright, `error esbuild@0.24.2: The
  engine "node" is incompatible with this module. Expected version
  ">=18". Got "16.20.2"`. This session's own pre-flight research had
  actually surfaced the Node 16 (CI) vs. Node 18 (devcontainer)
  mismatch, but wrongly assumed esbuild would run fine on either —
  that assumption was never checked against esbuild's actual declared
  `engines` requirement, and this session's local verification only
  ever ran under the devcontainer's Node 18, so the gap never surfaced
  before push. A real instance of this repo's own standing rule ("a
  clean resolve/local run isn't proof of runtime compatibility")
  applying to the Node toolchain, not just Ruby gems. Fixed by bumping
  `.github/workflows/main.yml`'s `node-version` from `'16'` to `'18'`,
  matching what `.devcontainer/Dockerfile` already used — the minimal
  version of the forced change, not a broader Node-pinning cleanup
  (still no `.nvmrc`/`engines` field added, per the standing
  "minimal required change" rule).
- Full RSpec suite: **743** examples (one more than the 742 recorded in
  every prior pass — pre-existing, unrelated to this migration, not
  investigated further here), 0 failures, 12 pending, both before and
  after this pass's changes — captured as a genuinely fresh baseline via
  `git stash`, not assumed from the historical log. `bin/rails
  zeitwerk:check` clean. `yarn build` runs clean; spot-checked the
  actual output content (not just that files were written) — the
  Stimulus bundle contains the real `Application.start()`/`register`
  calls and `hello_controller`'s class body, and `volunteer_app.js`
  contains its real toggle functions. A `RAILS_ENV=test
  assets:precompile` run (the devcontainer has no `production` database
  configured, the same pre-existing limitation Pass 5/6 hit) produced
  correctly digested output for both new files alongside the existing,
  unrelated `application-*.js`, confirming no collision. Manually booted
  the dev server and confirmed real 200s for `/` and its resolved
  `stimulus.js` asset, and for `volunteer_app.js`'s actual Sprockets
  asset path (fetched directly, since `/volunteer_apps/new` itself
  returned 401 — a pre-existing, unrelated app behavior:
  `volunteer_apps_controller.rb` requires login on all actions, and the
  matching request spec is already marked `xdescribe`/"Temporarily
  skipped"). `hello_controller`'s live DOM behavior couldn't be
  browser-verified — no view actually uses `data-controller="hello"`;
  it was already-disconnected demo boilerplate before this pass, not a
  regression introduced by it.
- Explicitly deferred/out of scope for this pass: upgrading
  `stimulus` past `2.0.0`/adopting `@hotwired/stimulus` +
  `stimulus-rails`, kt-paperclip → ActiveStorage migration, the
  `config.load_defaults` catch-up, Rails 7.2 → 8.0, `.rubocop.yml`'s
  stale target version, wiring `bundle-audit` into CI as a gate,
  brakeman/SAST, and completing the Pass 8 Puma production cutover.
  (CI's Node version, previously on this list in every prior pass, is
  no longer stale — Commit 4 above bumped it to 18, forced by esbuild
  itself rather than deferred as a papercut.)

**Pass 10 — Dependabot incident: erb CVE-2026-41316, blocked by the
pre-existing `< 6` pin (no Rails/Ruby version change): DONE**
(commit `970cf072` on `master`)

- Reactive, same category as Pass 7: triggered by an external report
  (Dependabot's `security_update_not_possible` error for `erb`), not a
  scheduled roadmap item. `erb '< 6'` itself was **not** introduced by
  this pass — it was added in commit `3c25d9c7` (during the Pass 8 Puma
  work, to keep `capistrano-systemd-multiservice` 0.1.0.beta13's legacy
  `ERB.new(str, nil, 2)` call working under `erb >= 6`'s dropped
  positional-args signature) but was never logged here at the time.
  Dependabot's report is what surfaced that gap in this log.
- Confirmed the actual advisory via `bundle-audit` (not just Dependabot's
  summary, per this file's "verify against the real tool" habit from
  Pass 6): **CVE-2026-41316** / GHSA-q339-8rmv-2mhv, High — an ERB
  `@_init` deserialization guard bypass. Fixed releases: `~> 4.0.3.1`,
  `~> 4.0.4.1`, `~> 6.0.1.1`, `>= 6.0.4`. The 5.x branch (this app was
  resolved to `5.1.3`) never got a backported fix at all — Dependabot
  couldn't reach 6.0.1.1+ because of the pre-existing `< 6` pin, and had
  no lower-version fix to offer because it only considers upgrades.
- Fix: downgraded to the patched `4.0.4.1`, the only fixed release
  compatible with staying under `6`. Changed the Gemfile pin to `gem
  'erb', '~> 4.0', '>= 4.0.4.1', '< 6'`. `bundle update erb
  --conservative` moved only `erb` itself (5.1.3 → 4.0.4.1, gaining one
  new dependency edge, `cgi (>= 0.3.3)`, already satisfied by the
  installed `cgi 0.5.2`) — reviewed the full lockfile diff line by
  line, nothing else moved.
- Confirmed the whole reason for the `< 6` pin still holds at 4.0.4.1:
  `bin/rails runner 'ERB.new("<%= 1+1 %>", nil, 2).result'` succeeds
  (deprecation warning, not a hard error — identical behavior to 5.1.3),
  so `capistrano-systemd-multiservice`'s `systemd:*:setup` tasks remain
  unaffected.
- Full RSpec suite: 743 examples, 0 failures, 12 pending, both
  immediately before and after the change — matches the Pass 9 baseline
  exactly. `bin/rails zeitwerk:check` clean. `bundle-audit check`: 0
  vulnerabilities (was 1 — this one — before the fix).
- Explicitly out of scope for this pass: replacing
  `capistrano-systemd-multiservice` itself (the unmaintained beta gem
  that necessitates the `< 6` pin in the first place) — still the real
  long-term fix, but a bigger, unrelated change; revisit if that gem
  ships a fix, or if a future erb CVE has no patched pre-6 release to
  fall back on the way this one did.

**Pass 11 — Remove Unicorn (no Rails/Ruby version change): DONE**
(branch `cleanup/remove-unicorn`)

- Closes the "delete the dormant Unicorn files" candidate from Pass 8.
  Prompted by a production check showing Puma serving traffic while the
  old Unicorn service was still enabled and running idle (it restarted on
  boot). The user disabled it on the production hosts and confirmed the
  site kept working before this pass began.
- Removed: the `unicorn` gem (and its `group :production` block;
  lockfile diff was exactly `unicorn`, `kgio`, `raindrops`),
  `config/deploy/shared/unicorn.rb.erb`, `config/systemd/
  unicorn.service.erb`, `config/initializers/unicorn_rack3_cookie_fix.rb`
  (Pass 7's patch — only ever active when `Unicorn::HttpResponse` was
  loaded), the `unicorn` service in `Capfile`, `config/unicorn.rb` in
  `linked_files`, `unicorn.rb` in `config_files`, the
  `systemd:unicorn:setup` call in `setup_config.cap`, and
  `unicorn_worker_count` in `config/deploy/{production,staging}.rb`.
  Comments in `config/puma.rb`/`puma.rb.erb` that pointed at the
  Unicorn files were reworded. `cap production -T` still loads and lists
  zero unicorn tasks.
- Host cleanup was done by hand by the user (this session has no host
  access): the Unicorn service stopped/disabled and its unit file removed,
  plus its stale config, log, pid and socket files — reported done, not
  independently verified. There is no longer a staging environment, so
  production is the only deployed env; `config/deploy/staging.rb`,
  `config/environments/staging.rb` and the local `.env.staging` look dead
  (a cleanup candidate, not touched here), and the Pass 8 "deploy to
  staging first" guidance no longer applies.
- Rollback to Unicorn is no longer a one-command option; it would mean
  reverting this pass's commits.
- Full RSpec suite: 748 examples, 0 failures, 12 pending, both before and
  after (fresh baseline captured before the first edit; 748 rather than
  743 because master gained specs since Pass 10). `bin/rails
  zeitwerk:check` clean.
- Side effect for the upgrade series: `bundle install` on the hosts no
  longer needs `unicorn`'s native extensions to build, one fewer thing
  to verify for the Ruby 3.4 bump.

**Pass 12 — Public-repo hygiene: remove infrastructure detail (no
Rails/Ruby version change): DONE**
(branch `cleanup/remove-unicorn`, kept separate from Pass 11's changes)

- Trigger: the user pointed out the repo is open source and shouldn't
  carry infrastructure information that could be a security risk.
- Deploy hosts: `config/deploy/production.rb` no longer contains server
  addresses (the two live hosts plus two stale commented-out ones). It
  now `load`s `config/deploy/production_hosts.rb`, which is **gitignored**;
  `config/deploy/production_hosts.rb.sample` is the tracked template. If
  the real file is missing, `cap production ...` aborts with a message
  pointing at the sample and README rather than deploying nowhere.
  Verified with `cap production doctor:servers` (resolves both servers,
  with their roles and the primary flag, when the file is present;
  aborts cleanly when absent). Whoever runs `cap` needs their own copy of
  the real file. Documented in README.md ("Deploying") and in the working
  conventions above.
- CLAUDE.md: removed the IPs, the local path of the provisioning repo,
  host filesystem/socket/unit-file locations and a literal rollback
  command line from the Pass 7/8/11 entries; added the public-repo
  convention; corrected the Pass 8 note about `.env.production`/
  `.env.staging` (local-only, never committed).
- **Not fixed by this pass — history is forever:** the removed values
  remain in this repo's git history and in any fork/clone. Scrubbing
  them would need a history rewrite (and a force-push to a shared
  branch), which was not done and needs an explicit decision. Treat the
  old host addresses as publicly known: rely on firewall/SSH-key hygiene
  rather than their obscurity, and consider re-IP'ing/rotating if that
  matters. Pass 8's note about the tracked `.env` (Stripe variables) is
  unresolved: the session was blocked from reading its values, so
  whether they are live keys is unchecked — the user needs to confirm,
  and rotate + untrack the file if so.
- Not changed: `config.deploy` details that aren't host-identifying
  (stage name, `deploy_to` convention, public domain name).

**Pass 13 — Non-Rails gem CVE sweep (Rails stays 7.2.3.2, Ruby stays
3.3.12): DONE**
(branch `upgrade/gem-cve-sweep`; lockfile-only, no Gemfile change)

- First pass of the CVE-driven series that was planned after Pass 12:
  clear every known-CVE gem that can be fixed inside its current major,
  leaving only the Rails-family advisories, which have no 7.2.x fix and
  are closed by the Rails 8.0 pass. Source of truth was a fresh
  `bundle-audit update && check` (71 advisories before; the 18 left after
  are all `actionpack`/`actionview`/`activestorage`/`actionmailbox`/
  `activesupport`, fixed only by Rails `~> 8.0.5, >= 8.0.5.2` or
  `>= 8.1.4.1`).
- Commit 1 (web-facing stack): `bundle update rack nokogiri loofah
  rails-html-sanitizer addressable crass mail --conservative` — rack 3.2.7
  → 3.2.8, nokogiri 1.19.4 → 1.19.7, loofah 2.25.2 → 2.25.3,
  rails-html-sanitizer 1.7.1 → 1.7.2, addressable 2.9.0 → 2.9.2, crass
  1.0.7 → 1.0.8, mail 2.8.1 → 2.9.1. Rack stays inside `actionpack`
  7.2's `< 3.3` ceiling.
- Commit 2 (infrastructure/dev tooling): net-ssh 7.3.3 → 7.3.10
  (Capistrano side), puma 8.0.2 → 8.0.4 and dalli 3.2.8 → 3.2.17. Puma
  and dalli were updated with `--patch` so they stay on puma 8.0.x and
  dalli 3.2.x — dalli 5.x and puma 8.1 are outside what a CVE sweep
  needs, and Rails 7.2's `MemCacheStore` against dalli 5 is untested.
- Lockfile reviewed line by line: only the ten gems above moved, plus
  new dependency edges (`mail` and `net-ssh` each gained `logger`,
  already locked at 1.7.0; `loofah`/`rails-html-sanitizer` raised their
  own floors on each other and on `nokogiri`). No forced companion bump
  and no Gemfile edit were needed. Nothing outside the intended set moved.
- Full RSpec suite: 748 examples, 0 failures, 12 pending, identical to the
  baseline captured on clean `master` immediately before the first
  change, run on the final state with two different seeds.
  `bin/rails zeitwerk:check` clean; `yarn build` clean.
- Real-server smoke test (the suite never opens a server socket — the
  Pass 7 blind spot): booted real Puma 8.0.4 (3 workers, preloaded) on a
  local port against the dev database and confirmed `/` (redirect to
  sign-in) and `/sign_in` resolve 200 with the Sprockets and esbuild asset
  URLs fetched as real 200s; a real sign-in `POST` returned three
  `Set-Cookie` headers and an authenticated follow-up showed the "Sign
  out" link; repeated DB-backed requests across the workers succeeded
  with no stale-connection errors; `SIGTERM` shut it down cleanly. The
  known `newrelic_rpm` background-thread `SystemStackError` (Pass 6) was
  the only error in the log. `spec/features/event_management_spec.rb` and
  `spec/features/clearance/` were also run on their own: clean. (A
  curl smoke test needs `Accept: text/html`: with `*/*`, Clearance's
  `require_login` returns a bare 401 instead of redirecting.) A quick
  `rails runner` check confirmed `sanitize` still strips scripts and event
  handlers, `Mail` builds and delivers via the test delivery method, and
  `Addressable::URI` normalizes.
- **Not verifiable here:** dalli. The suite uses a null cache store and
  there is no memcached in this devcontainer, so the production
  `:mem_cache_store` path through dalli 3.2.17 was only load-checked
  (the client constructs; a `set` raises `Dalli::RingError` with no
  server, as expected). The same applies to real SMTP delivery via mail
  2.9.1 (only the test delivery method was exercised). Both need a
  look after the first production deploy.
- Post-change `bundle-audit check`: 18 advisories, all Rails family.
- Explicitly deferred/out of scope: the Rails-family advisories (Rails
  7.2 → 8.0.5.2 is the next pass), puma 8.1 and dalli 5.x, the open
  Dependabot group PR that overlaps this sweep (left for the maintainers
  to handle), and the standing list from earlier passes.

**Pass 14 — Rails 7.2.3.2 → 8.0.5.2 (Ruby stays 3.3.12,
`config.load_defaults` stays frozen at 5.0): DONE**
(branch `upgrade/rails-8.0`)

- Closes the 18 Rails-family advisories Pass 13 left behind
  (`actionpack` 6, `activestorage` 6, `actionview` 4, `activesupport` 1,
  `actionmailbox` 1), which had no 7.2.x fix; the fixed releases are
  `~> 8.0.5, >= 8.0.5.2`. Post-change `bundle-audit check`: 0
  vulnerabilities.
- Commit 1 (forced companion): `annotate` → `annotaterb`. `annotate`
  3.2.0 caps `activerecord < 8.0`, so with Rails 8 the resolver would have
  silently downgraded it to the ancient 2.6.5 instead of failing. Decided
  with the maintainers to swap to `annotaterb` (the maintained fork,
  dev-only, resolved 4.26.0). Gem swap only: no `.annotaterb.yml` added
  and the existing schema-comment headers were **not** regenerated.
  Checked: running `annotaterb models` with its defaults rewrites ~50
  model/spec/factory files (about 900 added and 600 removed lines),
  so that was reverted and is left as a separate decision if the team
  wants annotations refreshed. Lockfile diff: `annotate` out,
  `annotaterb` in, nothing else.
- Commit 2 (core bump): Gemfile pin `gem 'rails', '~> 8.0.5', '>=
  8.0.5.2'` (the second bound stops conservative mode short of the
  patched release); `bundle update rails --conservative`. Reviewed the
  full lockfile diff line by line: only the thirteen Rails-family gems
  moved (`actioncable`, `actionmailbox`, `actionmailer`, `actionpack`,
  `actiontext`, `actionview`, `activejob`, `activemodel`, `activerecord`,
  `activestorage`, `activesupport`, `rails`, `railties`), plus dependency
  edges (`cgi`/`racc` dropped from `actionpack`/`railties`, `uri` added to
  `activesupport`, `rails-html-sanitizer` floor `>= 1.7.2`, `rack` cap
  loosened to `>= 2.2.4`). No other gem version moved and no forced
  companion beyond `annotaterb` was needed: `rspec-rails` 6.1.5,
  `clearance` 2.11.0, `kt-paperclip`, `audited`, `delayed_job_active_record`
  and the rest all work unchanged on Rails 8.0.
  - Ran `bin/rails app:update` and declined every conflict
    (`config/application.rb`, `config/boot.rb`, `config/environment.rb`,
    `config/puma.rb`, `config/environments/*.rb`, the same initializer set
    as Passes 2/4, `bin/dev`/`bin/rails`/`bin/setup`, public error pages,
    `robots.txt`), and discarded the newly offered scaffolding
    (`bin/rubocop`, `public/400.html`, `public/406-unsupported-browser.html`,
    `public/icon.{png,svg}`). Kept only
    `config/initializers/new_framework_defaults_8_0.rb` (verified fully
    commented out). No migration was offered or needed.
  - `Regexp.timeout = 1` (the new 8.0 default) turned out to be a
    `load_defaults 8.0` setting, offered only in the commented-out defaults
    file, so it does **not** apply while `load_defaults` stays at 5.0;
    `Regexp.timeout` is `nil` in the app. It still has to be reckoned with
    when the `load_defaults` catch-up happens (about 28 regex call sites).
  - None of the AR/ActionController/ActiveJob configs Rails 8.0 removed are
    set outside the commented-out `new_framework_defaults_7_1.rb`.
- No app-code fix was needed.
- Verification:
  - Full RSpec suite: baseline on clean master 748 examples, 0 failures, 12
    pending (seed 1081); after the change 748/0/12 on two seeds (4242 and
    9917). `bin/rails zeitwerk:check` clean, `yarn build` clean.
  - Deprecations (test env prints them to stderr; the suite hit exactly one
    unique warning, at boot, and none in `log/test.log` or in the
    development-env requests below): `to_time` will always preserve the full
    timezone rather than the offset in Rails 8.1 (opt in with
    `config.active_support.to_time_preserves_timezone = :zone`; triggered by
    the `load_defaults 5.0` value `true`). This is the Rails 8.1 pass's
    checklist. No Time/TimeWithZone arithmetic or `Time#since(Time)`
    deprecations fired.
  - Real-server smoke test (the suite never opens a socket): real Puma
    (3 workers, preloaded, development env) served `/` and `/sign_in` and
    the real Sprockets/esbuild asset URLs as 200s; a real sign-in `POST`
    returned three `Set-Cookie` headers (`remember_token`, the session
    cookie, `__profilin`) and the follow-up request showed "Sign out";
    repeated DB-backed requests across the workers all succeeded with no
    stale-connection errors; `SIGTERM` shut it down gracefully. The known
    `newrelic_rpm` background-thread `SystemStackError` (Pass 6) was the
    only error. `spec/features/event_management_spec.rb` and
    `spec/features/clearance/` also run individually: 27 examples, 0
    failures. The temporary user created for the sign-in was deleted.
  - Production-env boot against a scratch local Postgres database (schema
    loaded, dummy secret, from a clean `git archive` copy so no local env
    file was loaded; dropped afterward): eager-load clean, no deprecation
    output, `ActiveSupport::Cache::MemCacheStore` and the Paperclip S3 config
    resolved, and, after a production `assets:precompile` (digested output for
    both esbuild bundles and the Sprockets assets), `/sign_in` rendered 200
    through the production middleware stack including rack-cache.
  - Cache store: this devcontainer does provide a local memcached (reached
    through the `MEMCACHE_SERVERS` environment variable), so the production
    `:mem_cache_store` path through dalli 3.2.17 was exercised for real:
    write/read/delete/fetch round trips on `Rails.cache`, a plain
    `MemCacheStore`, and one with a `pool:` option (connection_pool 2.5.5),
    all succeeded. This closes the dalli gap Pass 13 left open.
    Real SMTP delivery via `mail` 2.9.1 remains unverified (test delivery
    method only).
- Found along the way, not fixed (out of scope): `sprockets-rails` 3.4.2's
  missing-asset fallback in `compute_asset_path` calls the removed singleton
  `ActiveSupport::Deprecation.warn`, so a page referencing an asset that is
  absent from the manifest raises `NoMethodError` instead of falling back.
  It only matters when assets were not precompiled (it showed up in a
  production-env check without a precompile and disappeared once assets
  existed), so it is not a deploy risk, but it is a latent trap if a layout
  ever references an unprecompiled asset. A newer `sprockets-rails` (3.5.x)
  exists; not bumped here.
- Deploy note: first Rails-major deploy. Deploy to **one production host
  first** and verify sign-in (multiple `Set-Cookie`), a Paperclip/S3 image, a
  mailer / DelayedJob job, the cache (dalli) and the Honeybadger channel
  before the second host. Watch the logs for `Regexp::TimeoutError`
  (not expected while `load_defaults` is 5.0) and deprecation noise.
  Rollback is redeploying the previous release; this pass adds no
  migrations.
- Explicitly deferred/out of scope: removing the `connection_pool < 3.0`
  pin (Rails 8.0's `MemCacheStore` should no longer need it, but that is a
  separate follow-up now that a memcached check is possible locally),
  regenerating model annotations, `config.load_defaults`, the open
  Dependabot PR (left to the maintainers), `sprockets-rails` 3.5.x, and the
  standing list from earlier passes.

**Next pass: not yet decided.** The remaining CVE-driven upgrade series
is planned as: Ruby 3.3.12 → 3.4.13 (add `gem 'csv'`) → Rails 8.0.5.2 → 8.1.4.1
(the `to_time` deprecation above is its input checklist). The `annotate`
decision is settled (Pass 14: `annotaterb`). Other candidates: brakeman
for SAST, wiring `bundle-audit` into `.github/workflows/main.yml` as a CI
gate, the `connection_pool < 3.0` pin removal, and the
`config.load_defaults` catch-up (long-deferred, lowest urgency). Decide
based on what's most pressing when picking up the next pass — don't assume
the order above is a commitment.
