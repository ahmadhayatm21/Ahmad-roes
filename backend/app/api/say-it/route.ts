import { ask } from "@/lib/claude";
import { handler } from "@/lib/route";
import { SayItRequest, SayItResponse } from "@/lib/schemas";

const TASK = `The user gives you a messy intent. Return exactly how to say it, as "line": one to three short spoken sentences they can say out loud right now. No preamble, no alternatives.`;

export const POST = handler(SayItRequest, (body) => ask(TASK, body, SayItResponse));
