# Action

An iOS app that gets people to do the thing they're avoiding, right now. It gives exactly enough to take the action and then walks through it, one step at a time.

## Layout

```
ios/        SwiftUI app (iOS 17+, SwiftData, Speech)
backend/    Next.js API routes that call Claude. Deploys to Vercel.
```

### iOS app

```
ios/ActionApp/
  App/          entry point, root view, router, preview data
  Models/       Mission, RoutineItem, ActionReport (SwiftData), GamePlan
  Services/     CoachService protocol + remote, sample and fallback implementations,
                SpeechTranscriber protocol + Apple on-device implementation
  Components/   PrimaryButton, VoiceTextField, QuoteCard, ErrorLine
  Features/     one folder per feature, one view per file
    Start/          three questions, one at a time
    GamePlan/       opener, structure, one-line summary, LET'S DO IT
    WalkThrough/    one step at a time, NEXT unlocks the next
    SayIt/          "How do I say this?"
    Objection/      "I got an objection"
    Practice/       objection practice
    Script/         full script, only on request
    Daily/          NOW screen and the planner that picks what to do now
    Feedback/       "What happened?"
    InMyHead/       "I'm in my head" button and flow
```

The Xcode project uses a synchronized folder, so new files under `ios/ActionApp/` are picked up automatically.

Build from the command line:

```sh
xcodebuild -project ios/ActionApp.xcodeproj -scheme ActionApp \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

Or open `ios/ActionApp.xcodeproj` in Xcode 16+ and run.

**Sample data.** With no backend configured, the app uses `SampleCoachService`, which has realistic plans for sales calls, door-to-door and general goals, plus objections and lines. Every screen works offline.

**Connect the backend.** Set `AppConfig.backendURL` (and `appToken` if you set `APP_TOKEN` on the server) in `ios/ActionApp/Services/AppConfig.swift`. If the backend fails, the app falls back to sample answers so the user is never stuck.

**Live coach later.** `SpeechTranscriber` returns a stream of partial transcripts. A future live microphone coach can consume that same stream and call the coach service while the user talks.

### Backend

| Endpoint | Body | Returns |
| --- | --- | --- |
| `POST /api/game-plan` | `goal, avoiding, mustDo, feedback[]` | `title, opener, steps[{title, action, firstLine}], summary, dayPlan[{time, title}]` |
| `POST /api/say-it` | `intent, context, step?` | `line` |
| `POST /api/objection` | `objection, context, step?` | `answer` |
| `POST /api/practice` | `context, objection?, reply?` | `better, nextObjection` |
| `POST /api/script` | `context, plan` | `sections[{title, lines[]}]` |

`context` is `{ goal, avoiding, mustDo }`. Inputs are validated with zod. Responses use Claude structured outputs, so the JSON always matches the schema.

```sh
cd backend
cp .env.example .env.local   # add ANTHROPIC_API_KEY
npm install
npm run dev
```

Deploy to Vercel with `backend` as the root directory, and set `ANTHROPIC_API_KEY` (and optionally `APP_TOKEN`) in the project's environment variables. The API key never goes in the app.

The backend uses `claude-opus-5` with low effort for fast, short answers, and server-side refusal fallbacks (`fallbacks: "default"`). Override the model with `CLAUDE_MODEL`.

## CI

`.github/workflows/ci.yml` builds the app with `xcodebuild` for the iOS Simulator on macOS and typechecks and builds the backend.
