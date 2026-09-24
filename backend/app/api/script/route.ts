import { ask } from "@/lib/claude";
import { handler } from "@/lib/route";
import { ScriptRequest, ScriptResponse } from "@/lib/schemas";

const TASK = `The user asked for the full script. Write it following their game plan steps: one section per step, section title = step title, lines = the spoken lines for that step (2-4 short lines each). Natural, spoken, not salesy.`;

export const POST = handler(ScriptRequest, (body) => ask(TASK, body, ScriptResponse));
