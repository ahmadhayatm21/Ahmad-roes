import Anthropic from "@anthropic-ai/sdk";
import { NextResponse } from "next/server";
import type { z } from "zod";
import { CoachError } from "./claude";

// Wraps an endpoint: optional shared-token check, input validation, error mapping.
export function handler<In extends z.ZodType>(
  input: In,
  run: (body: z.infer<In>) => Promise<unknown>,
) {
  return async (req: Request) => {
    const token = process.env.APP_TOKEN;
    if (token && req.headers.get("x-app-token") !== token) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const parsed = input.safeParse(await req.json().catch(() => null));
    if (!parsed.success) {
      return NextResponse.json({ error: "Bad request" }, { status: 400 });
    }

    try {
      return NextResponse.json(await run(parsed.data));
    } catch (err) {
      if (err instanceof CoachError) {
        return NextResponse.json({ error: err.message }, { status: 502 });
      }
      if (err instanceof Anthropic.RateLimitError) {
        return NextResponse.json({ error: "Busy. Try again." }, { status: 429 });
      }
      console.error("Coach request failed", err);
      return NextResponse.json({ error: "Coach unavailable" }, { status: 502 });
    }
  };
}
