/**
 * Double Escape to Abort
 *
 * Requires pressing Escape twice within 500ms to abort an operation.
 * First press shows a notification hint. If the second press doesn't
 * come within 500ms, the hint disappears and nothing happens.
 */

import { CustomEditor, type ExtensionAPI, type ExtensionContext } from "@mariozechner/pi-coding-agent";
import { matchesKey } from "@mariozechner/pi-tui";

const TIMEOUT_MS = 500;

class DoubleEscapeEditor extends CustomEditor {
	private pendingEscape = false;
	private escapeTimer: ReturnType<typeof setTimeout> | null = null;
	private ctx: ExtensionContext;

	constructor(tui: any, theme: any, kb: any, ctx: ExtensionContext) {
		super(tui, theme, kb);
		this.ctx = ctx;
	}

	handleInput(data: string): void {
		if (matchesKey(data, "escape")) {
			if (this.pendingEscape) {
				// Second escape within timeout — abort
				this.clearPending();
				super.handleInput(data);
			} else {
				// First escape — show hint, start timer
				this.pendingEscape = true;
				this.ctx.ui.setStatus("double-escape", "Press Escape again to abort");

				this.escapeTimer = setTimeout(() => {
					this.clearPending();
				}, TIMEOUT_MS);
			}
			return;
		}

		super.handleInput(data);
	}

	private clearPending(): void {
		this.pendingEscape = false;
		if (this.escapeTimer) {
			clearTimeout(this.escapeTimer);
			this.escapeTimer = null;
		}
		this.ctx.ui.setStatus("double-escape", undefined);
	}
}

export default function (pi: ExtensionAPI) {
	pi.on("session_start", (_event, ctx) => {
		ctx.ui.setEditorComponent((tui, theme, kb) => new DoubleEscapeEditor(tui, theme, kb, ctx));
	});
}
