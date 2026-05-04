# CLAUDE.md

## Project
<!-- One sentence: what this project does and who it's for. -->
[Describe the project here]

## Stack
- Ruby [version]
- Rails [version]
- [DB: PostgreSQL / MySQL / SQLite]
- [Background jobs: Sidekiq / GoodJob / other]
- [Cache: Redis / Memcached / other]
- [Auth: Devise / other]

## Commands
```bash
# Dev server
bin/rails server

# Rails console
bin/rails console

# Tests
bin/rails test
bin/rails test test/models/user_test.rb   # single file
bundle exec rspec                          # if using RSpec
bundle exec rspec spec/models/user_spec.rb

# Lint / format
bundle exec rubocop
bundle exec rubocop -a      # auto-fix safe offenses

# Database
bin/rails db:migrate                  # apply pending migrations
bin/rails db:migrate:status           # check migration status
bin/rails db:rollback                 # roll back last migration
bin/rails db:seed                     # seed the database

# Generate
bin/rails generate model User name:string email:string
bin/rails generate controller Users index show
bin/rails generate migration AddPhoneToUsers phone:string

# Assets
bin/rails assets:precompile
```

## Architecture
```
app/
  models/           — ActiveRecord models and business logic
  controllers/      — thin controllers, delegate to models/services
  views/            — ERB templates (or JSON via jbuilder/serializers)
  services/         — POROs for complex business operations
  jobs/             — background jobs
  mailers/          — email templates and logic
  serializers/      — API response shaping (if API mode)
config/
  routes.rb         — all routes defined here
  database.yml      — database config
db/
  schema.rb         — authoritative schema (never edit manually)
  migrate/          — migration files
  seeds.rb          — seed data
spec/ or test/      — test files mirroring app/ structure
```

## Model conventions
- Fat models — business logic belongs in models, not controllers
- Use service objects in `app/services/` for operations that span multiple models
- Always add indexes for foreign keys and columns used in `where` clauses
- Use scopes for reusable query conditions
- Validate at the model layer, not just the database

## Controller conventions
- Thin controllers — one action should do one thing
- Use `before_action` for auth and object lookup
- Respond with `render` or `redirect_to` only — no logic
- Keep actions to the 7 RESTful defaults; extract to a new controller if you need more

## Migrations
- Never edit `db/schema.rb` manually — it's generated
- Never modify a migration that has already been run in any environment — create a new one
- Always run `db:migrate:status` before applying migrations
- Never auto-run migrations — show the command and let the user run it

## Tests
- Mirror the `app/` structure in `spec/` or `test/`
- Use fixtures or FactoryBot for test data — never raw `Model.create` in tests
- Test the model layer and service layer heavily; controller tests are thin
- Never stub the database

## Background jobs
- Jobs should be idempotent — safe to run more than once
- Keep job logic thin — delegate to service objects
- Always handle errors explicitly and use retry limits

## Never do
- Never put SQL strings directly in controllers
- Never call external APIs synchronously in a request — use a background job
- Never store secrets in `database.yml` or any committed file — use credentials or env vars
- Never run `db:drop` or `db:reset` without explicit confirmation

## Git
- Branch format: `type/short-description`
- Commit format: `type: description`
- Types: `feat` `fix` `refactor` `test` `docs` `chore`
