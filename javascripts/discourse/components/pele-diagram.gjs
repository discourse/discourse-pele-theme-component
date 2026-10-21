import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { modifier } from "ember-modifier";
import loadScript from "discourse/lib/load-script";
import DFlashMessage from "discourse/ui-kit/d-flash-message";
import { i18n } from "discourse-i18n";

export const ZOOM_ALWAYS = "always";

const LINK_SCHEMES = ["http", "https", "mailto"];
const LINK_REL = "noopener nofollow ugc";

export default class PeleDiagram extends Component {
  @tracked error;

  mount = modifier((element, [src, zoom]) => {
    let diagram;
    let destroyed = false;

    loadScript(settings.theme_uploads_local.pele_js)
      .then(() => {
        if (destroyed) {
          return;
        }

        diagram = window.pele.mount(element, src, {
          linkSchemes: LINK_SCHEMES,
          linkRel: LINK_REL,
          images: false,
          zoom: zoom === ZOOM_ALWAYS && {
            always: true,
            labels: {
              zoomIn: i18n(themePrefix("zoom_in")),
              zoomOut: i18n(themePrefix("zoom_out")),
              reset: i18n(themePrefix("reset_zoom")),
            },
          },
          onError: (error) => this.#fail(error),
        });
      })
      .catch((error) => this.#fail(error));

    return () => {
      destroyed = true;
      diagram?.destroy();
    };
  });

  #fail(error) {
    this.error = i18n(themePrefix("rendering_error"), {
      message: error?.message ?? String(error),
    });
  }

  <template>
    <div class="pele-diagram">
      {{#if this.error}}
        <DFlashMessage
          class="pele-diagram__error"
          @flash={{this.error}}
          @type="error"
        />
      {{else}}
        <div class="pele-diagram__canvas" {{this.mount @src @zoom}}></div>
      {{/if}}
    </div>
  </template>
}
