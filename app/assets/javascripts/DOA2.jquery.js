(function($) {

    $.DOA2_Image_Generator = function(element, options) {
        var plugin = this;

        var defaults = {
            closeLink: false,
        };

        plugin.settings = {};

        var $element = $(element), element = element;
        var elementId = $element.attr('id');

        var createScopedId = function(subId) {
            return elementId + "-" + subId;
        };

        plugin.init = function() {
            plugin.settings = $.extend({}, defaults, options);

            createCardImageWindow();
            attachEvents();
        };

        var identifiers = {
            imageWindow: createScopedId('image-window'),
            imagePreferences: createScopedId('image-preferences'),
            protraitFile: createScopedId('portrait-file'),
            parchmentInput: createScopedId('parchment'),
            cardImage: createScopedId('card-image'),
            cardCanvas: createScopedId('card-canvas'),
            imageDescription: createScopedId('image-description'),
            progressText: createScopedId('progress-text'),
            cardImageLink: createScopedId('card-image-link'),
            closeImageWindowLink: createScopedId('close-image-window'),

            imageEditorWindow: createScopedId('image-editor-window'),
            imageEditor: createScopedId('image-editor'),
            imageCrop: createScopedId('image-crop'),
        };

        var portraitImage = null;
        var portraitImageTraits = {};
        var imageEditor = null;
        var jcrop = null;
        var imageEditorCount = 0;

        plugin.generateCard = function() {
            DOA2_Image.generateCard({ 
                character: character,
                canvas: document.getElementById(identifiers.cardCanvas),
                cardImage: document.getElementById(identifiers.cardImage),
                cardLink: document.getElementById(identifiers.cardImageLink),
                progressText: $('#' + identifiers.progressText),
                useParchment: $('#' + identifiers.parchmentInput).is(":checked"),
                portraitImage: portraitImage,
                portraitFit: $('#' + identifiers.imagePreferences + ' input[name="portrait-fit"]:checked').val(),
                portraitTraits: portraitImageTraits,
            });
        };

        var createCardImageWindow = function() {
            var editorHtml = 
                "<div class='doa2-image-generator-editor-window' id='" + identifiers.imageEditorWindow + "'>" + 
                "  <button id='" + identifiers.imageCrop + "'>Crop</button>" + 
                "</div>";

            var outerHtml = 
                  "<div id='" + identifiers.imagePreferences + "'>" +
                  editorHtml + 
                  "  Portrait? <input id='" + identifiers.portraitFile + "' type='file' /><br />" +
                  "  <input type='radio' name='portrait-fit' disabled value='Fill' /><label>Fill</label>" +
                  "  <input type='radio' name='portrait-fit' disabled value='Fit' checked /><label>Fit</label>" +
                  "  <input type='radio' name='portrait-fit' disabled value='Original' /><label>Original</label>" +
                  "  <input type='radio' name='portrait-fit' disabled value='Cropped' /><label>Cropped</label>" +
                  "  <br />" +
                  "  Parchment? <input id='" + identifiers.parchmentInput + "' type='checkbox' />" +
                  "</div>" +
                  "<img class='doa2-image-generator-card-image' id='" + identifiers.cardImage + "' width='225' />" +
                  "<canvas id='" + identifiers.cardCanvas + "' width='945' height='1418' style='display: none;'></canvas>" +
                  "<div id='" + identifiers.imageDescription + "'>" +
                  "  <p>" +
                  "    <strong>Only supported in HTML5-capable browsers.</strong>" +
                  "    <strong>Portrait not supported in Safari.</strong>" +
                  "  </p>" +
                  "  <p class='doa2-image-generator-progress-text' id='" + identifiers.progressText + "'></p>" +
                  "  <p>This image is actually much bigger, it's scaled down for this window. To save, either:</p>" +
                  "  <p>" +
                  "    Right-click on the image and 'Save as...', OR<br />" +
                  "    Right-click on the link below and 'Save target as...'" +
                  "  </p>" +
                  "  <p><a target='_blank' id='" + identifiers.cardImageLink + "'>Save Card Image</a>";
            if (plugin.settings.closeLink) {
                outerHtml += "<br /><a href='#' id='" + identifiers.closeImageWindowLink + "'>Close</a>";
            }
            outerHtml +=  "</p></div>";

            $element.html(outerHtml);
        };

        var updatePortraitTraits = function(c) {
            portraitImageTraits.x = Math.round(c.x);
            portraitImageTraits.y = Math.round(c.y);
            portraitImageTraits.width = Math.round(c.w);
            portraitImageTraits.height = Math.round(c.h);
        }

        var attachEvents = function() {
            if (plugin.settings.closeLink) {
                $("#" + identifiers.closeImageWindowLink).click(function (e) {
                    e.preventDefault();
                    $element.toggle(false);
                });
            }

            $("#" + identifiers.portraitFile).change(function() {
                $('#' + identifiers.imagePreferences + ' input[value="Fit"]').prop('checked', true);
                var imageFile = this.files[0];
                var reader = new FileReader();
                reader.onload = function(event) {
                    var content = event.target.result;
                    portraitImage = new Image();
                    portraitImage.src = content;
                    plugin.generateCard();
                    $('#' + identifiers.imagePreferences + ' input[name="portrait-fit"]').prop("disabled", false);
                };
                reader.onerror = function() {
                    console.log("Could not read portrait file.");
                };
                reader.readAsDataURL(imageFile);
            });

            $('#' + identifiers.parchmentInput).change(function() {
                plugin.generateCard();
            });

            $('#' + identifiers.imagePreferences + ' input[name="portrait-fit"]').click(function() {
                if (portraitImage) {
                    plugin.generateCard();
                }
            });

            var cropOption = $('#' + identifiers.imagePreferences + ' input[value="Cropped"]');
            cropOption.unbind('click');
            cropOption.click(function() {
                if (portraitImage) {
                    $('#' + identifiers.imageEditorWindow).toggle(true);

                    if (imageEditor) {
                        imageEditor.remove();
                        imageEditor = null;
                    }
                    if (jcrop) {
                        jcrop.destroy();
                        jcrop = null;
                    }
                    imageEditorCount++;
                    imageEditor = $('<img id="' + identifiers.imageEditor + "-" + imageEditorCount + '">');
                    imageEditor.attr("src", portraitImage.src);
                    $("#" + identifiers.imageEditorWindow).append(imageEditor);
                    imageEditor.Jcrop({
                        onChange: updatePortraitTraits,
                        onSelect: updatePortraitTraits,
                        aspectRatio: 740 / 1204,
                        boxHeight: 400,
                        setSelect: [0, 0, 740, 1204],
                    }, function() { jcrop = this; });
                }
            });

            $('#' + identifiers.imageCrop).click(function() {
                $('#' + identifiers.imageEditorWindow).toggle(false);
                plugin.generateCard();
            });
        };

        plugin.init();
    };

    $.fn.DOA2_Image_Generator = function(options) {
        return this.each(function() {
            if (undefined == $(this).data('DOA2_Image_Generator')) {
                var plugin = new $.DOA2_Image_Generator(this, options);
                $(this).data('DOA2_Image_Generator', plugin);
            }
        });
    };

})(jQuery);
