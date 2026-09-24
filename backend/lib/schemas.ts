import { z } from "zod";

// Requests from the app

export const MissionContext = z.object({
  goal: z.string().min(1).max(500),
  avoiding: z.string().min(1).max(500),
  mustDo: z.string().min(1).max(500),
});
export type MissionContext = z.infer<typeof MissionContext>;

export const FeedbackEntry = z.object({
  step: z.string().max(200),
  whatHappened: z.string().max(1000),
  outcome: z.enum(["did", "partly", "didnt"]),
});

export const GamePlanRequest = MissionContext.extend({
  feedback: z.array(FeedbackEntry).max(10).default([]),
});

export const SayItRequest = z.object({
  intent: z.string().min(1).max(1000),
  context: MissionContext,
  step: z.string().max(200).optional(),
});

export const ObjectionRequest = z.object({
  objection: z.string().min(1).max(1000),
  context: MissionContext,
  step: z.string().max(200).optional(),
});

export const PracticeRequest = z.object({
  context: MissionContext,
  objection: z.string().max(1000).optional(),
  reply: z.string().max(1000).optional(),
});

// Responses to the app. Every field is required so the app can render them directly.

export const PlanStep = z.object({
  title: z.string(),
  action: z.string(),
  firstLine: z.string(),
});

export const DayBlock = z.object({
  time: z.string(),
  title: z.string(),
});

export const GamePlan = z.object({
  title: z.string(),
  opener: z.string(),
  steps: z.array(PlanStep),
  summary: z.string(),
  dayPlan: z.array(DayBlock),
});

export const ScriptRequest = z.object({
  context: MissionContext,
  plan: GamePlan,
});

export const SayItResponse = z.object({ line: z.string() });
export const ObjectionResponse = z.object({ answer: z.string() });
export const PracticeResponse = z.object({
  better: z.string(),
  nextObjection: z.string(),
});
export const ScriptResponse = z.object({
  sections: z.array(z.object({ title: z.string(), lines: z.array(z.string()) })),
});
