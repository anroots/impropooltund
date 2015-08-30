# Syntax {% player %}
#
# Must be used on a page that has a 'mp3' property.


module Jekyll
  class PlayerTag < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
    	url = "http://cdn.pooltund.improv.ee/mp3/" + context.environments.first['page']['mp3']
    	title = context.environments.first['page']['title']

        <<-EOS
<div id="jquery_jplayer_1" class="jp-jplayer"></div>
<div id="jp_container_1" class="jp-audio" role="application" aria-label="media player">
  <div class="jp-type-single">
    <div class="jp-gui jp-interface">
      <div class="jp-volume-controls">
        <button class="jp-mute" role="button" tabindex="0">mute</button>
        <button class="jp-volume-max" role="button" tabindex="0">max volume</button>
        <div class="jp-volume-bar">
          <div class="jp-volume-bar-value"></div>
        </div>
      </div>
      <div class="jp-controls-holder">
        <div class="jp-controls">
          <button class="jp-play" role="button" tabindex="0">play</button>
          <button class="jp-stop" role="button" tabindex="0">stop</button>
        </div>
        <div class="jp-progress">
          <div class="jp-seek-bar">
            <div class="jp-play-bar"></div>
          </div>
        </div>
        <div class="jp-current-time" role="timer" aria-label="time">&nbsp;</div>
        <div class="jp-duration" role="timer" aria-label="duration">&nbsp;</div>
        <div class="jp-toggles">
          <button class="jp-repeat" role="button" tabindex="0">repeat</button>
        </div>
      </div>
    </div>
    <div class="jp-details">
      <div class="jp-title" aria-label="title">&nbsp;</div>
    </div>
    <div class="jp-no-solution">
      <span>Update Required</span>
      To play the media you will need to either update your browser to a recent version or update your <a href="http://get.adobe.com/flashplayer/" target="_blank">Flash plugin</a>.
    </div>
  </div>
</div>

  <script type="text/javascript">
    $(document).ready(function(){
      $("#jquery_jplayer_1").jPlayer({
        ready: function () {
          $(this).jPlayer("setMedia", {
            title: "#{title}",
            mp3: "#{url}"
          });
        },
        cssSelectorAncestor: "#jp_container_1",
        swfPath: "/assets/bower_components/jplayer/dist/jplayer/",
        useStateClassSkin: true,
        smoothPlayBar: true,
        toggleDuration: true
      });
    });
  </script>

<p><a href="#{url}" class="btn">MP3 fail</a></p>
EOS
    end
  end
end

Liquid::Template.register_tag('player', Jekyll::PlayerTag)