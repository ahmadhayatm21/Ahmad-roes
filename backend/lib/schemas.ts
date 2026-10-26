import { z } from "zod";

// Request from the app

export const StepRequest = z.object({
  // How the user sees their business, its process and who they'll be. Their words, oldest first.
  picture: z.array(z.string().min(1).max(4000)).min(1).max(30),
  // Steps already done, oldest first.
  done: z.array(z.string().max(300)).max(30).default([]),
  // The step on screen now. Missing on the first step.
  current: z.string().max(300).optional(),
  // start: first step. done: the current step is done. tooBig: split the current step.
  // thought: the user said something new; the last picture entry is the newest.
  event: z.enum(["start", "done", "tooBig", "thought"]),
  // Optional one word after Done, e.g. "scared", "easy", "rejected".
  said: z.string().max(200).optional(),
});

// Response to the app

export const StepResponse = z.object({ step: z.string() });
