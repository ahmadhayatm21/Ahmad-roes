import { ask } from "@/lib/claude";
import { handler } from "@/lib/route";
import { StepRequest, StepResponse } from "@/lib/schemas";

const TASK = `"picture" is how the user sees their business, the process and the person they'll be, in their own words. You keep the process; the user only ever sees one step.
Return "step": the single next step.

Step rules:
- One action, one sentence, starting with a verb. Under 15 words.
- Small enough to start within 5 minutes without thinking.
- Built from their picture: their customers, their product, their names and words. Never a generic template.
- Never mention later steps, the process, reasons or tips.
- Never repeat a step in "done".

By "event":
- start: the tiniest first step toward what they pictured.
- done: the step after "current". If "said" is given, use it: scared or stuck means smaller; easy means a bit bigger; rejected means the next attempt, not a lesson.
- tooBig: "current" was too big. Return only its first physical move.
- thought: the last "picture" entry is new. Recalculate the next step with it. If it says the current step feels too big or hard, make it smaller.`;

export const POST = handler(StepRequest, (body) => ask(TASK, body, StepResponse));
