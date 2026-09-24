import Anthropic from "@anthropic-ai/sdk";
import { betaZodOutputFormat } from "@anthropic-ai/sdk/helpers/beta/zod";
import type { z } from "zod";

const client = new Anthropic();

const MODEL = process.env.CLAUDE_MODEL ?? "claude-opus-5";

// Shared voice for every endpoint. Short, calm, direct, human.
const VOICE = `You are a calm friend standing next to someone who is about to do the thing they have been avoiding.
Rules:
- No theory. Never teach or explain. Give only what they need for the next move.
- Short, plain, human sentences. Like a friend saying "press the bell."
- Never suggest resting, waiting or rescheduling instead of acting.
- No emojis, no hype, no lists of options. One clear answer.`;

export class CoachError extends Error {}

export async function ask<S extends z.ZodType>(
  task: string,
  input: unknown,
  schema: S,
): Promise<z.infer<S>> {
  const response = await client.beta.messages.parse({
    model: MODEL,
    max_tokens: 4000,
    betas: ["server-side-fallback-2026-07-01"],
    fallbacks: "default",
    output_config: { effort: "low", format: betaZodOutputFormat(schema) },
    system: `${VOICE}\n\n${task}`,
    messages: [{ role: "user", content: JSON.stringify(input) }],
  });

  if (response.stop_reason === "refusal") {
    throw new CoachError("The coach could not answer that one.");
  }
  if (!response.parsed_output) {
    throw new CoachError("The coach returned an unreadable answer.");
  }
  return response.parsed_output;
}
