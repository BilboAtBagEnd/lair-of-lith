var DOA2_Image = {}

DOA2_Image.IMAGE_PREFIX = "/images/DoAIIBYOCImages/DOAIIBYOC ";

// Parameter keys: 
//   character - DOA2.Character
//   canvas - HTML5 canvas element (direct reference)
//   cardImage - card image tag (direct reference)
//   cardLink - card anchor tag (direct reference)
//   progressText - jQuery that can support HTML content
//   useParchment - use parchment image? (optional; default false)
//   portraitImage - Image already loaded (optional)
//   portraitFit - Fit, Original, Fill, Cropped (optional; default fit)
//   portraitTraits - x, y, width, height (optional)
DOA2_Image.generateCard = function (params) {
    var character = params.character;
    var canvas = params.canvas;
    var cardImage = params.cardImage;
    var cardLink = params.cardLink;
    var progressText = params.progressText;
    var useParchment = params.useParchment;
    var portraitImage = params.portraitImage;
    var portraitFit = params.portraitFit || "Fit";
    var portraitTraits = params.portraitTraits;

    var context = canvas.getContext('2d');
    
    context.clearRect(0, 0, canvas.width, canvas.height);
    cardImage.src = "/images/loading.gif";
    cardLink.href = "";
    progressText.text('Rendering...');
    
    var hasRangedWeapon = character.hasRangedWeapon();
    
    function srcForString(imageType, string) {
        return DOA2_Image.IMAGE_PREFIX + imageType + " " + capitalizeFirstLetter(sanify(string)) + ".png";
    }
    function srcForNumber(imageType, number) {
        return DOA2_Image.IMAGE_PREFIX + imageType + " " + parseInt(number) + ".png";
    }
    
    var imageElements = [
        { src: srcForString("Setting", character.setting), x: 550, y: 65 },
        { src: srcForString("Circle", character.circle), x: 670, y: 65 },
        { src: srcForString("Nature", character.nature), x: 800, y: 65 },

        { src: srcForNumber("Rating Speed", character.speed), x: 798, y: 180 },
        { src: srcForNumber("Rating Health", character.health), x: 798, y: 270 },
        { src: srcForNumber("Rating Wits", character.wits), x: 788, y: 390 },
        { src: srcForNumber("Rating Melee", character.melee), x: 788, y: 450 },
        { src: srcForNumber("Rating Power", character.power), x: 788, y: 510 },
        { src: srcForNumber("Rating Damage", character.damage), x: 788, y: 570 },
        { src: srcForNumber("Rating Aim", character.aim), x: 788, y: 672 },
        { src: srcForNumber("Rating Point", character.point), x: 788, y: 732 },
        { src: srcForNumber("Rating Throw", character['throw']), x: 788, y: 792 },
        { src: srcForNumber("Rating React", character.react), x: 788, y: 894 },
        { src: srcForNumber("Rating Stealth", character.stealth), x: 788, y: 954 },
        { src: srcForNumber("Rating Armor", character.armor), x: 788, y: 1014 },
        { src: srcForNumber("Rating Strength", character.strength), x: 788, y: 1116 },
        { src: srcForNumber("Rating Intellect", character.intellect), x: 788, y: 1176 },
        { src: srcForNumber("Rating Honor", character.honor), x: 788, y: 1236 },
        { src: srcForNumber("Rating Respect", character.respect), x: 788, y: 1296 },
    ];

    var specialImageWidths = { 
        // Bonuses
        Armor: 71,
        "Auto Pistol": 98, 
        "Auto Rifle": 136, 
        Blade: 137,
        Bot: 116,
        Bow: 71,
        Brawler: 136,
        Crossbow: 88,
        "Energy Pistol": 99, 
        "Energy Rifle": 137,
        Gadget: 71,
        Grenade: 70,
        Heavy: 123, 
        "Long Pistol": 133, 
        "Long Rifle": 163,
        Medical: 71,
        Mount: 84,
        Pet: 86,
        "Powder Pistol": 121, 
        "Powder Rifle": 163,
        Revolver: 99,
        Stealth: 78,
        Swing: 137,
        Thrown: 76,
        Thrust: 136,
        Vehicle: 87,
        
        // Cards
        "Cannot Give Away": 163,
        "No Carry Limit": 163, 
        "No Trade": 163,
    };

    var specialX = 777;
    var specialY = 1306;
    var specialImages = false;
    function addSpecialImageElement(imageType, name, number, width) {
        specialImages = true;
        var canonicalName = capitalizeWords(name);
        if (canonicalName == "Gadgets" || canonicalName == "Bots" || canonicalName == "Pets") {
            canonicalName = canonicalName.substring(0, canonicalName.length - 1);
        }
        
        if (!specialImageWidths[canonicalName] && !number) {
            return; // unknown bonus
        }
        
        var widthToSubtract = 0; 
        if (width) { 
            widthToSubtract = width;
        }
        else {
            widthToSubtract = specialImageWidths[canonicalName];
        }
        
        specialX -= widthToSubtract;
        if (specialX < 50) { 
            specialX = 777 - widthToSubtract;
            specialY = specialY - 71; 
        }
        
        var imageSrc; 
        if (width && number) { 
            imageSrc = srcForNumber(imageType + " " + canonicalName, number);
        }
        else {
            imageSrc = srcForString(imageType, canonicalName);
        }
        imageElements.push( {src: imageSrc, x: specialX, y: specialY} );
    }
    
    if (character.cards.noGive) {
        addSpecialImageElement("Card Spec", "Cannot Give Away"); 
    }
    if (character.cards.noTrade) { 
        addSpecialImageElement("Card Spec", "No Trade");
    }
    if (character.cards.noLimit) {
        addSpecialImageElement("Card Spec", "No Carry Limit");
    }
    for (var i = 0; i < character.bonuses.ranged.length; i++) {
        var bonus = character.bonuses.ranged[i];
        addSpecialImageElement("Bonus", bonus);
    }
    for (i = 0; i < character.bonuses.melee.length; i++) {
        var bonus = character.bonuses.melee[i];
        addSpecialImageElement("Bonus", bonus);
    }
    for (i = 0; i < character.bonuses.other.length; i++) {
        var bonus = character.bonuses.other[i];
        addSpecialImageElement("Bonus", bonus);
    }
    if (character.bonuses.armor) {
        addSpecialImageElement("Bonus", "Armor");
    }
    if (character.bonuses.medical) { 
        addSpecialImageElement("Bonus", "Medical");
    }
    if (character.bonuses.stealth) {
        addSpecialImageElement("Bonus", "Stealth");
    }
    if (character.cards.henchmen) {
        addSpecialImageElement("Cards", "Henchmen", character.cards.henchmen, 49);
    }
    if (character.cards.elite) {
        addSpecialImageElement("Cards", "Elite", character.cards.elite, 49);
    }
    if (character.cards.secret) { 
        addSpecialImageElement("Cards", "Secret", character.cards.secret, 49);
    }
    if (character.cards.common) {
        addSpecialImageElement("Cards", "Common", character.cards.common, 49);
    }
    
    var images = [];
    
    function scaleFactor(maxWidth, maxSize, fontFamily, string) {
        var size = maxSize;
        var maxLoops = 36;
        var font = "";
        for (var loop = 0; loop < maxLoops; loop++) {
            font = size + 'px "' + fontFamily + '"';
            context.font = font;
            var metrics = context.measureText(string);
            if (metrics.width <= maxWidth) { 
                break; 
            }
            size -= 2;
        }
        
        return size/maxSize;
    }
    
    var titleScaleFactor = scaleFactor(500, 50, "Eras Bold", character.name);
    
    var textElements = [
        { fill: "#ffffff", font: (50 * titleScaleFactor) + 'px "Eras Demi"', text: character.name, x: 40, y: 110 },
        { fill: "#ffffff", font: (35 * titleScaleFactor) + 'px "Eras Demi"', text: character.title, x: 60, y: 150 }
    ];
    
    var specialTextFontSize = 32;
    
    if (!specialImages) {
        specialY += 71 + specialTextFontSize - 5; // move back to the bottom
    }
    else {
        specialY += specialTextFontSize - 5;
    }
    
    var pastSpecialImages = !specialImages;
    function wrapText(string, fontSize, fontFamily, maxWidth) {
        var words = string.split(" ");
        var fontSpec = fontSize + 'px "' + fontFamily + '"';
        context.font = fontSpec;

        var lines = [];
        var line = "";
        for(var i = 0; i < words.length; i++) {
            var tempLine = line + words[i];
            var metrics = context.measureText(tempLine);
            if (metrics.width > maxWidth) {
                lines.push(line); 
                line = words[i] + " ";
            }
            else {
                line = tempLine + " ";
            }
            
            if (i == (words.length - 1)) {
                // last loop
                lines.push(line);
            }
        }
        
        for(i = lines.length - 1; i >= 0; i--) {
            if (!pastSpecialImages) {
                metrics = context.measureText(lines[i]);
                if (metrics.width + 50 < specialX) {
                    specialY += fontSize * 1.25;
                }
                pastSpecialImages = true;
            }
            specialY -= fontSize + 5; // line spacing
            textElements.push( { fill: "#000000", font: fontSpec, text: lines[i], x: 50, y: specialY } );
        }
    }
    
    for(var i = character.specials.length - 1; i >= 0; i--) {
       wrapText(character.specials[i].description, specialTextFontSize, "Eras Bold", 700);
       specialY -= 10; // paragraph spacing
    }
    
    // Add the bar
    specialY -= specialTextFontSize + 20; // below bar spacing
    imageElements.push(
        { src: srcForString("Altered Bar", character.age), x: 36, y: specialY });

    var specialBoxY = specialY + 17;

    if (hasRangedWeapon) {
        specialY -= 69; // get up past the bar
        imageElements.push({ src: srcForString("Rating Target", character.rangedWeapon.area), x: 655, y: specialY });
        specialY -= 60;
        imageElements.push({ src: srcForNumber("Rating Range", character.rangedWeapon.rangeMax), x: 655, y: specialY });
        specialY -= 60;
        imageElements.push({ src: srcForNumber("Rating OpFire", character.rangedWeapon.opfire), x: 655, y: specialY });
        specialY -= 60;
        imageElements.push({ src: srcForNumber("Rating Damage", character.rangedWeapon.damage), x: 655, y: specialY });
        specialY -= 60;
        imageElements.push({ src: srcForNumber("Rating Power", character.rangedWeapon.power), x: 655, y: specialY });

        specialY -= 2;
        textElements.push({ fill: "#dddd00", font: '28px "Eras Bold"', text: "R", x: 660, y: specialY });
        textElements.push({ fill: "#dddd00", font: '22px "Eras Bold"', text: "ANGED", x: 678, y: specialY }); 
        
        specialY -= 28; // in case anything needs to go above this   
    }
    
    function drawText(textElements) {
        context.textAlign = "left";
        context.textBaseline = "bottom";
        
        for(var i = 0; i < textElements.length; i++) {
            var element = textElements[i];
            
            context.font = element.font;
            context.fillStyle = element.fill;
            context.fillText(element.text, element.x, element.y);
        }
    }

    function loadImages(elements) {
        if (elements.length == 0) {
            // NOW do text. 
            drawText(textElements);
            
            // Finish everything off.
            var dataURL = canvas.toDataURL();
            cardImage.src = dataURL;
            cardLink.href = dataURL;
            progressText.text('Finished.');
        }
        else {
            var element = elements.shift();
            var image = new Image();
            image.onload = function() {
                context.drawImage(image, element.x, element.y); 
                loadImages(elements);
            }
            image.onerror = function () { 
                // Keep going
                console.log("Image not found: " + image.src);
                loadImages(elements)
            };
            images.push(image);
            image.src = element.src;
        }
    }
    
    function loadBaseImages() { 
    
        function continueWithImage() {
            cardImage.src = canvas.toDataURL();
            loadImages(imageElements);
        }
        
        function renderRest() {
            if (useParchment) {
                // Use parchment background for special abilit box
                var parchmentImage = new Image();
                parchmentImage.onload = function() { 
                    var sourceX = 0; 
                    var sourceY = 0;
                    var sourceWidth = 740;
                    var sourceHeight = 1204 - specialBoxY + 173;
                    var destX = 36;
                    var destY = specialBoxY;
                    var destWidth = sourceWidth;
                    var destHeight = sourceHeight;
                    context.drawImage(parchmentImage, sourceX, sourceY, sourceWidth, sourceHeight, destX, destY, destWidth, destHeight);
                    continueWithImage();
                }
                parchmentImage.onerror = function() {
                    console.log("error loading");
                    continueWithImage();
                }
                parchmentImage.src = srcForString("Background", "Parchment");
            } else {
                // draw a translucent rectangle over special ability box
                context.fillStyle = "rgba(255, 255, 255, 0.80)";
                context.fillRect(36, specialBoxY, 740,  1204 - specialBoxY + 173); 
                continueWithImage();
            }
        }
    
        var backImage = new Image();
        backImage.onload = function() { 
            context.drawImage(backImage, 0, 0);

            if (portraitImage) {
                switch(portraitFit) {
                case "Fit":
                    var aspectRatioX = 740 / portraitImage.width;
                    var aspectRatioY = 1204 / portraitImage.height;
                    var aspectRatio = 1.0;
                    if ((aspectRatioY * portraitImage.width) > 740) {
                        aspectRatio = aspectRatioX;
                    }
                    else {
                        aspectRatio = aspectRatioY;
                    }
                    context.drawImage(portraitImage, 36, 173, Math.min(740, portraitImage.width * aspectRatio), Math.min(1204, portraitImage.height * aspectRatio));
                    break;
                    
                case "Original":
                    var sourceX = 0; 
                    var sourceY = 0;
                    var sourceWidth = Math.min(740, portraitImage.width);
                    var sourceHeight = Math.min(1204, portraitImage.height);
                    var destX = 36;
                    var destY = 173;
                    var destWidth = sourceWidth;
                    var destHeight = sourceHeight;
                    context.drawImage(portraitImage, sourceX, sourceY, sourceWidth, sourceHeight, destX, destY, destWidth, destHeight);
                    break;
                    
                case "Cropped":
                    var sourceX = portraitTraits.x;
                    var sourceY = portraitTraits.y;
                    var sourceWidth = portraitTraits.width;
                    var sourceHeight = portraitTraits.height;
                    var destX = 36;
                    var destY = 173;
                    var destWidth = 740;
                    var destHeight = 1204;

                    context.drawImage(portraitImage, sourceX, sourceY, sourceWidth, sourceHeight, destX, destY, destWidth, destHeight);
                    break;
                    
                case "Fill":
                    context.drawImage(portraitImage, 36, 173, 740, 1204);
                    break;
                }
            }
            
            renderRest();
        }
        backImage.onerror = function() {
            // Keep going
            console.log("Could not find image for background");
            loadImages(imageElements);
        }
        backImage.src = srcForString("Altered Character Card", character.age);
    }

    loadBaseImages();
}
