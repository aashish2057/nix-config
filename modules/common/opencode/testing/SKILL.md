---
name: testing
description: Use when adding, changing, or reviewing tests in any language.
---

# Testing

Use this when you add, change, or review a test. Language-agnostic starting rules, distilled from the [Google Testing Blog](https://testing.googleblog.com/) (404 posts, 2007–2026).

A test earns its cost only when a real defect makes it fail, and the failure names the broken behavior. Otherwise delete it or rewrite it.

## Worth writing

Name the bug it would catch. If you cannot, do not write it. Hold all four ([Effective Testing](https://testing.googleblog.com/2014/05/testing-on-toilet-effective-testing.html)):

- **Fidelity.** Broken behavior fails the test.
- **Resilience.** A behavior-preserving change stays green. A new behavior adds a test.
- **Precision.** The name and the check identify what broke, without another run.
- **Payoff.** The risk is worth the cost to write, run, and keep.

An empty test is resilient and useless. A copy of the implementation is brittle and also useless.

## Behavior

A behavior is an observable outcome: given this input and state, the caller sees this result, error, or persisted change. One operation can have many behaviors. Give each its own test ([Test Behaviors, Not Methods](https://testing.googleblog.com/2014/04/testing-on-toilet-test-behaviors-not.html)).

Test through the surface a caller uses. A UI test drives the control the user uses. Calling the handler directly misses a disabled or unwired control.

Use the smallest test that can catch that bug. Also test the workflow after the happy path. Two correct features can still destroy data together.

## Shape

Prefer many small tests, fewer tests of a few units together, and a handful of end-to-end tests. About 70 / 20 / 10 is a shape, not a quota ([Just Say No to More End-to-End Tests](https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html)).

Small tests stay in one process: no network, no wall clock, no sleep, no shared storage, any order. Medium tests wire a few real units to fakes. Large tests cover one critical journey, or one failure class smaller tests cannot represent, and stay isolated from shared environments.

Move a test down a level when a smaller test would catch the same bug. Avoid a suite that is almost all end-to-end, and one with many unit tests, many end-to-end tests, and nothing in between.

## Obvious bugs

- The name states the situation and the outcome.
- The input that matters sits next to the check.
- Show the values the check depends on. Repeat a literal when that makes the example obvious ([Tests Too DRY? Make Them DAMP!](https://testing.googleblog.com/2019/12/testing-on-toilet-tests-too-dry-make.html)).
- State inputs and outputs directly. A branch, loop, or expected value computed the same way as production can share the bug.
- Check only this behavior’s outcome. Full equality of a large result fails for unrelated changes.
- Use non-default values, a different value per input, and a boundary that flips a branch. Zero, empty, and false pass when the code ignores the input ([Choosing Values for Robust Tests](https://testing.googleblog.com/2026/06/choosing-values-for-robust-tests.html)).
- The failure text includes the actual value.

## Dependencies

Prefer the real dependency, then a small fake with the same contract, then a mock ([Increase Test Fidelity By Avoiding Mocks](https://testing.googleblog.com/2024/02/increase-test-fidelity-by-avoiding-mocks.html)).

Assert the outcome. Verify a call only when that call is the behavior, such as “exactly one send,” and only the arguments that matter.

Do not mock a type you do not own. Call it, use the owner’s fake, or wrap it and test the wrapper against the real type once.

A test that records the calls it just arranged, and checks nothing else, is a change-detector. It breaks on every refactor and catches nothing ([Change-Detector Tests Considered Harmful](https://testing.googleblog.com/2015/01/testing-on-toilet-change-detector-tests.html)).

## Determinism and coverage

A test that both passes and fails on the same code trains people to ignore red results. Inject time and randomness. Give each test its own storage. Do not sleep or call shared services. The suite must pass in any order.

A covered line has run. It has not been checked. Look at what never runs. Cover the lines you change. Do not add a test only to raise a number. A small deliberate change that no test notices is an unpinned behavior.

## Before you add a test

1. I can name the bug this catches.
2. A wrong behavior fails it. A behavior-preserving change does not.
3. The name, the inputs, and the check describe that one outcome.
4. The dependency is as real as this size allows.
5. It can run alone, in any order, unless it is an explicit larger test.

If a line is no, change the test or do not add it.
