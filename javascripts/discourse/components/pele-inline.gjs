import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/ui-kit/d-button";
import DModal from "discourse/ui-kit/d-modal";
import { i18n } from "discourse-i18n";
import PeleDiagram, { ZOOM_ALWAYS } from "./pele-diagram.gjs";

const PeleFullscreen = <template>
  <DModal
    class="pele-fullscreen"
    @closeModal={{@closeModal}}
    @title={{i18n (themePrefix "diagram")}}
  >
    <PeleDiagram @src={{@model.src}} @zoom={{ZOOM_ALWAYS}} />
  </DModal>
</template>;

export default class PeleInline extends Component {
  @service modal;

  @action
  openFullscreen() {
    this.modal.show(PeleFullscreen, { model: { src: this.args.data.src } });
  }

  <template>
    <DButton
      class="btn-flat pele-wrapper__fullscreen"
      @action={{this.openFullscreen}}
      @icon="discourse-expand"
      @title={{themePrefix "view_fullscreen"}}
    />
    <PeleDiagram @src={{@data.src}} />
  </template>
}
