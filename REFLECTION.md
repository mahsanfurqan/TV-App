# Written Reflection

## 1. Which part of your submission are you least confident about, and why?

I am least confident about visual behavior across the full range of physical iPhones and accessibility configurations. I do not own a Mac and had limited access to a friend's Mac during development, so I relied on focused simulator feedback and macOS CI for compilation and automated tests. That process caught a horizontal viewport bug, but automated tests cannot replace checking Dynamic Type, VoiceOver, poor connectivity, memory pressure, and several real devices. With more time and hardware access, I would add snapshot tests at compact and regular widths and complete a manual accessibility matrix.

## 2. Describe a moment when you got completely stuck. What did you do, step by step?

I was blocked by the Swift compiler error `Cannot call value of non-function type 'Int'`. First, I reduced the problem to the repository's cached pagination path instead of changing unrelated UI code. Second, I inspected the local parameter and helper symbols and found that a helper name collided with an integer in the same context. Third, I renamed the helper to express its purpose more clearly. Fourth, I reran the macOS CI build and all tests because my Windows machine could not compile an iOS target. Finally, I kept the fix in its own commit (`3e3d35c`) so the cause and correction remained reviewable.

Another useful lesson came from simulator feedback: the app compiled and tests passed, but the entire interface could move horizontally. I reproduced the issue conceptually from the layout hierarchy, separated intentional horizontal content rails from screen-level scrolling, constrained root content to the viewport, and verified the updated build again. This reminded me that compiler success is not UI validation.

## 3. It is Thursday, the task is due Friday, and you realize half your work is based on a misunderstood requirement. What do you do?

I would first restate the corrected requirement in concrete acceptance criteria and identify which completed work is still reusable. Then I would rank the remaining work by submission value: correct core flow, required states, tests, and documentation before optional polish. I would communicate the risk early, including what changed and a realistic recovery plan, rather than hiding it until the deadline. I would keep valid work, remove behavior that conflicts with the requirement, and deliver a smaller coherent solution. If the required scope still could not be completed responsibly, I would request a specific extension as early as possible.

## 4. Your mentor asks you to change an approach you believe is worse. What do you do?

I would first ask what constraint or risk is driving the request because the mentor may have context I do not. I would explain my concern with evidence such as maintenance cost, failure cases, or a small prototype, and present an alternative with its trade-offs. If the decision remains the mentor's and it does not create a security, legal, or severe reliability issue, I would commit to the team decision and implement it well. I would document the decision where future maintainers need the context. For a serious safety or security concern, I would respectfully escalate it rather than silently complying.

## 5. What is something technical you recently taught yourself outside class/work, and how did you learn it?

I recently studied modern SwiftUI state observation and Swift concurrency while building this project. I started by translating patterns I knew from other mobile frameworks into small Swift concepts: actor-isolated UI models, protocol-based dependency injection, value-based navigation, and async repository calls. I used AI to accelerate exploration, but checked the generated structure against compiler diagnostics and wrote focused tests for mapping, state transitions, cache fallback, and localization. When concurrency and animation warnings appeared, I isolated and fixed them in separate commits, then used macOS GitHub Actions as an independent build environment. The most useful part was learning through short feedback loops rather than trying to understand the entire framework before writing anything.
