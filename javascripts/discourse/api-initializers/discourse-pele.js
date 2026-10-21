import { apiInitializer } from "discourse/lib/api";
import PeleInline from "../components/pele-inline.gjs";

const SELECTOR = "pre[data-code-wrap=mermaid] > code";
const SAMPLE = "flowchart LR\n  A --> B";

function decorate(element, helper) {
  if (!helper?.renderGlimmer) {
    return;
  }

  element.querySelectorAll(SELECTOR).forEach((code) => {
    const src = code.textContent;

    if (!src.trim()) {
      return;
    }

    const wrapper = document.createElement("div");
    wrapper.classList.add("pele-wrapper");
    helper.renderGlimmer(wrapper, PeleInline, { src });
    code.parentElement.replaceWith(wrapper);
  });
}

export default apiInitializer((api) => {
  api.addComposerToolbarPopupMenuOption({
    icon: "diagram-project",
    label: themePrefix("diagram"),
    action: (toolbarEvent) =>
      toolbarEvent.addText(`\n\`\`\`mermaid\n${SAMPLE}\n\`\`\`\n`),
  });

  api.decorateCookedElement(decorate);
  api.decorateChatMessage?.(decorate);
});
