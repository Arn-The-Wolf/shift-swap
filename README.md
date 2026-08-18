# Shift Swap

A small Ruby on Rails app for small teams to view upcoming shifts, request coverage from teammates, and let managers approve or deny swap requests — with Hotwire/Turbo updates and no full-page reload on approve/deny.

## Features

- Email/password auth via `has_secure_password`
- Dashboard of the signed-in user's upcoming shifts
- Swap requests between teammates for a specific shift
- Manager desk to approve/deny pending requests (Turbo Stream)
- Seeded demo data for Harbor Cafe and Northside Clinic

## Schema

```
Team
  has_many :users
  has_many :shifts

User
  belongs_to :team
  has_many :shifts
  has_secure_password
  manager: boolean

Shift
  belongs_to :user
  belongs_to :team
  title, starts_at, ends_at

SwapRequest
  belongs_to :requesting_user (User)
  belongs_to :target_user (User)
  belongs_to :shift
  status: pending | approved | denied
```

Approving a swap reassigns the shift from the requesting user to the target user.

## Local setup

Requirements: Ruby 3.4+, Bundler, SQLite.

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/dev
```

Then open [http://localhost:3000](http://localhost:3000).

### Demo logins

Password for all seeded users: `password`

| Role | Email |
|------|-------|
| Harbor manager | maya@harbor.test |
| Harbor staff | jordan@harbor.test |
| Harbor staff | sam@harbor.test |
| Clinic manager | priya@clinic.test |
| Clinic staff | devon@clinic.test |

### Tests

```bash
bundle exec rspec
```

## Deploy to Render.com

This repo includes:

- `Procfile` — Puma web process
- `render.yaml` — Blueprint (web service + Postgres)
- `bin/render-build.sh` — install, assets, migrate, seed
- Production `DATABASE_URL` Postgres config

### One-click Blueprint

1. Push this repo to GitHub
2. In Render: **New → Blueprint**
3. Connect the repo and apply `render.yaml`
4. Set `RAILS_MASTER_KEY` to the contents of `config/master.key` (or generate credentials for production)
5. Deploy

After deploy, use the seeded demo accounts above.

### Manual web service

1. Create a **PostgreSQL** database on Render
2. Create a **Web Service** from this repo (Ruby)
3. Build command: `./bin/render-build.sh`
4. Start command: `bundle exec puma -C config/puma.rb`
5. Env vars:
   - `DATABASE_URL` (from the Postgres addon)
   - `RAILS_MASTER_KEY`
   - `RAILS_ENV=production`

## Stack

- Rails 8 + Hotwire (Turbo / Stimulus)
- Tailwind CSS
- SQLite (dev/test) / PostgreSQL (production)
- RSpec
