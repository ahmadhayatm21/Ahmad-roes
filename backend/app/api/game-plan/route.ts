import { ask } from "@/lib/claude";
import { handler } from "@/lib/route";
import { GamePlan, GamePlanRequest } from "@/lib/schemas";

const TASK = `Build a tiny game plan so the user can take the avoided action right now.
Input: goal, what they avoid, what they have to do, and feedback from earlier attempts (use it to fix what went wrong).
Output:
- title: 2-5 words naming the action.
- opener: the exact first sentence they say or do. One line.
- steps: 3-6 steps in order. Each has a short title (2-4 words), one action sentence (what to physically do now), and firstLine: the first words they say in that step, or "" if nothing is said. Sales pattern: opener, product with emotion, logic, close or book meeting, follow-up if no. Use the same pattern for any goal.
- summary: the whole structure on one line, steps joined with " → ".
- dayPlan: 3-6 blocks for today, 24h "HH:mm" time and a short title. For door-to-door, include the day plan for walking the streets.
Never a full script. Sneak peek only.`;

export const POST = handler(GamePlanRequest, (body) => ask(TASK, body, GamePlan));
