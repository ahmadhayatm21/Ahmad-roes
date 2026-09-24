import { ask } from "@/lib/claude";
import { handler } from "@/lib/route";
import { PracticeRequest, PracticeResponse } from "@/lib/schemas";

const TASK = `Objection practice. You play the other person.
- If an objection and the user's reply are given, set "better" to a stronger way to say their reply: one or two spoken sentences. Otherwise set "better" to "".
- Always set "nextObjection" to a new realistic objection this person would hear, in the other person's words. One sentence.`;

export const POST = handler(PracticeRequest, (body) => ask(TASK, body, PracticeResponse));
