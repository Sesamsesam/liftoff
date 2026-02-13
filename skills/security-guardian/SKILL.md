---
name: security-guardian
description: "14-point security framework. Covers the 95% that matters - agent enforces automatically on every code change."
category: code-quality
---

# Security Guardian

> **🤖 You don't need to do any of this manually.** This guide explains how this tool works so you can learn and understand it. But the agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

## What Is This?
A 14-point security checklist that your AI agent follows automatically on every code change. It covers the security measures that prevent 95% of real-world vulnerabilities.

## Why Does It Exist?
Most security breaches exploit simple mistakes: exposed API keys, unsanitized inputs, missing auth checks. These aren't exotic attacks - they're preventable oversights. This skill ensures the agent catches them before they ship.

## What It Does For You
You never need to think "did I handle security?" The agent does it for you, every time - checking for leaked secrets, validating inputs, enforcing auth boundaries, and auditing dependencies. A senior developer reviewing your code would find it locked down.

---

## Activation
- **Every code change.** This skill is checked during the Guard phase of F.O.R.G.E.
- Specifically triggered by: new files, mutations, API routes, environment variables, dependency additions, file uploads, error handling, deployment configs.

## Enforcement
- The agent MUST run these checks before any commit.
- If a violation is found, the agent fixes it before proceeding - not after.
- Security is never deferred to "a later sprint."

---

## The 14-Point Framework

### 1. Secrets Exposure
**What:** Scan every file for hardcoded secrets before commit.
**Detection regexes:**
```
sk-[a-zA-Z0-9]{20,}          # OpenAI
ghp_[a-zA-Z0-9]{36}          # GitHub PAT
sbp_[a-f0-9]{40}             # Supabase
AIza[a-zA-Z0-9_-]{35}        # Google API
AKIA[A-Z0-9]{16}             # AWS
Bearer [a-zA-Z0-9._-]+       # Auth tokens
-----BEGIN (RSA |EC )?PRIVATE KEY-----
eyJ[a-zA-Z0-9_-]+\.eyJ       # JWT tokens
```
**Action:** If found → immediately warn, remove from code, add to `.env`, update `.gitignore`.

### 2. Secrets in Chat
**What:** Detect when the user pastes a key/token/password into the chat.
**Action:** Warn immediately: "I see what looks like a secret. I won't include this in any code or commit. Please rotate this key."

### 3. Input Hardening
**What:** Every user input must be validated before processing.
**Implementation:**
- Use Zod schemas on ALL mutation/action inputs (Convex pattern)
- Apply `sanitizeText()` for plain text display
- Apply `sanitizeHtml()` only when rich text is explicitly needed
- Never trust client-side validation alone - always validate server-side

```typescript
// ✅ Correct - Zod schema validates input
export const createPost = mutation({
  args: {
    title: v.string(),
    content: v.string(),
  },
  handler: async (ctx, args) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) throw new Error("Not authenticated");
    // Sanitize before storing
    const safeTitle = sanitizeText(args.title);
    // ...
  },
});
```

### 4. File Upload Security
**What:** Validate uploads server-side, never trust file extensions alone.
**Rules:**
- Check magic bytes (file signature), not just extension
- Enforce size limits (configurable per upload type)
- Allowlist file types (never blocklist)
- Store in sandboxed storage (e.g., Convex file storage, S3 with restricted access)
- Generate new filenames - never use user-provided filenames in paths

### 5. Database Injection
**What:** Prevent SQL/NoSQL injection.
**Rules:**
- Parameterized queries only - never string concatenation
- Convex provides type safety by default - leverage it
- For raw SQL (Supabase): always use parameterized queries via the client SDK
- Never expose raw database IDs in URLs without auth checks

### 6. Auth Boundary
**What:** Every public mutation/action must verify the user's identity.
**Implementation:**
```typescript
// ✅ First line of every public mutation
const identity = await ctx.auth.getUserIdentity();
if (!identity) throw new Error("Not authenticated");
```
**Rules:**
- Use `internalMutation` / `internalAction` for server-only operations (Convex)
- Never use `mutation` for admin-only operations without role checks
- Check ownership: user can only modify THEIR data, not just any authenticated user's data

### 7. Credential Rotation
**What:** Track when credentials were last rotated. Remind on schedule.
**Implementation:**
- Track in `.antigravity/security.json`:
```json
{
  "credentials": {
    "CONVEX_DEPLOY_KEY": { "lastRotated": "2026-01-15", "rotationDays": 90 },
    "CLERK_SECRET_KEY": { "lastRotated": "2026-02-01", "rotationDays": 90 }
  }
}
```
- Agent checks this file during Session Start. If overdue → warn with specific instructions.

### 8. Dependency Auditing
**What:** Check for known vulnerabilities before deploying.
**Commands:** `bun audit` or `npm audit`
**Rules:**
- Run before every deployment
- Critical/High vulnerabilities must be resolved before shipping
- Document any accepted risks with a comment explaining why

### 9. Log Safety
**What:** Never log sensitive data.
**Rules:**
- Redact tokens before logging - show only last 4 characters: `sk-...a1b2`
- Never log full request bodies that may contain passwords
- Never log full error stacks to user-facing responses
- Use structured logging (JSON format) for easy filtering

### 10. `.gitignore` Hygiene
**What:** Auto-check that sensitive files are excluded from Git.
**Must include:**
```gitignore
.env*
.antigravity/
node_modules/
*.pem
*.key
.wrangler/
.convex/_generated/
```
**Action:** On project init, verify `.gitignore` exists and covers all patterns above.

### 11. Deployment Config
**What:** Production configs must be hardened.
**Checks:**
- CORS: specific origins only, never `*` in production
- Debug mode: OFF in production
- Error messages: generic for users, detailed only in server logs
- HTTPS only - no mixed content

### 12. Dependency Verification
**What:** Verify packages are legitimate before installing.
**Checks:**
- Does the package exist on npm? (Catch hallucinated package names)
- Does it have meaningful download counts? (Catch typosquatting)
- Is the package name exactly correct? (`lodash` not `1odash`)
- Check last publish date - abandoned packages may have known vulnerabilities

### 13. Error Handling (Security Angle)
**What:** Errors must never leak sensitive information or grant unintended access.
**Rules:**
- Never "fail open" - if auth check errors, DENY access
- User-facing error messages: generic ("Something went wrong")
- Server logs: detailed for debugging
- Never expose stack traces, file paths, or internal IDs to users
- For full error handling patterns (what TO do), see `error-handling` skill

### 14. Secure Prompting
**What:** The agent itself must follow secure practices.
**Rules:**
- Never hardcode secrets in code examples or artifacts
- Always include input validation when generating mutation code
- When generating auth code, always check identity first
- Never suggest `eval()`, `innerHTML`, or `dangerouslySetInnerHTML` without sanitization
- When suggesting environment variables, always mention `.env` + `.gitignore`

---

## What We Skip (The 5%)

These are real security measures, but they require specialized expertise or infrastructure beyond what a solo developer needs to ship securely:

- CSP (Content Security Policy) headers
- SRI (Subresource Integrity)
- Certificate pinning
- DNSSEC
- Custom WAF rules
- Penetration testing harness

> [!TIP]
> If the project reaches production scale with paying users, revisit this list. The 5% becomes relevant when you're a target.
