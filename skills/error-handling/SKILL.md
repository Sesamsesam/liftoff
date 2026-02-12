---
name: error-handling
description: "Enterprise-grade error handling patterns. What separates amateur code from professional code."
category: code-quality
---

# Error Handling

## What Is This?
A set of battle-tested error handling patterns that the agent writes into your code automatically. These patterns make your code resilient, debuggable, and professional.

## Why Does It Exist?
90% of application crashes come from unhandled errors, silent failures, and poor resource cleanup. Amateur code uses bare `try/catch` with `console.log`. Professional code uses structured patterns that recover gracefully, report meaningfully, and clean up after themselves. This skill ensures every project gets the professional version from day one.

## What It Does For You
The agent writes these patterns into your code automatically — you don't need experience with error handling. A senior developer reviewing your codebase would see proper Circuit Breaker patterns, structured error reporting, and graceful fallbacks — hallmarks of production-ready software.

---

## Activation
- Any code that makes external API calls, handles file I/O, processes user input, or manages resources
- During the Guard phase of F.O.R.G.E.
- When implementing new features that interact with external services

## Enforcement
- The agent MUST NOT leave bare `try/catch` blocks with only `console.log`
- Every `catch` block must handle the error meaningfully (retry, fallback, or structured report)
- For the security angle of errors (what NOT to do), see `security-guardian` skill point #13

---

## Delineation with Security Guardian

| This Skill (What TO Do) | Security Guardian #13 (What NOT To Do) |
|---|---|
| Use Circuit Breaker for API resilience | Never "fail open" on auth errors |
| Implement graceful fallbacks | Never expose stack traces to users |
| Structure error reporting for debugging | Never log sensitive data in error details |
| Clean up resources on failure | Generic messages to users, details in server logs |

---

## Pattern 1: Circuit Breaker

**When:** Your code calls an external API (OpenAI, Stripe, any third-party service).
**Why:** External services fail. Without a circuit breaker, one slow API call can cascade and bring down your entire app.

```typescript
class CircuitBreaker {
  private failures = 0;
  private lastFailure = 0;
  private readonly threshold = 5;
  private readonly resetTimeout = 60_000; // 1 minute

  async call<T>(fn: () => Promise<T>, fallback?: () => T): Promise<T> {
    // If circuit is open (too many failures), use fallback
    if (this.failures >= this.threshold) {
      if (Date.now() - this.lastFailure < this.resetTimeout) {
        if (fallback) return fallback();
        throw new Error("Service temporarily unavailable. Please try again.");
      }
      this.failures = 0; // Reset after timeout
    }

    try {
      const result = await fn();
      this.failures = 0; // Reset on success
      return result;
    } catch (error) {
      this.failures++;
      this.lastFailure = Date.now();
      if (fallback) return fallback();
      throw error;
    }
  }
}

// Usage
const openAIBreaker = new CircuitBreaker();
const response = await openAIBreaker.call(
  () => openai.chat.completions.create({ /* ... */ }),
  () => ({ choices: [{ message: { content: "AI is temporarily unavailable." } }] })
);
```

## Pattern 2: Error Aggregation (Structured Reporting)

**When:** Your app handles multiple operations that can each fail independently.
**Why:** Scattered `console.log("error:", e)` makes debugging impossible. Structured error reporting means when something fails in production, you know exactly what happened, where, and why.

```typescript
type ErrorCategory = "auth" | "network" | "validation" | "storage" | "unknown";

interface StructuredError {
  category: ErrorCategory;
  operation: string;
  message: string;
  timestamp: number;
  context?: Record<string, unknown>;
}

class ErrorReporter {
  private errors: StructuredError[] = [];

  report(category: ErrorCategory, operation: string, error: unknown, context?: Record<string, unknown>) {
    const structured: StructuredError = {
      category,
      operation,
      message: error instanceof Error ? error.message : String(error),
      timestamp: Date.now(),
      context,
    };
    this.errors.push(structured);
    // Log structured — no sensitive data
    console.error(JSON.stringify({ level: "error", ...structured }));
  }

  getErrorsByCategory(category: ErrorCategory): StructuredError[] {
    return this.errors.filter(e => e.category === category);
  }
}

// Usage
const reporter = new ErrorReporter();
try {
  await saveToDatabase(data);
} catch (error) {
  reporter.report("storage", "saveToDatabase", error, { table: "posts", userId });
}
```

## Pattern 3: Graceful Degradation

**When:** A feature depends on a service that might be unavailable.
**Why:** Your app should never crash because one feature's backend is down. Users should see the rest of the app working, with a clear message about what's temporarily unavailable.

```typescript
async function loadDashboard(userId: string) {
  // Core data — must succeed
  const user = await getUser(userId);

  // Enhanced data — degrade gracefully if unavailable
  const [analytics, recommendations] = await Promise.allSettled([
    fetchAnalytics(userId),
    fetchRecommendations(userId),
  ]);

  return {
    user,
    analytics: analytics.status === "fulfilled"
      ? analytics.value
      : { available: false, message: "Analytics loading..." },
    recommendations: recommendations.status === "fulfilled"
      ? recommendations.value
      : { available: false, message: "Recommendations unavailable" },
  };
}
```

## Pattern 4: Fail Fast

**When:** You detect an invalid state early in a function.
**Why:** The sooner you catch a problem, the easier it is to debug and the less damage it causes.

```typescript
// ✅ Fail fast — validate at the boundary
function processPayment(amount: number, currency: string) {
  if (amount <= 0) throw new Error("Payment amount must be positive");
  if (!["usd", "eur", "gbp"].includes(currency)) throw new Error(`Unsupported currency: ${currency}`);
  // ... proceed with valid data
}

// ❌ Don't check deep inside nested logic where the error is hard to trace
```

## Pattern 5: Resource Cleanup

**When:** Your code opens connections, file handles, timers, or subscriptions.
**Why:** Leaked resources cause memory issues, connection exhaustion, and mysterious production bugs.

```typescript
// ✅ Always clean up — use try/finally
async function processFile(path: string) {
  const handle = await openFile(path);
  try {
    const data = await handle.read();
    return transform(data);
  } finally {
    await handle.close(); // Always runs, even on error
  }
}

// ✅ For subscriptions and intervals
useEffect(() => {
  const subscription = eventSource.subscribe(handler);
  const timer = setInterval(poll, 5000);
  return () => {
    subscription.unsubscribe();
    clearInterval(timer);
  };
}, []);
```

---

## Anti-Patterns (What NOT To Do)

| Anti-Pattern | Why It's Bad | Fix |
|---|---|---|
| `catch (e) { console.log(e) }` | No recovery, no structure, invisible in production | Use structured reporting |
| Empty catch blocks `catch {}` | Silently swallows errors — bugs become invisible | At minimum, log with context |
| `catch (e) { return null }` | Caller doesn't know something failed | Return a result type or re-throw |
| Catching too broadly | Hides different failure modes | Catch specific error types |
| No cleanup in error paths | Resource leaks | Use `try/finally` |
