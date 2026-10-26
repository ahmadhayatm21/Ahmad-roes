# Action

People collect a lot of knowledge and build the whole process in their head. It looks too hard, so they never take the first step.

Action does not teach and does not map the process. It listens to how the user pictures their business and its process, then gives them one tiny first step. After that comes the next step, and the next.

Other apps give knowledge. Action gives steps.

## How it works

1. First run: "Tell me about your business and how you think it'll go." A big mic; typing is a small fallback.
2. The app stores the user's picture of the business and the process, in their words.
3. Main screen: one step, DONE and the mic.
4. DONE: the next step appears right away (it's fetched ahead). An optional one word ("scared", "easy", "rejected") re-chooses it.
5. "Too big", tapped or said: the step is split into a smaller one on the same screen.
6. New thoughts at any time: the user talks, the picture grows and the step is recalculated.

The app keeps the process. The user only ever sees the current step.

**Step rules:** one action, one sentence, starts with a verb, small enough to start within 5 minutes without thinking, built from the user's own picture.

**The test:** if a feature doesn't help the user talk, help the app understand, or give one step, it doesn't ship.

## Layout

```
ios/        SwiftUI app (iOS 17+, SwiftData, Speech)
backend/    Next.js API route that calls Claude. Deploys to Vercel.
```

### iOS app

```
ios/ActionApp/
  App/          entry point and root view
  Models/       Journey: the user's picture, the current step, steps done
  Services/     CoachService protocol + remote, sample and fallback implementations,
                SpeechTranscriber protocol + Apple on-device implementation
  Components/   PrimaryButton, SpeakInput (big mic, typing fallback), ErrorLine
  Features/
    Tell/       first run: picture the business out loud
    Step/       one step, DONE, "Too big" and the mic
```

The Xcode project uses a synchronized folder, so new files under `ios/ActionApp/` are picked up automatically.

Build from the command line:

```sh
xcodebuild -project ios/ActionApp.xcodeproj -scheme ActionApp \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

Or open `ios/ActionApp.xcodeproj` in Xcode 16+ and run.

**Sample data.** With no backend configured, the app uses `SampleCoachService`, a short ladder of stand-in steps. Real steps come from the backend, built from the user's own picture.

**Connect the backend.** Copy `ios/Config/Secrets.example.xcconfig` to `ios/Config/Secrets.xcconfig` and set `BACKEND_HOST` to your Vercel host (no `https://`), plus `APP_TOKEN` if you set one on the server. `Secrets.xcconfig` is git-ignored, so the values stay off GitHub. Rebuild the app. With no host set, the app runs on sample data. If the backend fails, the app falls back to a stand-in step so the user is never stuck.

### Backend

| Endpoint | Body | Returns |
| --- | --- | --- |
| `POST /api/next-step` | `picture[], done[], current?, event, said?` | `step` |

`picture` is the user's own words about their business, oldest first. `event` is `start`, `done`, `tooBig` or `thought`. `said` is the optional one word after DONE. Inputs are validated with zod. Responses use Claude structured outputs, so the JSON always matches the schema.

```sh
cd backend
cp .env.example .env.local   # add ANTHROPIC_API_KEY
npm install
npm run dev
```

Deploy to Vercel with `backend` as the root directory, and set `ANTHROPIC_API_KEY` (and optionally `APP_TOKEN`) in the project's environment variables. The API key never goes in the app.

Check a deployment:

```sh
curl -X POST https://your-project.vercel.app/api/next-step \
  -H 'content-type: application/json' \
  -d '{"picture":["I sell booking software to local gyms. I see owners calling me first."],"event":"start"}'
```

The backend uses `claude-opus-5` with low effort for fast, short answers, and server-side refusal fallbacks (`fallbacks: "default"`). Override the model with `CLAUDE_MODEL`.

## CI

`.github/workflows/ci.yml` builds the app with `xcodebuild` for the iOS Simulator on macOS and typechecks and builds the backend.
