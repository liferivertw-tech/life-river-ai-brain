# TOI-CASE-001 — Meta Muse competitive research (2026-10-11)

Status: research baseline; not a Muse integration or deployed collector.

## Verified official references
- https://about.fb.com/news/2026/09/introducing-muse-personal-ai-agent
- https://ai.meta.com/muse/
- https://about.fb.com/news/2026/09/launching-meta-enterprise-platform/
- https://research.meta.ai/blog/security-and-safety-for-ai-agents-our-approach-with-muse

Meta describes Muse as a personal agent with a persistent secure VM/browser, app connectors, background tasks, permission controls, and approval gates. Meta announced Muse API as part of its Enterprise Platform on 2026-09-28; access, pricing, Taiwan eligibility, and production readiness require separate verification. Do not assume API credentials or Taiwan availability.

## Reuse existing TOI baseline
Current: README.md; docs/architecture.md; modules/trend-intelligence/README.md; modules/trend-intelligence/schema.sql. Do not replace the existing source/item/opportunity/evidence/review tables.

## Design decisions
1. Source-first ingestion: RSS/official notices and YouTube Data API first. Facebook/Threads: manual public links until lawful API access confirmed.
2. Agent orchestration: task -> scoped permissions -> connector -> evidence -> insight -> opportunity -> human review -> approved action.
3. Background work: durable jobs, idempotency keys, retries/backoff, rate limits, audit trail and explicit failure state.
4. Sandbox browser tasks and protect secrets; treat retrieved pages as untrusted instructions.
5. No autonomous publishing, purchasing, cross-product database writes, or external messages without approval.
6. Provider-neutral adapter for optional Muse API; no dependency on Meta service availability.

## Next implementation increments
- BUILD 01: additive migrations for job_runs, connector_runs, audit_events, agent_permissions; contracts and tests.
- BUILD 02: RSS connector with fixtures, YouTube API adapter with mock tests, deduplication and provenance.
- BUILD 03: evidence-grounded scoring, citation checks, human-review queue.
- BUILD 04: read-only dashboard and manual approval flow.
- BUILD 05: product-scoped integration API and optional Muse adapter if approved/available.

## Acceptance criteria
- A permitted RSS item can be ingested twice without duplicate items.
- YouTube metadata can be processed without persisting API credentials.
- Each proposed opportunity links to source evidence and timestamps.
- No side effect executes before explicit authorization; audit events trace each decision.
- Offline automated tests pass before any production deployment.
