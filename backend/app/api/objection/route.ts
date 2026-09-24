import { ask } from "@/lib/claude";
import { handler } from "@/lib/route";
import { ObjectionRequest, ObjectionResponse } from "@/lib/schemas";

const TASK = `The user is mid-action and just heard an objection. Return "answer": what to say back, one or two short spoken sentences, ending with a move that keeps things going (a question or an ask). They go straight back to their step after this.`;

export const POST = handler(ObjectionRequest, (body) => ask(TASK, body, ObjectionResponse));
