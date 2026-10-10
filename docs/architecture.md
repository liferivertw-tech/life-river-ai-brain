# LIFE RIVER AI Brain — Architecture Baseline V0.1

## Boundary
AI Brain is a shared intelligence service, not the database or deployment owner of SMART TOUR, multilingual communication, language learning or MEMORY.

## TOI pipeline
Source Registry -> Connector -> Raw Item -> Deduplication/Event -> Evidence Verification -> Insight -> Opportunity -> Human Review -> Approved Integration.

## V1 scope
RSS/official announcements and YouTube metadata first. Google Trends subject to lawful source access; Facebook/Threads initially accept manually supplied public URLs until official API permissions are confirmed.

## Data governance
Preserve source URL, published_at, fetched_at, source language, license/terms metadata, evidence and confidence. Do not copy full copyrighted articles by default. No unconsented private social data.

## Security
Least privilege, secrets in environment, bounded request rates, audit trail, review gate before external actions. Distinguish facts, source claims and AI inferences.

## Integration
Future versioned REST API with service-level authentication and explicit product-scoped permissions. No direct writes to product databases.
